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

# Create app directory
WORKDIR /app

# Install Hytopia CLI globally
RUN bun install -g hytopia

# Set up shell
SHELL ["/bin/bash", "-c"]

# Keep container running
CMD ["tail", "-f", "/dev/null"]

# Ensure the paths are correct relative to the build context
COPY cloudflared/config.template.yml /app/cloudflared/
COPY dev-server/utils/generate_config.py /app/utils/
COPY dev-server/utils/setup-examples.sh /app/utils/
COPY dev-server/utils/setup-env.sh /app/setup-env.sh

RUN chmod +x /app/utils/setup-examples.sh
RUN chmod +x /app/setup-env.sh

# Combine CMD and ENTRYPOINT
ENTRYPOINT ["/bin/sh", "-c", "/app/setup-env.sh && python3 utils/generate_config.py && ./utils/setup-examples.sh && bunx hytopia init && bun --watch index.ts"]

EXPOSE 8080 