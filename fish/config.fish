# ── Editor & locale ─────────────────────────────────────────────
set -gx EDITOR hx
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

# Force XDG path on macOS so tools like lazygit read from ~/.config/<app>
# instead of ~/Library/Application Support/<app>.
set -gx XDG_CONFIG_HOME $HOME/.config

# bat as man pager (MANROFFOPT=-c avoids rendering artifacts)
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -gx MANROFFOPT -c

# ── mise (runtimes & global tools) ──────────────────────────────
mise activate fish | source

# ── Google Cloud SDK ────────────────────────────────────────────
if test -f /opt/homebrew/share/google-cloud-sdk/path.fish.inc
    source /opt/homebrew/share/google-cloud-sdk/path.fish.inc
end

# ── SSH agent (Homebrew's, for YubiKey keys; macOS only) ────────
if test (uname) = Darwin
  set -gx SSH_AUTH_SOCK $HOME/.ssh/agent.sock
  ssh-add -l >/dev/null 2>&1
  if test $status -eq 2
    rm -f $SSH_AUTH_SOCK
    /opt/homebrew/bin/ssh-agent -a $SSH_AUTH_SOCK >/dev/null
  end
end

if status is-interactive
    # ── Aliases ─────────────────────────────────────────────────
    # (fish has implicit cd, so `..` / `../..` just work — no alias needed)
    alias k='cd ~/projects/kivra'
    alias o='open'
    alias dl='cd ~/Downloads'
    alias dt='cd ~/Desktop'
    alias df='df -h'
    alias du='du -ach'
    alias ls='eza -la --group-directories-first --git'
    alias cat='bat'
    alias p='pnpm'
    alias copy='pbcopy'
    alias paste='pbpaste'
    alias x='pbpaste | pbcopy'

    # ── fzf keybindings ─────────────────────────────────────────
    fzf --fish | source

    # ── Starship prompt ─────────────────────────────────────────
    starship init fish | source
end

# ── Functions ───────────────────────────────────────────────────

# Commit with a random emoji.
function c --description 'Commit with a random emoji'
    set -l emojis 👋 🚀 🧵 🤡 🐝 🦁 ☄️ 🌟 🐈 🧌 🐞
    git commit -m "$emojis[(random 1 (count $emojis))]"
end

# Fuzzy-jump to a project directory.
function g --description 'Navigate to a project via fzf'
    set -l target (find ~/projects/tjoskar ~/projects/kivra -maxdepth 1 -mindepth 1 -type d | fzf)
    test -n "$target"; and cd $target
end

# Open yazi and follow its final cwd.
function y --description 'yazi with cwd follow'
    set -l tmp (mktemp -t yazi-cwd.XXXXXX)
    yazi $argv --cwd-file=$tmp
    set -l cwd (command cat -- $tmp)
    if test -n "$cwd"; and test "$cwd" != "$PWD"
        builtin cd -- $cwd
    end
    rm -f -- $tmp
end

# `wt` (git worktree helper) lives in fish/functions/wt.fish — fish autoloads it.

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
