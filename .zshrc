# ===========================================
# Arda's ZSH Configuration
# ===========================================

# Git shortcuts

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
