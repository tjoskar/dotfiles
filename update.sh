#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")"

git pull origin master

function copyToHome() {
    rsync --exclude ".git/" --exclude ".nano/.git/" --exclude ".DS_Store" -av --no-perms home/ ~
}

printf '%s ' 'This may overwrite existing files in your home directory. Are you sure? (y/n)'
read ans
echo $ans
if [[ $ans =~ ^[Yy]$ ]]; then
    copyToHome
fi

unset copyToHome

source ~/.zshrc
