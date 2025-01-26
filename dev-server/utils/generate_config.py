import os
import yaml
from pathlib import Path

def generate_cloudflare_config():
    # Load base template
    template_path = Path('cloudflared/config.template.yml')
    with open(template_path, 'r') as f:
        template = f.read()
    
    # Parse configurations from environment
    game_repos = yaml.safe_load(os.getenv('GAME_REPOS', '[]'))
    examples = yaml.safe_load(os.getenv('EXAMPLES', '[]'))
    
    # Generate rules for examples
    example_rules = []
    for example in examples:
        rule = f"""  - hostname: "{example['name']}.{os.getenv('TUNNEL_DOMAIN')}"
    service: http://hytopia-dev:8080/examples/{example['name']}"""
        example_rules.append(rule)
    
    # Generate rules for game repos
    repo_rules = []
    for repo in game_repos:
        rule = f"""  - hostname: "{repo['name']}.{os.getenv('TUNNEL_DOMAIN')}"
    service: http://hytopia-dev:8080/{repo['name']}"""
        repo_rules.append(rule)
    
    # Insert rules into template
    config = template.replace('${DYNAMIC_EXAMPLES}', '\n'.join(example_rules))
    config = config.replace('${DYNAMIC_ROUTES}', '\n'.join(repo_rules))
    
    # Write final config
    config_path = Path('cloudflared/config.yml')
    with open(config_path, 'w') as f:
        f.write(config)

if __name__ == "__main__":
    generate_cloudflare_config() 