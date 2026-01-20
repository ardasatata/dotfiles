#!/bin/bash

# ===========================================
# Arda's Dotfiles Installer
# ===========================================
#
# Uses a managed sections strategy to merge dotfiles
# instead of replacing them entirely. This preserves
# user customizations while keeping managed content
# in sync.

set -e

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Managed section markers
MARKER_BEGIN="# BEGIN DOTFILES MANAGED"
MARKER_END="# END DOTFILES MANAGED"

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

# Extract managed section content from a file
extract_managed_section() {
  local file=$1
  if [[ -f "$file" ]]; then
    sed -n "/$MARKER_BEGIN/,/$MARKER_END/p" "$file"
  fi
}

# Check if file contains managed section markers
has_managed_section() {
  local file=$1
  if [[ -f "$file" ]]; then
    grep -q "$MARKER_BEGIN" "$file" && grep -q "$MARKER_END" "$file"
    return $?
  fi
  return 1
}

# Merge managed file content
# - If dest doesn't exist: copy entire source
# - If dest exists without markers: append managed section
# - If dest exists with markers: replace managed section only
merge_managed_file() {
  local src=$1
  local dest=$2

  # Extract managed section from source
  local managed_content
  managed_content=$(extract_managed_section "$src")

  if [[ -z "$managed_content" ]]; then
    log_error "Source file $src has no managed section markers"
    return 1
  fi

  # Case 1: Destination doesn't exist - copy entire source
  if [[ ! -e "$dest" ]]; then
    log_info "Creating $dest (new file)"
    cp "$src" "$dest"
    return 0
  fi

  # Case 2: Destination is a symlink - handle migration
  if [[ -L "$dest" ]]; then
    log_warn "Migrating from symlink: $dest"
    rm "$dest"

    # Check for backup to restore
    local backup_file
    backup_file=$(find "$HOME/.dotfiles_backup" -name "$(basename "$dest")" -type f 2>/dev/null | sort | tail -1)

    if [[ -n "$backup_file" ]]; then
      log_info "Restoring from backup: $backup_file"
      cp "$backup_file" "$dest"
    else
      log_info "No backup found, creating new file"
      cp "$src" "$dest"
      return 0
    fi
  fi

  # Case 3: Destination exists without markers - append managed section
  if ! has_managed_section "$dest"; then
    log_info "Appending managed section to $dest"
    echo "" >> "$dest"
    echo "$managed_content" >> "$dest"
    return 0
  fi

  # Case 4: Destination exists with markers - replace managed section
  log_info "Updating managed section in $dest"

  # Create temp file with updated content
  local temp_file
  temp_file=$(mktemp)

  # Use awk for portable sed-like operations (works on macOS and Linux)
  awk -v marker_begin="$MARKER_BEGIN" -v marker_end="$MARKER_END" '
    BEGIN { in_section = 0 }
    $0 ~ marker_begin { in_section = 1; next }
    $0 ~ marker_end { in_section = 0; next }
    !in_section { print }
  ' "$dest" > "$temp_file"

  # Add new managed section at the end
  echo "$managed_content" >> "$temp_file"

  # Replace original file
  mv "$temp_file" "$dest"

  return 0
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

  # List of dotfiles to merge
  declare -a dotfiles=(
    ".zshrc"
  )

  # Merge each dotfile
  for file in "${dotfiles[@]}"; do
    if [[ -f "$DOTFILES_DIR/$file" ]]; then
      merge_managed_file "$DOTFILES_DIR/$file" "$HOME/$file"
    fi
  done

  echo ""
  log_info "Installation complete!"
  log_info "Run 'source ~/.zshrc' or open a new terminal to apply changes."
  echo ""
}

main "$@"
