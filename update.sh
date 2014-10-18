#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")"

git pull origin master

function copyToHome() {
    rsync --exclude ".git/" --exclude ".nano/.git/" --exclude ".DS_Store" -av --no-perms home/ ~
}

function copyToSublime() {
    rsync --exclude ".git/" --exclude ".DS_Store" --exclude "README.md" --exclude "Preferences.sublime-settings" -av --no-perms sublime/* "$HOME/Library/Application Support/Sublime Text 3/Packages/User"
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
    copyToHome
    copyToSublime
else
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        copyToHome
        copyToSublime
    fi
fi

unset copyToHome
unset copyToSublime
