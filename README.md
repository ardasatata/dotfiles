# Arda's Dotfiles

Personal dotfiles for zsh configuration and development environment setup.

## Quick Install

On a new machine, run:

```bash
curl -fsSL https://raw.githubusercontent.com/ardasatata/dotfiles/main/install.sh | bash
```

Or clone and install manually:

```bash
git clone https://github.com/ardasatata/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

## How It Works

This dotfiles repo uses a **managed sections** strategy instead of replacing entire files. This means:

- Your personal customizations are preserved
- Only the content between `# BEGIN DOTFILES MANAGED` and `# END DOTFILES MANAGED` markers is managed
- Running the installer multiple times is safe and idempotent

### Merge Behavior

| Scenario | Action |
|----------|--------|
| File doesn't exist | Copy entire repo file |
| File exists, no markers | Append managed section to end |
| File exists with markers | Replace only the managed section |
| File is a symlink (legacy) | Migrate: restore backup + merge |

## What's Included

### Git Shortcuts (`.zshrc`)

| Command    | Description                              |
|------------|------------------------------------------|
| `gdefault` | Print the default branch name (main/master) |
| `gcom`     | Checkout the default branch              |
| `gpull`    | Pull current branch from origin          |
| `gfresh`   | Checkout default branch + pull latest    |

### Default Configuration

The repo `.zshrc` includes a sensible default setup:
- Oh My Zsh with robbyrussell theme
- NVM (Node Version Manager) configuration
- Java/Android SDK paths
- PostgreSQL paths
- Rancher Desktop integration

## Machine-Specific Config

For settings that vary between machines, create `~/.zshrc.local`:

```bash
# Example ~/.zshrc.local
export CUSTOM_VAR="machine-specific-value"
alias myalias='custom-command'
```

This file is sourced at the end of the managed section and is not tracked by git.

## File Structure

```
dotfiles/
├── .zshrc        # ZSH configuration with managed section
├── install.sh    # Installation script (merge strategy)
└── README.md     # This file
```

## Adding New Dotfiles

1. Add the file to the repo with managed section markers:
   ```bash
   # BEGIN DOTFILES MANAGED
   # Your managed content here
   # END DOTFILES MANAGED
   ```
2. Add the filename to the `dotfiles` array in `install.sh`
3. Run `./install.sh` to merge

## Updating

```bash
cd ~/dotfiles
git pull
./install.sh
```

Only the managed sections will be updated; your customizations remain intact.
