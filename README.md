# dotfiles

Personal macOS setup — shell, terminal, git, ssh, keyboard layout.

The configs in this repo are the **real** configs. The files at `~/.gitconfig`, `~/.config/fish/config.fish`, etc. are symlinks pointing into this repo. That means:

- Editing the config anywhere — via the symlink or directly in `~/projects/tjoskar/dotfiles/` — changes the same file.
- `git diff` in this repo shows exactly what's different on disk right now.

## Layout

| In this repo          | Symlinked to                                       |
|-----------------------|----------------------------------------------------|
| `git/gitconfig`       | `~/.gitconfig`                                     |
| `git/config-kivra`    | `~/.config/git/config-kivra` (work identity)       |
| `git/config-tjoskar`  | `~/.config/git/config-tjoskar` (personal identity) |
| `ssh/config`          | `~/.ssh/config`                                    |
| `fish/config.fish`    | `~/.config/fish/config.fish`                       |
| `fish/functions/wt.fish` | `~/.config/fish/functions/wt.fish`              |
| `fish/functions/hosts-sync.fish` | `~/.config/fish/functions/hosts-sync.fish` (applies gitignored `hosts/local` to `/etc/hosts`) |
| `tmux/tmux.conf`      | `~/.config/tmux/tmux.conf`                         |
| `tmux/palette.fish`   | `~/.config/tmux/palette.fish`                      |
| `ghostty/config`      | `~/.config/ghostty/config`                         |
| `mise/config.toml`    | `~/.config/mise/config.toml`                       |
| `starship/starship.toml` | `~/.config/starship.toml`                       |
| `lazygit/config.yml`  | `~/.config/lazygit/config.yml` (needs `XDG_CONFIG_HOME=$HOME/.config`) |
| `vscode/settings.json`    | `~/Library/Application Support/Code/User/settings.json`    |
| `vscode/keybindings.json` | `~/Library/Application Support/Code/User/keybindings.json` |

`keyboard/Tjoskar.keylayout` is **copied** (not symlinked) to `~/Library/Keyboard Layouts/` — macOS doesn't reliably load keyboard layouts through symlinks. After copying, log out and back in, then add it via System Settings → Keyboard → Input Sources → Others.

`themes/Tjoskar.itermcolors` is kept for reference (can be converted to a Ghostty theme when needed).

## Committing changes

Nothing special — just edit the config (from anywhere) and commit here:

```fish
cd ~/projects/tjoskar/dotfiles
git add -p
git commit -m "ghostty: tweak font size"
git push
```

Since this repo lives under `~/projects/tjoskar/`, it automatically uses the personal git identity (via `includeIf`) and the personal SSH key for push (via `url.insteadOf` in `git/config-tjoskar`).

## Fresh machine setup

Rough order — do this by hand, step by step, adjusting as your setup evolves. Intentionally no install script: you'll only do this once every few years, and the manual steps make it obvious what's being changed.

1. **Install Homebrew**, then the base tooling:
   ```bash
   brew install fish mise gh git tmux fzf
   brew install --cask ghostty visual-studio-code orbstack raycast
   chsh -s /opt/homebrew/bin/fish
   ```

2. **Create the folder structure** and clone this repo via HTTPS (SSH isn't set up yet):
   ```bash
   mkdir -p ~/projects/kivra ~/projects/tjoskar
   cd ~/projects/tjoskar
   git clone https://github.com/tjoskar/dotfiles.git
   ```

3. **Generate SSH keys** for both identities and add them to GitHub:
   ```bash
   ssh-keygen -t ed25519 -C "tjoskar@users.noreply.github.com" -f ~/.ssh/id_ed25519_personal
   ssh-keygen -t ed25519 -C "oskar@kivra.com" -f ~/.ssh/id_ed25519_kivra
   # Add each public key to the matching GitHub account.
   ```

4. **Symlink configs** from this repo into place. Example:
   ```bash
   D=~/projects/tjoskar/dotfiles
   ln -s "$D/git/gitconfig"           ~/.gitconfig
   ln -s "$D/git/config-kivra"        ~/.config/git/config-kivra
   ln -s "$D/git/config-tjoskar"      ~/.config/git/config-tjoskar
   ln -s "$D/ssh/config"              ~/.ssh/config
   ln -s "$D/fish/config.fish"        ~/.config/fish/config.fish
   ln -s "$D/fish/functions/wt.fish"  ~/.config/fish/functions/wt.fish
   ln -s "$D/tmux/tmux.conf"          ~/.config/tmux/tmux.conf
   ln -s "$D/tmux/palette.fish"       ~/.config/tmux/palette.fish
   ln -s "$D/ghostty/config"          ~/.config/ghostty/config
   ln -s "$D/mise/config.toml"        ~/.config/mise/config.toml
   ln -s "$D/starship/starship.toml"  ~/.config/starship.toml
   ln -s "$D/lazygit/config.yml"      ~/.config/lazygit/config.yml
   ln -s "$D/vscode/settings.json"    "$HOME/Library/Application Support/Code/User/settings.json"
   ln -s "$D/vscode/keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"
   ```
   Make parent dirs with `mkdir -p` as needed. Use `ln -sf` if something already exists.

5. **Bootstrap tmux plugins** (TPM is external state, not symlinked):
   ```bash
   git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
   ```
   Then start tmux (`tmux`) and press `prefix + I` (capital I) to install Dracula.

6. **Install the keyboard layout** (must be a real file):
   ```bash
   cp ~/projects/tjoskar/dotfiles/keyboard/Tjoskar.keylayout ~/Library/Keyboard\ Layouts/
   ```
   Log out and back in, then add it in System Settings.

7. **Switch the origin to SSH** now that keys are uploaded:
   ```bash
   cd ~/projects/tjoskar/dotfiles
   git remote set-url origin git@github.com-tjoskar:tjoskar/dotfiles.git
   ```

## Identity split — how it works

**Git** (`git/gitconfig`): `includeIf` picks the right author based on where a repo lives.

- `~/projects/kivra/…` → work identity (`oskar@kivra.com`)
- `~/projects/tjoskar/…` → personal identity (`tjoskar@users.noreply.github.com`)
- Anywhere else → git refuses to commit (`user.useConfigOnly = true`) — intentional safety net.

**SSH** (`ssh/config`): host aliases pick the right key.

- `git@github.com:…` → **Kivra** key (default — work is the common case)
- `git@github.com-tjoskar:…` → personal key

Inside `~/projects/tjoskar/`, `url.insteadOf` in `git/config-tjoskar` rewrites plain `git@github.com:` URLs to use the personal alias, so even repos cloned without the alias push with the personal key.
