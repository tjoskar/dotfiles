#!/usr/bin/env fish
# Tmux command palette — fzf-pick a labeled command, then run it.
# Bound from tmux.conf: prefix + Space → display-popup -E "~/.config/tmux/palette.fish"
#
# Labels include the default tmux shortcut in parens (after prefix).
# Add new entries by extending both the list and the switch-case below.

set -l entries \
    "New window (c)" \
    "Close window (&)" \
    "Rename window (,)" \
    "Split right (%)" \
    "Split down (\")" \
    "Kill pane (x)" \
    "New session" \
    "Rename session (\$)" \
    "Switch session (s)" \
    "Switch window (w)" \
    "Detach (d)" \
    "List keybindings (?)" \
    "Reload config (r)"

set -l selected (printf '%s\n' $entries | fzf \
    --prompt='tmux> ' \
    --reverse \
    --height=100% \
    --border=none)

test -z "$selected"; and exit 0

# Cases that need text input use fish's `read` directly instead of tmux's
# `command-prompt`: `display-popup -E` closes the popup when this script
# exits, which races with command-prompt's UI registration on the client.
# Reading here (while the popup is still open) sidesteps the issue and
# also avoids re-quoting the command through `eval`.
switch $selected
    case "New window*"
        tmux new-window -c '#{pane_current_path}'
    case "Close window*"
        tmux confirm-before -p 'Close window? (y/n) ' kill-window
    case "Rename window*"
        set -l current (tmux display-message -p '#W')
        read -l -P "Rename window (was '$current'): " name
        test -n "$name"; and tmux rename-window -- $name
    case "Split right*"
        tmux split-window -h -c '#{pane_current_path}'
    case "Split down*"
        tmux split-window -v -c '#{pane_current_path}'
    case "Kill pane*"
        tmux kill-pane
    case "New session*"
        read -l -P "Session name: " name
        test -z "$name"; and exit 0
        # -d to create detached (no nesting from inside the popup),
        # then switch the user's client to the new session.
        tmux new-session -d -s $name; and tmux switch-client -t $name
    case "Rename session*"
        set -l current (tmux display-message -p '#S')
        read -l -P "Rename session (was '$current'): " name
        test -n "$name"; and tmux rename-session -- $name
    case "Switch session*"
        tmux choose-tree -Zs
    case "Switch window*"
        tmux choose-tree -Zw
    case "Detach*"
        tmux detach-client
    case "List keybindings*"
        tmux list-keys
    case "Reload config*"
        tmux source-file ~/.config/tmux/tmux.conf
end
