#!/usr/bin/env bash
# User-level setup for the devbox. Idempotent: safe to rerun on a live machine
# to pick up dotfiles or tool changes.
#
#   curl -fsSL https://raw.githubusercontent.com/tjoskar/dotfiles/main/devbox/bootstrap.sh | bash
#
# or, on an existing machine: ~/projects/tjoskar/dotfiles/devbox/bootstrap.sh
set -euo pipefail

DOTFILES="$HOME/projects/tjoskar/dotfiles"
CONFIG="$HOME/.config"

log() { printf '\n==> %s\n' "$*"; }

# Symlink $1 (relative to the dotfiles repo) to $2, replacing whatever is there.
link() {
  local src="$DOTFILES/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    return
  fi
  rm -rf "$dst"
  ln -s "$src" "$dst"
  echo "linked $dst"
}

log "Project folders"
mkdir -p "$HOME/projects/kivra" "$HOME/projects/tjoskar"

log "Dotfiles repo"
if [ -d "$DOTFILES/.git" ]; then
  git -C "$DOTFILES" pull --ff-only
else
  # HTTPS: no SSH agent is available while cloud-init runs. Push from the Mac.
  git clone https://github.com/tjoskar/dotfiles.git "$DOTFILES"
fi

log "Symlinks (Linux subset)"
link fish/config.fish          "$CONFIG/fish/config.fish"
link fish/functions          "$CONFIG/fish/functions"
link git/gitconfig           "$HOME/.gitconfig"
link git/config-kivra        "$CONFIG/git/config-kivra"
link git/config-tjoskar      "$CONFIG/git/config-tjoskar"
link tmux/tmux.conf         "$CONFIG/tmux/tmux.conf"
link tmux/palette.fish       "$CONFIG/tmux/palette.fish"
link starship/starship.toml "$CONFIG/starship.toml"
link lazygit/config.yml      "$CONFIG/lazygit/config.yml"
link mise/config.toml        "$CONFIG/mise/config.toml"
link devbox/mise.toml       "$CONFIG/mise/conf.d/devbox.toml"
if [ -d "$DOTFILES/nvim" ]; then
  link nvim "$CONFIG/nvim"
fi
# Not linked on purpose: ssh/config (its IdentityAgent would shadow the
# forwarded agent), ghostty, vscode, keyboard, .osx.

log "Secrets file"
SECRETS="$CONFIG/fish/conf.d/secrets.fish"
if [ ! -f "$SECRETS" ]; then
  mkdir -p "$(dirname "$SECRETS")"
  cat > "$SECRETS" <<'EOF'
# Machine-local secrets. Not in the dotfiles repo. See devbox/README.md.
# set -gx OP_SERVICE_ACCOUNT_TOKEN ""
EOF
  chmod 600 "$SECRETS"
  echo "created $SECRETS (fill it in, see devbox/README.md)"
fi

log "mise"
if ! command -v mise >/dev/null; then
  curl -fsSL https://mise.run | MISE_INSTALL_PATH="$HOME/.local/bin/mise" sh
fi
export PATH="$HOME/.local/bin:$PATH"
mise install --yes

log "Neovim plugins"
if [ -d "$CONFIG/nvim" ]; then
  mise exec -- nvim --headless "+Lazy! sync" +qa || echo "nvim sync failed, run it interactively"
fi

log "Done. Log out and back in for the fish shell and docker group to apply."
