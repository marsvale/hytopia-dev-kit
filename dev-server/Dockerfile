FROM oven/bun:1.0.25-slim

RUN apt-get update && apt-get install -y \
    curl \
    git \
    python3 \
    python3-pip \
    jq \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN pip3 install pyyaml
RUN bun install -g hytopia

COPY utils/generate_config.py /app/utils/
COPY utils/setup-examples.sh /app/utils/
COPY cloudflared/config.template.yml /app/cloudflared/

RUN chmod +x /app/utils/setup-examples.sh

# Generate config and setup examples before starting
CMD ["sh", "-c", "python3 utils/generate_config.py && ./utils/setup-examples.sh && bunx hytopia init && bun --watch index.ts"]

EXPOSE 8080 