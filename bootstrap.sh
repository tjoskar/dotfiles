#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")"

./update.sh start

if command -v brew > /dev/null 2>&1; then # Homebrew installed
    brew update
else
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

source brewfile.sh

./.cask start

./.osx start
