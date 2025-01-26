#!/bin/bash

# Hytopia Development Kit Setup Script
# Handles environment setup and initialization

set -e

# Initialize logging
LOG_FILE="/app/logs/setup.log"
mkdir -p "$(dirname "$LOG_FILE")"

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Environment setup
setup_environment() {
    log "Setting up environment..."
    
    # If .env exists, validate it
    if [ -f ".env" ]; then
        log "Found existing .env file, validating configuration..."
    else
        log "Creating .env file..."
        cat <<EOL > .env
# Hytopia Development Kit Configuration

# Repository Configuration
# Add as many CUSTOM_REPO_* entries as needed
# Example:
# CUSTOM_REPO_1=https://github.com/username/repo1.git
# CUSTOM_REPO_2=https://github.com/username/repo2.git
CUSTOM_REPO_1=${CUSTOM_REPO_1:-}

# Example Configuration
ENABLE_OFFICIAL_EXAMPLES=true

# Cloudflare Configuration (Optional)
CLOUDFLARE_TUNNEL_TOKEN=${CLOUDFLARE_TUNNEL_TOKEN:-}
TUNNEL_DOMAIN=${TUNNEL_DOMAIN:-}
CUSTOM_DOMAIN=${CUSTOM_DOMAIN:-}
CUSTOM_DOMAIN_DNS_RECORD=${CUSTOM_DOMAIN_DNS_RECORD:-}

# Development Configuration
HYTOPIA_PORT=${HYTOPIA_PORT:-8080}
EOL
        log ".env file created. Please update with your configuration."
    fi
}

# Initialize directories
init_directories() {
    log "Initializing directory structure..."
    
    mkdir -p \
        /app/games/examples \
        /app/games/custom-repos \
        /app/state/repos \
        /app/state/examples \
        /app/logs \
        /app/backups/examples
}

# Run managers
run_managers() {
    log "Running repository and example managers..."
    
    # Make scripts executable
    chmod +x /app/core/utils/repo-manager/repo-manager.sh
    chmod +x /app/core/utils/example-manager/example-manager.sh
    
    # Run example manager if enabled
    if [ "${ENABLE_OFFICIAL_EXAMPLES:-true}" = "true" ]; then
        log "Processing official examples..."
        if ! /app/core/utils/example-manager/example-manager.sh; then
            log "WARNING: Some examples failed to process"
        fi
    else
        log "Official examples are disabled"
    fi
    
    # Run repository manager
    log "Processing custom repositories..."
    if ! /app/core/utils/repo-manager/repo-manager.sh; then
        log "WARNING: Some repositories failed to process"
    fi
}

# Configure Cloudflare
setup_cloudflare() {
    if [ -n "$CLOUDFLARE_TUNNEL_TOKEN" ] && [ -n "$TUNNEL_DOMAIN" ]; then
        log "Configuring Cloudflare tunnel..."
        python3 /app/core/utils/generate_config.py
        
        if [ -n "$CUSTOM_DOMAIN" ]; then
            log "Custom domain configured: $CUSTOM_DOMAIN"
        fi
    else
        log "Cloudflare tunnel not configured. Development server will be available locally only."
        log "Local URLs:"
        log "- Main: http://localhost:${HYTOPIA_PORT:-8080}"
        log "- Examples: http://localhost:${HYTOPIA_PORT:-8080}/examples"
        log "- Games: http://localhost:${HYTOPIA_PORT:-8080}/games/{game-name}"
    fi
}

print_usage() {
    echo "Environment setup complete. To start a game server:"
    echo ""
    echo "For examples:"
    echo "  cd /app/games/examples/<example-name>"
    echo "  bun --watch index.ts"
    echo ""
    echo "For custom repositories:"
    echo "  cd /app/games/custom-repos/<repo-name>"
    echo "  bun --watch index.ts"
    echo ""
    echo "Available examples:"
    ls -1 /app/games/examples 2>/dev/null || echo "No examples available"
    echo ""
    echo "Available custom repositories:"
    ls -1 /app/games/custom-repos 2>/dev/null || echo "No custom repositories available"
}

# Main setup process
main() {
    log "Starting Hytopia Development Kit setup..."
    
    setup_environment
    init_directories
    run_managers
    setup_cloudflare
    
    log "Setup complete!"
    print_usage
    
    # Keep container running
    tail -f /dev/null
}

# Run main setup
main 