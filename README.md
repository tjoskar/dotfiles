# Hemlängtan

## Installation

```bash
git clone https://github.com/tjoskar/dotfiles.git
cd dotfiles
sh bootstrap.sh # This will change your system. Check the code first!
```

To update:
```bash
sh update.sh
```

### Add custom commands

If `~/.private` exists, it will be sourced along with the other files.
My `~/.private` file looks something like this:

```bash
# Git credentials
GIT_AUTHOR_NAME="Oskar Karlsson"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
git config --global user.name "$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="kontakta@oskarkarlsson.nu"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
git config --global user.email "$GIT_AUTHOR_EMAIL"

#SSH
alias tv="ssh tjoskar@192.168.0.12 -p 300"
```

## Thanks to…

* [Mathias Bynens](http://mathiasbynens.be/) and his [dotfiles](https://github.com/mathiasbynens/dotfiles)
* [Zach Holman](http://zachholman.com/) and his [dotfiles](https://github.com/holman/dotfiles)
* [Yan Pritzker](http://yanpritzker.com/) and his [dotfiles](https://github.com/skwp/dotfiles)
* [Ben Alman](http://benalman.com/) and his [dotfiles](https://github.com/cowboy/dotfiles)
* [Paul Miller](http://paulmillr.com/) and his [dotfiles](https://github.com/paulmillr/dotfiles)
