# Hytopia Development Kit

A dynamic Docker-based development environment for Hytopia game development. This toolkit provides an automated setup for both official Hytopia game examples and custom game repositories.

## 🎮 Features

- **Dynamic Example Games**: Automatically fetches and sets up the latest official Hytopia game examples
- **Dynamic Custom Repository Support**: Add any number of your own game repositories via environment variables
- **Docker-Powered**: Containerized development environment for consistent development experience
- **Cloudflare Tunnels Support**: Optional integration with Cloudflare for remote access
- **Zero Configuration**: Works out of the box with example games
- **Flexible Setup**: Works with or without custom repositories

## 🚀 Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/hytopia-dev-kit.git
   cd hytopia-dev-kit
   ```

2. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

3. (Optional) Configure custom repositories in `.env`:
   ```env
   # Add as many CUSTOM_REPO_* entries as needed
   CUSTOM_REPO_1=https://github.com/username/repo1.git
   CUSTOM_REPO_2=https://github.com/username/repo2.git
   CUSTOM_REPO_N=https://github.com/username/repoN.git
   ```

4. Start the development environment:
   ```bash
   docker-compose up
   ```

## 🔧 Configuration

### Environment Variables

- `CUSTOM_REPO_*`: URLs for custom game repositories (use sequential numbers, e.g., CUSTOM_REPO_1, CUSTOM_REPO_2, etc.)
- `CLOUDFLARE_TOKEN`: (Optional) Cloudflare API token for tunnel setup
- `TUNNEL_NAME`: (Optional) Custom name for your Cloudflare tunnel
- `CUSTOM_DOMAIN`: (Optional) Your Cloudflare-managed domain for the development environment
- `CUSTOM_DOMAIN_DNS_RECORD`: (Optional) DNS record for your custom domain

### Directory Structure

```
hytopia-dev-kit/
├── examples/           # Dynamically populated with official examples
├── custom-repos/       # Your custom repositories
├── docker/            # Docker configuration files
└── .env              # Environment configuration
```

## 🎯 Use Cases

1. **Learning Hytopia Development**
   - Access official examples
   - Experiment with working game implementations
   - Learn best practices

2. **Custom Game Development**
   - Develop your own games in a controlled environment
   - Test against Hytopia's latest features
   - Collaborate with team members using Cloudflare tunnels

3. **Multi-Repository Management**
   - Work on any number of games simultaneously
   - Test interactions between different game implementations
   - Maintain separate development environments for each game

## 🎮 Multiplayer Testing

The development kit includes built-in support for multiplayer testing using Cloudflare tunnels. This allows you to:

1. **Quick Testing Setup**
   - Instantly share your game with testers
   - No need for complex networking setup
   - Automatic SSL certificate provisioning

2. **Connection Methods**
   - Direct tunnel URL access
   - Custom domain support (if configured)
   - Auto-join links for easy sharing

### Setting Up Multiplayer Testing

1. **Using Auto-generated Tunnel URL**:
   ```bash
   # Start the development environment
   docker-compose up
   ```
   The tunnel URL will be automatically generated and displayed in the console.

2. **Using Custom Domain** (Optional):
   - Configure your domain in `.env`:
     ```env
     CUSTOM_DOMAIN=yourdomain.com
     CUSTOM_DOMAIN_DNS_RECORD=dev.yourdomain.com
     ```
   - Ensure your domain is managed by Cloudflare
   - The development environment will automatically configure the DNS records

### Connecting to Your Game

Players can connect to your game in two ways:

1. Via play.hytopia.com:
   ```
   https://play.hytopia.com?join=your-tunnel-url
   ```

2. Via your custom domain (if configured):
   ```
   https://dev.yourdomain.com
   ```

## 🔄 How It Works

1. **Example Games**
   - On startup, the system fetches the latest official Hytopia examples
   - Each example is automatically configured and made available
   - Updates are reflected when new examples are added to the official repository

2. **Custom Repositories**
   - Repositories specified in `.env` are cloned and set up
   - Each repository gets its own isolated environment
   - Changes in your repositories are reflected in real-time

3. **Multiplayer Testing Integration**
   - Automatic Cloudflare tunnel configuration
   - Custom domain setup (if configured)
   - Seamless integration with play.hytopia.com

## 📝 Development Log

### Version 0.1.0 (Initial Release)
- Basic project structure established
- Docker environment setup
- Dynamic example game integration
- Custom repository support
- Optional Cloudflare tunnels integration

### Version 0.2.0 (In Progress)
- Restructuring repository management system
  - Adding dynamic repository parsing
  - Implementing parallel processing
  - Adding health checks
  - Creating backup mechanisms

#### Changes in Progress
1. Repository Management System
   - Creating new `/dev-server/utils/repo-manager/` structure
   - Implementing dynamic repository configuration
   - Adding parallel processing support
   - Adding health check system

2. Example Management System
   - Creating new `/dev-server/utils/example-manager/` structure
   - Implementing version tracking
   - Adding update detection
   - Creating backup system

3. Environment Setup Enhancement
   - Refactoring setup scripts
   - Implementing error handling
   - Adding health monitoring
   - Creating update mechanisms

## 🛣️ Development Roadmap

### Core Infrastructure
- [ ] Dynamic Example Games Fetcher (Priority: High)
  - [ ] Service to fetch official Hytopia examples
  - [ ] Auto-update mechanism
  - [ ] Version control integration
  - Current Status: Basic directory structure exists, needs automation

- [ ] Dynamic Repository Management (Priority: High)
  - [ ] Dynamic repository loader (partially implemented)
  - [ ] Parallel repository cloning
  - [ ] Health check system
  - Current Status: Basic .env configuration exists, needs dynamic loading

- [ ] Docker Environment Enhancement (Priority: Medium)
  - [x] Basic container setup
  - [x] Network configuration
  - [ ] Dynamic container scaling
  - [ ] Shared resource management
  - Current Status: Basic setup complete, needs scaling features

### Networking & Multiplayer
- [ ] Cloudflare Integration (Priority: High)
  - [x] Basic tunnel support
  - [ ] Custom domain automation
  - [ ] Fallback mechanisms
  - Current Status: Basic integration exists, needs enhancement

- [ ] Development Proxy System (Priority: Medium)
  - [ ] Multi-game reverse proxy
  - [ ] Dynamic routing
  - [ ] SSL handling
  - Current Status: Not started

### Development Experience
- [ ] Hot-reload System (Priority: High)
  - [ ] File watching
  - [ ] Rebuild triggers
  - [ ] HMR setup
  - Current Status: Not implemented

- [ ] Development Tooling (Priority: Medium)
  - [ ] Logging system
  - [ ] Development dashboard
  - [ ] Debugging tools
  - Current Status: Basic setup only

### Immediate Next Steps
1. Implement dynamic example games fetcher
   - Create automated clone/pull system
   - Add version tracking
   - Implement update checks

2. Enhance repository management
   - Create dynamic loader for unlimited repos
   - Add parallel processing
   - Implement health checks

3. Improve Docker environment
   - Add container scaling
   - Implement resource sharing
   - Add volume management

4. Enhance Cloudflare integration
   - Add custom domain automation
   - Implement fallback systems
   - Add monitoring

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

[Add appropriate license information]

## 🔗 Links

- [Hytopia Official Documentation](https://docs.hytopia.com)
- [Docker Documentation](https://docs.docker.com)
- [Cloudflare Tunnels Documentation](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps)