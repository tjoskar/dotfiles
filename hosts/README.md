# hosts

`hosts/local` holds extra `/etc/hosts` entries in plain hosts format. It is
gitignored because the names are work-internal. `hosts-sync` (a fish
function in `fish/functions/`) writes it into `/etc/hosts` as a marked
block and removes loose duplicates, so this file is the only place to edit.

New machine: copy the file over, then run `hosts-sync`.

```fish
scp ~/projects/tjoskar/dotfiles/hosts/local devbox@orb:projects/tjoskar/dotfiles/hosts/local
```
