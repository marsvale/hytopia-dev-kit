# Hytopia Development Kit

A streamlined development environment for Hytopia AI game development, with focus on the AI-agents example integration.

## 🎮 Core Features

- **AI Agent Development**: Direct integration with Hytopia's official ai-agents example
- **Docker-Powered**: Containerized development environment for consistent experience
- **Zero Configuration**: Works out of the box with the ai-agents example
- **Hot Reload**: Automatic code reloading for rapid development

## 🚀 Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/hytopia-dev-kit.git
   cd hytopia-dev-kit
   ```

2. Set up your OpenAI API key:
   ```bash
   cp .env.example .env
   ```
   Edit `.env` and add your OpenAI API key:
   ```env
   OPENAI_API_KEY=your_key_here
   ```

3. Start the development environment:
   ```bash
   docker-compose up --build
   ```

4. Run any example game (using the AI agents as a complex example):
   ```bash
   docker exec -it hytopia-dev-kit-hytopia-dev-1 bash
   cd /app/games/examples/ai-agents
   bun --watch index.ts
   ```
   Simply navigate to the example folder of your choice and start the game server. This approach aligns with Hytopia's conventions, allowing for a straightforward execution of any example game, with the AI agents serving as a detailed reference for integrating the OpenAI API.

> **Note:** For the AI agents example, ensure you set up your OpenAI API key by copying the `.env.example` file to the `games/hytopia/ai-agents` directory and editing it to include your key:
> ```bash
> cp .env.example games/hytopia/ai-agents/.env
> ```
> Edit `games/hytopia/ai-agents/.env` and add your OpenAI API key:
> ```env
> OPENAI_API_KEY=your_key_here
> ```

### Environment Variables required for ai-agents example

- `OPENAI_API_KEY`: Your OpenAI API key (required for AI agents)

### Directory Structure

```
hytopia-dev-kit/
├── examples/           # Official Hytopia examples (including ai-agents)
├── dev-server/        # Development server code
└── .env              # Environment configuration
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