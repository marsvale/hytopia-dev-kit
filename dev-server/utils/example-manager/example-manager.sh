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

# Main function to process all examples
process_all_examples() {
    local sdk_path="/tmp/hytopia-sdk"
    
    # Clone the SDK repository first
    log "Cloning Hytopia SDK repository..."
    rm -rf "$sdk_path"
    if ! git clone --depth 1 https://github.com/hytopiagg/sdk.git "$sdk_path"; then
        log "ERROR: Failed to clone SDK repository"
        return 1
    fi
    
    # Get list of examples directly from cloned repository
    if [ ! -d "$sdk_path/examples" ]; then
        log "ERROR: Examples directory not found in SDK"
        return 1
    fi
    
    local examples=$(ls -1 "$sdk_path/examples")
    if [ -z "$examples" ]; then
        log "ERROR: No examples found in SDK"
        return 1
    fi
    
    log "Found examples to process: $examples"
    
    # Process examples sequentially
    local failed=0
    for example in $examples; do
        if [ -d "$sdk_path/examples/$example" ]; then
            local example_path="$EXAMPLES_BASE_DIR/$example"
            local state_file="$EXAMPLES_STATE_DIR/$example.state"
            
            # Backup existing example if it exists
            if [ -d "$example_path" ]; then
                local backup_path=""
                if ! backup_path=$(backup_example "$example"); then
                    log "ERROR: Failed to backup $example"
                    failed=$((failed + 1))
                    continue
                fi
                log "Backed up $example to $backup_path"
            fi
            
            # Copy example files
            rm -rf "$example_path"
            mkdir -p "$example_path"
            if ! cp -R "$sdk_path/examples/$example/." "$example_path/"; then
                log "ERROR: Failed to copy files for $example"
                failed=$((failed + 1))
                continue
            fi
            
            # Update state file with commit SHA
            local version=$(cd "$sdk_path" && git rev-parse HEAD)
            echo "$version" > "$state_file"
            date +'%Y-%m-%d %H:%M:%S' >> "$state_file"
            
            log "Successfully updated $example to version $version"
        fi
    done
    
    # Keep SDK repository for debugging
    # rm -rf "$sdk_path"
    
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