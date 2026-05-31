# ===========================================
# Arda's ZSH Configuration
# ===========================================

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
plugins=(git)

source $ZSH/oh-my-zsh.sh

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/arda/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# Java configuration
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

# Android SDK
export ANDROID_HOME=$HOME/Library/Android/sdk
path=(
  $ANDROID_HOME/emulator
  $ANDROID_HOME/platform-tools
  $path
)

# PostgreSQL
export PATH="/opt/homebrew/opt/postgresql@14/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"

# Local bin
export PATH="$PATH:$HOME/.local/bin"

# Secrets — loaded from an untracked local file (never committed to dotfiles repo)
[ -f "$HOME/.zsh_secrets" ] && source "$HOME/.zsh_secrets"

# Aliases

# Company account — API usage billing (key sourced from ~/.zsh_secrets)
alias claude-dangerous='ANTHROPIC_API_KEY="$ANTHROPIC_API_KEY_COMPANY" claude --dangerously-skip-permissions'

# Personal subscription account — isolated config dir + no inherited API key
alias claude-personal='CLAUDE_CONFIG_DIR=$HOME/.claude-personal env -u ANTHROPIC_API_KEY claude'
alias claude-dangerous-personal='CLAUDE_CONFIG_DIR=$HOME/.claude-personal env -u ANTHROPIC_API_KEY claude --dangerously-skip-permissions'

# BEGIN DOTFILES MANAGED
# Git shortcuts - managed by dotfiles repo

# Get default branch name (main or master)
gdefault() {
  local default_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
  if [[ -z "$default_branch" ]]; then
    default_branch=$(git branch -l main master --format '%(refname:short)' | head -n1)
  fi
  echo "$default_branch"
}

# Checkout default branch (main or master)
gcom() {
  git checkout "$(gdefault)"
}

# Pull current branch from origin
gpull() {
  git pull origin "$(git branch --show-current)"
}

# Switch to default branch and pull latest
gfresh() {
  gcom && gpull
}

# Source machine-specific config if it exists
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
# END DOTFILES MANAGED
