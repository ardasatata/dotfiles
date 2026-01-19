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

## What's Included

### Git Shortcuts (`.zshrc`)

| Command    | Description                              |
|------------|------------------------------------------|
| `gdefault` | Print the default branch name (main/master) |
| `gcom`     | Checkout the default branch              |
| `gpull`    | Pull current branch from origin          |
| `gfresh`   | Checkout default branch + pull latest    |

## File Structure

```
dotfiles/
├── .zshrc        # ZSH configuration
├── install.sh    # Installation script
└── README.md     # This file
```

## Adding New Dotfiles

1. Add the file to the repo (e.g., `.gitconfig`)
2. Add the filename to the `dotfiles` array in `install.sh`
3. Run `./install.sh` to create the symlink

## Updating

```bash
cd ~/dotfiles
git pull
./install.sh
```

## Backup

The installer automatically backs up existing dotfiles to `~/.dotfiles_backup/` before creating symlinks.
