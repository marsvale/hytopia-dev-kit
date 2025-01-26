#!/bin/bash

# Check if official examples are enabled
if [ "$ENABLE_OFFICIAL_EXAMPLES" = "true" ]; then
    # Get list of example folders from GitHub API
    examples=$(curl -s https://api.github.com/repos/hytopiagg/sdk/contents/examples | jq -r '.[] | select(.type=="dir") | .name')

    # Create examples directory
    mkdir -p examples/hytopia

    # Store original location
    original_dir=$(pwd)

    # For each example directory
    for example in $examples; do
        echo "Initializing $example example..."
        
        # Create and navigate to example directory
        mkdir -p "examples/hytopia/$example"
        cd "examples/hytopia/$example"
        
        # Initialize example
        bunx hytopia init --template "$example"
        
        # Return to original location
        cd "$original_dir"
    done
else
    echo "Official examples are disabled. Set ENABLE_OFFICIAL_EXAMPLES=true to initialize them."
fi 