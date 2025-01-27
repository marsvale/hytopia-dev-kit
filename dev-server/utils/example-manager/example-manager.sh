#!/bin/bash

# Example Manager for Hytopia Development Kit
# Handles example fetching, versioning, and updates

set -e

EXAMPLES_BASE_DIR="/app/games/examples"
EXAMPLES_STATE_DIR="/app/state/examples"
LOG_FILE="/app/logs/example-manager.log"
BACKUP_DIR="/app/backups/examples"

# Ensure required directories exist
mkdir -p "$EXAMPLES_BASE_DIR" "$EXAMPLES_STATE_DIR" "$(dirname "$LOG_FILE")" "$BACKUP_DIR"

# Logging function
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Backup function
backup_example() {
    local example_name="$1"
    local example_path="$EXAMPLES_BASE_DIR/$example_name"
    local backup_path="$BACKUP_DIR/${example_name}_$(date +'%Y%m%d_%H%M%S')"
    
    if [ -d "$example_path" ]; then
        log "Creating backup of $example_name"
        cp -r "$example_path" "$backup_path"
        echo "$backup_path"
        return 0
    fi
    
    return 1
}

# Version check function
check_example_version() {
    local example_name="$1"
    local state_file="$EXAMPLES_STATE_DIR/$example_name.state"
    local current_version=""
    
    if [ -f "$state_file" ]; then
        current_version=$(head -n 1 "$state_file")
    fi
    
    # Get latest version from Hytopia SDK
    local latest_version=$(curl -s "https://api.github.com/repos/hytopiagg/sdk/contents/examples/$example_name" | jq -r '.sha')
    
    if [ "$current_version" != "$latest_version" ]; then
        echo "$latest_version"
        return 1
    fi
    
    return 0
}

# Initialize/Update example function
process_example() {
    local example_name="$1"
    local example_path="$EXAMPLES_BASE_DIR/$example_name"
    local state_file="$EXAMPLES_STATE_DIR/$example_name.state"
    
    log "Processing example: $example_name"
    
    # Check if update is needed
    local new_version=""
    if ! new_version=$(check_example_version "$example_name"); then
        # Backup existing example if it exists
        if [ -d "$example_path" ]; then
            local backup_path=""
            if ! backup_path=$(backup_example "$example_name"); then
                log "ERROR: Failed to backup $example_name"
                return 1
            fi
            log "Backed up $example_name to $backup_path"
        fi
        
        # Create/Update example
        mkdir -p "$example_path"
        if ! bunx hytopia init --template "$example_name"; then
            log "ERROR: Failed to initialize $example_name"
            return 1
        fi
        
        # Update state file
        echo "$new_version" > "$state_file"
        date +'%Y-%m-%d %H:%M:%S' >> "$state_file"
        
        log "Successfully updated $example_name to version $new_version"
    else
        log "$example_name is up to date"
    fi
    
    return 0
}

# Main function to process all examples
process_all_examples() {
    # Get list of examples from Hytopia SDK
    local examples=$(curl -s https://api.github.com/repos/hytopiagg/sdk/contents/examples | jq -r '.[] | select(.type=="dir") | .name')
    
    if [ -z "$examples" ]; then
        log "ERROR: Failed to fetch example list from Hytopia SDK"
        return 1
    fi
    
    log "Found examples to process: $examples"
    
    # Process examples in parallel
    local pids=()
    for example in $examples; do
        process_example "$example" &
        pids+=($!)
    done
    
    # Wait for all processes to complete
    local failed=0
    for pid in "${pids[@]}"; do
        if ! wait "$pid"; then
            failed=$((failed + 1))
        fi
    done
    
    if [ $failed -gt 0 ]; then
        log "ERROR: $failed example operations failed"
        return 1
    fi
    
    log "All examples processed successfully"
    return 0
}

# Cleanup old backups (keep last 5 for each example)
cleanup_old_backups() {
    log "Cleaning up old backups..."
    for example in "$EXAMPLES_BASE_DIR"/*; do
        local example_name=$(basename "$example")
        local backup_count=$(ls -1 "$BACKUP_DIR/${example_name}_"* 2>/dev/null | wc -l)
        
        if [ "$backup_count" -gt 5 ]; then
            ls -1t "$BACKUP_DIR/${example_name}_"* | tail -n +6 | xargs rm -rf
            log "Cleaned up old backups for $example_name"
        fi
    done
}

# Run main functions
process_all_examples
cleanup_old_backups 