# Upgrade any already-installed formulae
brew upgrade

# Install GNU core utilities (those that come with OS X are outdated)
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils
# Install Bash 4
brew install bash

# Install more recent versions of some OS X tools
brew install vim --override-system-vi
brew tap homebrew/dupes
brew install homebrew/dupes/grep
brew tap josegonzalez/homebrew-php
brew install php55
brew install python

# Install other useful binaries
brew install git
brew install node
brew install tree
brew install p7zip
brew install trash
brew install phantomjs

# Install Cask 
brew tap phinze/homebrew-cask
brew install brew-cask
brew tap caskroom/versions

# Remove outdated versions from the cellar
brew cleanup
