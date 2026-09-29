# Sync the entries in dotfiles/hosts/local (gitignored) into /etc/hosts.
# Writes them as one marked block and removes loose duplicates, so the file
# in the repo is the single place to edit. Works on macOS and Linux.
function hosts-sync --description 'Sync dotfiles/hosts/local into /etc/hosts'
    set -l src ~/projects/tjoskar/dotfiles/hosts/local
    if not test -f $src
        echo "hosts-sync: $src not found (see hosts/README.md)" >&2
        return 1
    end

    set -l tmp (mktemp)
    # Pass 1 reads $src and remembers "ip name" pairs. Pass 2 copies /etc/hosts
    # minus: the old managed block, the legacy "# Kiab" comment, and any loose
    # line that duplicates an entry from $src.
    awk '
        NR == FNR { if ($0 !~ /^[[:space:]]*#/ && NF >= 2) seen[$1 " " $2] = 1; next }
        /^# dotfiles-begin/ { inblock = 1; next }
        /^# dotfiles-end/   { inblock = 0; next }
        inblock { next }
        /^# Kiab[[:space:]]*$/ { next }
        NF >= 2 && ($1 " " $2) in seen { next }
        { print }
    ' $src /etc/hosts >$tmp

    # Ensure a trailing newline before appending.
    if test -s $tmp; and test (tail -c1 $tmp | wc -c) -eq 1
        echo >>$tmp
    end
    echo "# dotfiles-begin (managed by hosts-sync; edit $src instead)" >>$tmp
    cat $src >>$tmp
    echo "# dotfiles-end" >>$tmp

    if diff -q /etc/hosts $tmp >/dev/null
        echo "hosts-sync: /etc/hosts already up to date"
        rm -f $tmp
        return 0
    end

    diff -u /etc/hosts $tmp
    echo
    echo "hosts-sync: writing /etc/hosts (sudo)"
    sudo cp $tmp /etc/hosts
    rm -f $tmp
end
