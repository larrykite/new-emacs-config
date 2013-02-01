# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh
#export DISABLE_AUTO_UPDATE=true

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#export ZSH_THEME="robbyrussell"
export ZSH_THEME="steeef"
export PROJECT_HOME="/Users/larrykite/pyprojects"
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
export PATH="/usr/local/share/python:$PATH"
#export PATH="$HOME/flex_sdk/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="/usr/local/Cellar/emacs/HEAD/bin:/usr/local/mysql/bin:$PATH"
export PATH="/Applications/Postgres.app/Contents/MacOS/bin:$PATH"
# uncomment following line if there are problems, but I don't foresee any
# icon is a programming language which must have been a dependency of
# something.
# export PATH="/opt/icon-v950/bin:$PATH"

# Set to this to use case-sensitive completion
export CASE_SENSITIVE="true"

export PYTHONPATH="/usr/local/lib/python2.7/site-packages:$PYTHONPATH"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"

#source ~/alchemy/alchemy-setup
# Uncomment following line if you want to disable autosetting terminal title.
# export DISABLE_AUTO_TITLE="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
plugins=(github python brew git svn osx zsh-syntax-highlighting cp git-extras)
alias mysql=/usr/local/mysql/bin/mysql
alias mysqladmin=/usr/local/mysql/bin/mysqladmin
source $ZSH/oh-my-zsh.sh
source /Users/larrykite/zsh_aliases
# Customize to your needs...
#xmodmap ~/.xmodmap.myown
source /usr/local/share/python/virtualenvwrapper.sh

function findx () {
 find . -name "*.$1" | xargs grep -E "$2"
}

function setenv () {
  export $1="$2"
}
function lf
{
    ls --color=tty --classify $*
    echo "$(ls -l $* | wc -l) files"
}

mcd () {
        mkdir -p "$1" && cd "$1"
}

getc (){
    sed 1d "$1" |  awk -F"," '{print $1}' > "$2"
}

# Function which adds an alias to the current shell and to
# the ~/.bash_aliases file.
add-alias ()
{
   local name=$1 value="$2"
   echo alias $name=\'$value\' >>~/zsh_aliases
   eval alias $name=\'$value\'
   alias $name
}


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
export JAVA_HOME="$(/usr/libexec/java_home)"

unsetopt prompt_cr
if [[ "$TERM" == "dumb" ]]
then
  unsetopt zle
  unsetopt prompt_cr
  unsetopt prompt_subst
  unfunction precmd
  unfunction preexec
  PS1='$ '
fi
