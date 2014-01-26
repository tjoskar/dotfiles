# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="cloud"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git bower brew Composer)

source $ZSH/oh-my-zsh.sh

# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH"

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.private can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,private}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Customize to your needs...
#export PATH=$PATH:/opt/local/bin:/opt/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/X11/bin
#export PATH=/Applications/MAMP/bin/php/php5.4.10/bin:$PATH
#export PATH=/Users/Tjoskar/pear/bin:$PATH

# SSH
alias tv="ssh tjoskar@192.168.0.12 -p 300"
alias pi="ssh pi@192.168.0.18 -p2222"
alias summer="ssh adminuser@141.255.189.219 -p 300"
alias savesql="scp -P 300 adminuser@141.255.189.219:sqldumps/dump_`date "+\%Y-\%m-\%d"`.sql /Users/Tjoskar/AeroFS/Projekt/latest.sql"
