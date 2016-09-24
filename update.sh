#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")"

git pull origin master

function copyToHome() {
    rsync --exclude ".git/" --exclude ".nano/.git/" --exclude ".DS_Store" -av --no-perms home/ ~
}

function copyToSublime() {
    rsync --exclude ".git/" --exclude ".DS_Store" --exclude "README.md" --exclude "Preferences.sublime-settings" -av --no-perms sublime/* "$HOME/Library/Application Support/Sublime Text 3/Packages/User"
}

printf '%s ' 'This may overwrite existing files in your home directory. Are you sure? (y/n)'
read ans
echo $ans
if [[ $ans =~ ^[Yy]$ ]]; then
    copyToHome
    copyToSublime
fi

unset copyToHome
unset copyToSublime

source ~/.zshrc
