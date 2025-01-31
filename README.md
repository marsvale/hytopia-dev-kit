# Hytopia Development Kit

A streamlined development environment for Hytopia AI game development, with focus on simple deployment.

## 🎮 Core Features

- **AI Agent Development**: Direct integration with Hytopia's official ai-agents example
- **Docker-Powered**: Containerized development environment for consistent experience
- **Zero Configuration**: Works out of the box with the ai-agents example
- **Hot Reload**: Automatic code reloading for rapid development

## 💻 System Requirements

- **Docker Desktop**: [Install Docker Desktop](https://www.docker.com/products/docker-desktop/)
  - Windows: Windows 10/11 Pro, Enterprise, or Education (with WSL 2)
  - Mac: macOS 10.15 or newer
  - Linux: Ubuntu 20.04 or newer
- **Git**: [Install Git](https://git-scm.com/downloads)
- **Terminal**:
  - Windows: PowerShell, Windows Terminal (recommended), or CMD
  - Mac/Linux: Terminal

## 🚀 Quick Start

1. Install Docker Desktop and start it

2. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/hytopia-dev-kit.git
   cd hytopia-dev-kit
   ```

3. Prepare the environment configuration:
   ```bash
   cp .env.example .env
   ```

4. Start the development environment:
   ```bash
   docker compose up --build
   ```

5. Run the AI agents example:
   ```bash
   # Windows PowerShell/CMD:
   docker exec -it hytopia-dev-kit-hytopia-dev-1 bash
   # Mac/Linux Terminal:
   docker exec -it hytopia-dev-kit-hytopia-dev-1 bash
   ```
   Then inside the container:
   ```bash
   cd /app/games/examples/ai-agents
   bun --watch index.ts
   ```

### Directory Structure

```
hytopia-dev-kit/
├── .env              # Development kit configuration
├── dev-server/       # Development server code
│   └── utils/       # Setup and management scripts
├── examples/         # Official Hytopia examples
└── game-repos/      # Your custom game repositories
```

## 📝 Development Status

### Current Release (MVP)
- Basic development environment
- AI-agents example integration
- Hot reload development
- OpenAI API integration

### Roadmap
1. Enhanced debugging tools
2. Multi-agent testing support
3. Custom AI agent templates
4. Performance monitoring

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

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

[Add appropriate license information]

## 🔗 Links

- [Hytopia Official Documentation](https://docs.hytopia.com)
- [Docker Documentation](https://docs.docker.com)
- [Cloudflare Tunnels Documentation](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps)
- [OpenAI API Documentation](https://platform.openai.com/docs)

## 🛠 Advanced Configuration

### Fresh Install Mode
The development kit supports a `FRESH_INSTALL` mode that completely resets the development environment:

- Set `FRESH_INSTALL=true` in your `.env` file
- Clears all existing:
  - Examples
  - Custom repositories
  - Logs
  - State tracking files
- Recreates a pristine development environment
- Useful for completely resetting your development setup

Example `.env` configuration:
```env
FRESH_INSTALL=true
```

### AI Agents Example Initialization
The development kit automatically:
- Generates a `.env` file for the AI agents example
- Provides a placeholder OpenAI API key
- Configures default settings for AI agent development

Placeholder `.env` contents:
```env
OPENAI_API_KEY=sk-your_openai_api_key_here
OPENAI_MODEL=gpt-3.5-turbo
DEBUG=true
```

**Note:** Replace `sk-your_openai_api_key_here` with your actual OpenAI API key before running the example.

### Automatic Example Management
- Examples are automatically:
  - Cloned from the Hytopia SDK
  - Initialized with `bunx hytopia init`
  - Backed up before updates
  - Kept in sync with the latest SDK version

## 🔄 Update and Sync Workflow
1. Restart the container to get the latest examples
2. Examples are automatically:
   - Backed up
   - Updated from SDK
   - Initialized with Hytopia CLI 
