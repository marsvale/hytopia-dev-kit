# Hytopia Development Kit

A dynamic Docker-based development environment for Hytopia game development. This toolkit provides an automated setup for both official Hytopia game examples and custom game repositories.

## 🎮 Features

- **Dynamic Example Games**: Automatically fetches and sets up the latest official Hytopia game examples
- **Dynamic Custom Repository Support**: Add any number of your own game repositories via environment variables
- **Docker-Powered**: Containerized development environment for consistent development experience
- **Multiplayer Testing**: Built-in support for testing multiplayer functionality
- **Zero Configuration**: Works out of the box with example games
- **Flexible Setup**: Works with or without custom repositories

## 🚀 Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/hytopia-dev-kit.git
   cd hytopia-dev-kit
   ```

2. Create required directories:
   ```bash
   mkdir -p examples custom-repos state logs backups cloudflared
   ```

3. Configure your environment:
   ```bash
   cp .env.example .env
   ```
   Edit `.env` to add your custom repositories:
   ```env
   # Add as many repositories as needed
   CUSTOM_REPO_1=https://github.com/username/repo1.git
   CUSTOM_REPO_2=https://github.com/username/repo2.git
   
   # Optional: Configure multiplayer testing
   CLOUDFLARE_TUNNEL_TOKEN=your_token
   TUNNEL_DOMAIN=your_domain
   ```

4. Start the development environment:
   ```bash
   docker-compose up --build
   ```

5. Running Games:
   
   Open a new terminal and connect to the container:
   ```bash
   docker exec -it hytopia-dev-kit-hytopia-dev-1 bash
   ```

   To run an example game:
   ```bash
   cd /app/games/examples/<example-name>
   bun --watch index.ts
   ```

   To run a custom repository game:
   ```bash
   cd /app/games/custom-repos/<repo-name>
   bun --watch index.ts
   ```

   To run multiple games simultaneously, open additional terminals and repeat the process.

## 🔧 Configuration

### Environment Variables

- `CUSTOM_REPO_*`: Add any number of custom repositories (e.g., CUSTOM_REPO_1, CUSTOM_REPO_2, etc.)
- `ENABLE_OFFICIAL_EXAMPLES`: Set to false to disable official examples (default: true)
- `HYTOPIA_PORT`: Port for the development server (default: 8080)
- `CLOUDFLARE_TUNNEL_TOKEN`: (Optional) For multiplayer testing
- `TUNNEL_DOMAIN`: (Optional) Base domain for multiplayer testing
- `CUSTOM_DOMAIN`: (Optional) Your own domain for multiplayer testing
- `CUSTOM_DOMAIN_DNS_RECORD`: (Optional) DNS record for your custom domain

### Directory Structure

```
hytopia-dev-kit/
├── examples/           # Official Hytopia examples
├── custom-repos/       # Your custom game repositories
├── state/             # State tracking for repos and examples
├── logs/              # System and operation logs
├── backups/           # Automatic backups
├── cloudflared/       # Cloudflare tunnel configuration
├── dev-server/        # Development server code
└── .env              # Environment configuration
```

## 🎮 Multiplayer Testing

The development kit includes built-in support for multiplayer testing. To use it:

1. Configure Cloudflare in your `.env`:
   ```env
   CLOUDFLARE_TUNNEL_TOKEN=your_token
   TUNNEL_DOMAIN=your_domain
   ```

2. (Optional) Set up a custom domain:
   ```env
   CUSTOM_DOMAIN=yourdomain.com
   CUSTOM_DOMAIN_DNS_RECORD=dev.yourdomain.com
   ```

3. Access your game:
   - Via play.hytopia.com: `https://play.hytopia.com?join=your-tunnel-url`
   - Via custom domain: `https://dev.yourdomain.com`

## 📝 Development Log

### Version 0.1.0 (Initial Release)
- Basic project structure established
- Docker environment setup
- Dynamic example game integration
- Custom repository support
- Optional multiplayer testing support

### Version 0.2.0 (Current)
- Dynamic repository management with parallel processing
- Example management with version tracking and backups
- Separate environment setup from game server startup
- Interactive development environment
- Enhanced logging and health checks

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

[Add appropriate license information]

## 🔗 Links

- [Hytopia Official Documentation](https://docs.hytopia.com)
- [Docker Documentation](https://docs.docker.com)
- [Cloudflare Tunnels Documentation](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps) 