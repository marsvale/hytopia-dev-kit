#!/bin/bash

# Repository Manager for Hytopia Development Kit
# Handles dynamic repository management, health checks, and updates
# Expects repositories to be configured in CUSTOM_REPOS as a YAML-style list:
# CUSTOM_REPOS="
# - https://github.com/username/repo1.git
# - https://github.com/username/repo2.git
# "

set -e

REPO_BASE_DIR="/app/games/custom-repos"
REPO_STATE_DIR="/app/state/repos"
LOG_FILE="/app/logs/repo-manager.log"

# Ensure required directories exist
mkdir -p "$REPO_BASE_DIR" "$REPO_STATE_DIR" "$(dirname "$LOG_FILE")"

# Logging function
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Health check function
check_repo_health() {
    local repo_path="$1"
    local repo_name="$2"
    
    if [ ! -d "$repo_path/.git" ]; then
        log "ERROR: $repo_name is not a valid git repository"
        return 1
    fi
    
    if ! git -C "$repo_path" remote -v > /dev/null; then
        log "ERROR: $repo_name has invalid remote configuration"
        return 1
    fi
    
    # Check for Hytopia configuration
    if [ ! -f "$repo_path/hytopia.config.js" ] && [ ! -f "$repo_path/hytopia.config.ts" ]; then
        log "WARNING: $repo_name missing Hytopia configuration"
        return 0  # Non-fatal warning
    fi
    
    return 0
}

# Clone/Update repository function
process_repository() {
    local repo_url="$1"
    local repo_name=$(basename "$repo_url" .git)
    local repo_path="$REPO_BASE_DIR/$repo_name"
    local state_file="$REPO_STATE_DIR/$repo_name.state"
    
    log "Processing repository: $repo_name"
    
    if [ -d "$repo_path" ]; then
        log "Updating existing repository: $repo_name"
        if ! git -C "$repo_path" pull origin main; then
            log "ERROR: Failed to update $repo_name"
            return 1
        fi
    else
        log "Cloning new repository: $repo_name"
        if ! git clone "$repo_url" "$repo_path"; then
            log "ERROR: Failed to clone $repo_name"
            return 1
        fi
    fi
    
    # Perform health check
    if ! check_repo_health "$repo_path" "$repo_name"; then
        log "ERROR: Health check failed for $repo_name"
        return 1
    fi
    
    # Update state file
    echo "$(date +'%Y-%m-%d %H:%M:%S')" > "$state_file"
    echo "$repo_url" >> "$state_file"
    git -C "$repo_path" rev-parse HEAD >> "$state_file"
    
    log "Successfully processed $repo_name"
    return 0
}

# Main function to process all repositories
process_all_repositories() {
    # Parse repository list from YAML-style list
    if [ -z "$CUSTOM_REPOS" ]; then
        log "No custom repositories configured"
        return 0
    fi
    
    # Convert YAML list to array
    local repos=()
    while IFS= read -r line; do
        # Skip empty lines and non-repo lines
        if [[ "$line" =~ ^[[:space:]]*-[[:space:]]*(.*) ]]; then
            repos+=("${BASH_REMATCH[1]}")
        fi
    done <<< "$CUSTOM_REPOS"
    
    if [ ${#repos[@]} -eq 0 ]; then
        log "No custom repositories configured"
        return 0
    fi
    
    log "Found ${#repos[@]} repositories to process"
    
    # Process repositories in parallel
    local pids=()
    for repo_url in "${repos[@]}"; do
        process_repository "$repo_url" &
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
        log "ERROR: $failed repository operations failed"
        return 1
    fi
    
    log "All repositories processed successfully"
    return 0
}

# Run main function
process_all_repositories 