#==============================================================================
#  ~/.profile
#
#  Note: make sure this file is dash/sh compatible
#  dash ~/.profile
#==============================================================================

# Modify this file to reflect your specific requirements

# Global Environment Variables
export EDITOR=nvim
export LESSHISTSIZE=0
export LESSHISTFILE=/dev/null

case $(uname) in

#------------------------------------------------------------------------------
#  Linux
#------------------------------------------------------------------------------

Linux)

    # add to $PATH
    export PATH=~/bin:~/.local/bin/:~/bin/python/:~/.luarocks/bin:$PATH

    # lua-language-server
    if [ -d "$HOME/.local/lua-language-server/bin/" ]; then
        PATH="$HOME/.local/lua-language-server/bin/:$PATH"
    fi

    # nvm
    if [ -d "$HOME/.nvm" ]; then
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    fi

    # enable qt5ct config
    export QT_QPA_PLATFORMTHEME=qt5ct

    # determine network interface
    export NET=$(ip route get 2.2.2.2 | awk -- '{printf $5}')

    ;;

#------------------------------------------------------------------------------
#  MacOS
#------------------------------------------------------------------------------

Darwin)

    # add to path
    export PATH=~/bin:~/bin/python:~/.local/bin:$PATH
    # macports
    export PATH=/opt/local/bin:/opt/local/sbin:/opt/local/libexec/gnubin/:$PATH
    # LSP
    export PATH=~/.local/ltex-ls/bin:$PATH
    # luarocks
    export PATH=~/.luarocks/bin:$PATH
    # macports man pages
    export MANPATH=/opt/local/share/man:$MANPATH

    # keep gpg in terminal
    export PINENTRY_USER_DATA="USE_CURSES=1"

    # disable zsh warning
    export BASH_SILENCE_DEPRECATION_WARNING=1

    # define $LANG
    export LANG=en_US.UTF-8

    # source bash_completion
    if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
        . /opt/local/etc/profile.d/bash_completion.sh
    fi

    # determine network interface
    export NET=$(route get 0.0.0.0 | awk '/interface/ {print $2}')

    ;;

#------------------------------------------------------------------------------
#  FreeBSD
#------------------------------------------------------------------------------

FreeBSD)

    # add to path
    export PATH=~/bin:~/bin/python:~/.local/bin:~/.luarocks/bin:$PATH

    # npm setup
    # export NPM_PACKAGES="$HOME/.npm-packages"
    # export PATH="$NPM_PACKAGES/bin:$PATH"
    # unset MANPATH
    # export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
    # export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"

    # xfce4 settings
    if [ -f /usr/local/bin/xfce4-session ]; then
        # export GDK_SCALE=2
        # export GDK_DPI_SCALE=0.5
        # export QT_FONT_DPI=96
        export QT_AUTO_SCREEN_SCALE_FACTOR=1
        export QT_SCREEN_SCALE_FACTORS=2
        export QT_QPA_PLATFORMTHEME=qt5ct
        export OOO_FORCE_DESKTOP=gnome
    fi

    ;;

esac
