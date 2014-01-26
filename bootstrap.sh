#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")"

./update.sh start

if command -v brew > /dev/null 2>&1; then # Homebrew installed
    brew update
else
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
fi

brew bundle

./.cask start

./.osx start
