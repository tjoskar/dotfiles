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
brew install python

# Install other useful binaries
brew install git
brew install node
brew install tree
brew install p7zip
brew install nnn

# Install Cask 
brew tap caskroom/cask

# Remove outdated versions from the cellar
brew cleanup
