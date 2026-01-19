#!/bin/bash

# ===========================================
# Arda's Dotfiles Installer
# ===========================================

set -e

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
  echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
  echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Clone dotfiles if not already present
clone_dotfiles() {
  if [[ ! -d "$DOTFILES_DIR" ]]; then
    log_info "Cloning dotfiles repository..."
    git clone https://github.com/ardasatata/dotfiles.git "$DOTFILES_DIR"
  else
    log_info "Dotfiles directory already exists. Pulling latest..."
    cd "$DOTFILES_DIR" && git pull origin main
  fi
}

# Backup existing dotfile
backup_file() {
  local file=$1
  if [[ -e "$HOME/$file" ]] && [[ ! -L "$HOME/$file" ]]; then
    mkdir -p "$BACKUP_DIR"
    log_warn "Backing up existing $file to $BACKUP_DIR/"
    mv "$HOME/$file" "$BACKUP_DIR/"
  fi
}

# Create symlink
link_file() {
  local src=$1
  local dest=$2
  
  if [[ -L "$dest" ]]; then
    log_info "Removing existing symlink: $dest"
    rm "$dest"
  fi
  
  log_info "Linking $src -> $dest"
  ln -sf "$src" "$dest"
}

# Main installation
main() {
  echo ""
  echo "==================================="
  echo "  Arda's Dotfiles Installer"
  echo "==================================="
  echo ""

  # Clone or update dotfiles
  clone_dotfiles
  cd "$DOTFILES_DIR"

  # List of dotfiles to symlink
  declare -a dotfiles=(
    ".zshrc"
  )

  # Backup and link each dotfile
  for file in "${dotfiles[@]}"; do
    if [[ -f "$DOTFILES_DIR/$file" ]]; then
      backup_file "$file"
      link_file "$DOTFILES_DIR/$file" "$HOME/$file"
    fi
  done

  echo ""
  log_info "Installation complete!"
  log_info "Run 'source ~/.zshrc' or open a new terminal to apply changes."
  echo ""
  
  if [[ -d "$BACKUP_DIR" ]]; then
    log_warn "Your original dotfiles were backed up to: $BACKUP_DIR"
  fi
}

main "$@"
