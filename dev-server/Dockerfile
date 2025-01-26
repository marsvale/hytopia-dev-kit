FROM oven/bun:latest

# Install required packages
RUN apt-get update && apt-get install -y \
    git \
    curl \
    jq \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip3 install pyyaml

# Create app directory structure
WORKDIR /app
RUN mkdir -p \
    /app/games/examples \
    /app/games/custom-repos \
    /app/state/repos \
    /app/state/examples \
    /app/logs \
    /app/backups/examples

# Install Hytopia CLI globally
RUN bun install -g hytopia

# Copy utility scripts
COPY utils /app/core/utils/
RUN chmod +x /app/core/utils/setup-env.sh \
    /app/core/utils/repo-manager/repo-manager.sh \
    /app/core/utils/example-manager/example-manager.sh

# Keep container running and provide shell access
SHELL ["/bin/bash", "-c"]
CMD ["tail", "-f", "/dev/null"]

EXPOSE 8080 