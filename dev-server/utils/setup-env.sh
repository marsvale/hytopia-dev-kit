#!/bin/bash

# If .env exists, just validate it
if [ -f ".env" ]; then
    echo "Found existing .env file, validating configuration..."
else
    echo "Creating .env file from template..."
    cp .env.example .env
    echo ".env file created. Please update with your configuration."
    echo "You may need to restart the container after updating .env"
fi

# Check required variables
REQUIRED_VARS=(
    "POSTGRES_USER"
    "POSTGRES_PASSWORD"
    "POSTGRES_DB"
    "N8N_ENCRYPTION_KEY"
    "N8N_USER_MANAGEMENT_JWT_SECRET"
)

MISSING_VARS=0
for VAR in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!VAR}" ]; then
        echo "Warning: $VAR is not set in .env"
        MISSING_VARS=1
    fi
done

# Check for Cloudflare configuration
if [ -z "$CLOUDFLARE_TUNNEL_TOKEN" ] || [ -z "$TUNNEL_ID" ] || [ -z "$TUNNEL_DOMAIN" ]; then
    echo "Notice: Cloudflare tunnel not configured. Development server will be available locally only."
    echo "Local URLs:"
    echo "- Main: http://localhost:8080"
    echo "- Examples: http://localhost:8080/examples"
    echo "- Games: http://localhost:8080/games/{game-name}"
else
    echo "Cloudflare tunnel configured. URLs will be available through your domain."
fi

# Clone game repositories
mkdir -p /app/games
cd /app/games

# Clone Marsvale AI Agents
echo "Cloning Marsvale AI Agents..."
git clone https://github.com/marsvale/marsvale-ai-agents.git marsvale

echo "Environment configuration check complete." 