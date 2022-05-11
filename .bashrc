#==============================================================================
#  ~/.bashrc
#  executed by bash(1) for non-login shells.
#==============================================================================

# Modify this file to reflect your specific requirements

### set the command line prompt
if [ "$(id -u)" -eq 0 ]; then
    PS1="\[\e[31m\]\u\[\e[m\]@\[\e[32m\]\h\[\e[m\]:[\[\e[33m\]\w\[\e[m\]]\\$ "
else
    git status -s
    PS1="\[\e[36m\]\u\[\e[m\]@\[\e[32m\]\h\[\e[m\]:[\[\e[33m\]\w\[\e[m\]]\\$ "
fi

#------------------------------------------------------------------------------
#  Global aliases & functions #
#------------------------------------------------------------------------------

### grep for process
psgrep() {
    if [ ! -z $1 ]; then
        echo "Grepping for processes matching $1..."
        ps aux | grep -i $1 | grep -v grep
    else
        echo "!! Need name to grep for"
    fi
}

### extract
extract() {
    if [ -f $1 ]; then
        case $1 in
        *.tar.bz2) tar xjf $1 ;;
        *.tar.gz) tar xzf $1 ;;
        *.bz2) bunzip2 $1 ;;
        *.rar) unrar e $1 ;;
        *.gz) gunzip $1 ;;
        *.tar) tar xf $1 ;;
        *.tbz2) tar xjf $1 ;;
        *.tgz) tar xzf $1 ;;
        *.zip) unzip $1 ;;
        *.Z) uncompress $1 ;;
        *.7z) 7z x $1 ;;
        *.xz) xz -dk $1 ;;
        *) echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

#------------------------------------------------------------------------------
#  OS specific aliases & functions
#------------------------------------------------------------------------------

case "$OSTYPE" in

#------------------------------------------------------------------------------
#  Linux
#------------------------------------------------------------------------------

linux*)

    ### determine distro
    case $(/bin/grep ^ID= /etc/os-release) in

    ID=debian | ID=ubuntu | ID=pop)
        # apt aliases
        if [ -f /usr/bin/flatpak ]; then
            alias patch='sudo apt update && sudo apt upgrade && sudo apt dist-upgrade && sudo flatpak update -y'
        else
            alias patch='sudo apt update && sudo apt upgrade && sudo apt dist-upgrade'
        fi
        alias search='sudo apt search'
        alias install='sudo apt install'
        alias clean='sudo apt clean && sudo apt autoclean && sudo apt -y autoremove'
        alias remove='sudo apt-get --purge remove'
        alias installed='apt list --installed'
        alias backports='sudo apt -t bullseye-backports upgrade'

        # apt aliases
        alias apt-version='apt-cache madison'
        alias apt-depends='apt-cache depends'
        alias apt-depends-full='apt-rdepends'
        alias apt-depends-reverse='apt-rdepends -r'
        alias apt-show-files='apt-file show'
        alias apt-show-update='apt-file update'
        alias apt-backports-available="aptitude search '?and(~i, ~Araring-backports)'"
        alias apt-backports-list="aptitude search '~Abackports ?not(~S ~i ~Abackports)'"

        # debian specific
        alias fd='fdfind'
        alias bat='batcat --style=plain'

        # source bash_completion
        if [ -f /etc/bash_completion ]; then
            . /etc/bash_completion
        fi
        ;;

    ID=fedora | 'ID="centos"')
        # dnf aliases
        if [ -f /usr/bin/flatpak ]; then
            alias patch='sudo dnf update && sudo dnf upgrade && sudo flatpak update -y'
        else
            alias patch='sudo dnf update && sudo dnf upgrade'
        fi
        alias search='sudo dnf search'
        alias install='sudo dnf install'
        alias clean='sudo dnf clean packages && sudo dnf autoremove'
        alias clean-kernel='sudo dnf remove $(dnf repoquery --installonly --latest-limit=-2 -q)'
        alias clean-cache='sudo dnf clean all'
        alias remove='sudo dnf remove'
        alias installed='sudo dnf list installed'

        # dnf aliases
        alias dnf-info='sudo dnf info'
        alias dnf-check-updates='sudo dnf check-update'
        alias dnf-check-security='sudo dnf updateinfo list sec'
        alias dnf-history='sudo dnf history list'
        alias dnf-repolist='sudo dnf repolist --enabled'
        alias dnf-version='dnf -C repoquery'
        alias dnf-groups='dnf grouplist'
        alias dnf-groupinfo='dnf groupinfo'
        alias dnf-userinstalled='dnf history userinstalled'

        # source bash_completion
        source /etc/profile.d/bash_completion.sh
        ;;
    esac

    ### copy/paste
    case "$XDG_SESSION_TYPE" in
    wayland)
        alias pbcopy='wl-copy'
        alias pbpaste='wl-paste'
        ;;
    x11)
        alias pbcopy='xsel --clipboard --input'
        alias pbpaste='xsel --clipboard --output'
        ;;
    esac

    ### journalctl
    alias journalctl-log='sudo journalctl -f'
    alias journalctl-boot='journalctl -b'
    alias journalctl-boot-previous='journalctl -b  -1'

    ### systemctl
    alias systemctl-depends='systemctl list-dependencies'
    alias systemctl-all='systemctl list-unit-files --type=service'
    alias systemctl-enabled='systemctl --type=service --state=active --no-pager list-units'
    alias systemctl-timers='systemctl list-timers --all'
    alias systemctl-boot-speed='systemd-analyze blame'

    ### hardware
    alias show-pci="lspci"
    alias show-hardware="sudo lshw -short"
    alias show-hardware-full="sudo lshw"
    alias show-hardware-network="sudo lshw -class network"
    alias show-cpu="lscpu"
    alias show-hardware-report="sudo hwinfo"
    alias show-usb="sudo hwinfo"
    alias show-dmi="sudo dmidecode"
    alias show-disk="sudo hdparm -i /dev/sda"
    alias cputemp='sensors |grep Core'

    ;;

#------------------------------------------------------------------------------
#  MacOS
#------------------------------------------------------------------------------

darwin*)

    ### macports
    alias patch='sudo port selfupdate -d && sudo port outdated && sudo port -c upgrade outdated'
    alias clean='sudo port -c -q uninstall inactive 2>/dev/null; sudo port -c uninstall leaves 2>/dev/null'
    alias clean-all='sudo port clean installed && sudo port uninstall inactive && sudo port uninstall leaves'
    alias search='port search'
    alias install='sudo port -c install'
    alias remove='sudo port -u uninstall'
    alias installed='port installed'
    alias port-info='port info'
    alias port-notes='port notes'
    alias port-depends='port deps'
    alias port-variants='port variants'

    ### utilities
    alias sleepnow='pmset displaysleepnow'
    alias reboot='sudo fdesetup authrestart'
    alias reboot-remote='sudo fdesetup authrestart'
    alias launchctl-enabled='launchctl list | grep -v "\-\t0"'
    alias flush="dscacheutil -flushcache && sudo killall mDNSResponder"
    alias hide-extension="SetFile -a E"
    alias show-extension="SetFile -a e"
    alias cputemp='sudo powermetrics --samplers smc |grep -i "CPU die temperature"'
    alias gputemp='sudo powermetrics --samplers smc |grep -i "GPU die temperature"'

    ;;

#------------------------------------------------------------------------------
#  FreeBSD
#------------------------------------------------------------------------------

freebsd*)

    # Let sh(1) know it's at home, despite /home being a symlink.
    if [ "$PWD" != "$HOME" ] && [ "$PWD" -ef "$HOME" ]; then cd; fi

    # source bash completion
    [[ $PS1 && -f /usr/local/share/bash-completion/bash_completion.sh ]] &&
        source /usr/local/share/bash-completion/bash_completion.sh

    # pkg aliases
    alias patch='sudo pkg update && sudo pkg upgrade'
    alias install='sudo pkg install'
    alias search='pkg search'
    alias clean='sudo pkg clean && sudo pkg autoremove'
    alias remove='sudo pkg delete'
    alias installed='pkg info'
    alias pkg-notes='pkg info -D'
    alias pkg-list='pkg --list'
    alias pkg-lock='sudo pkg lock'
    alias pkg-unlock='sudo pkg unlock'
    alias pkg-stats='pkg stats'
    alias pkg-version='pkg version'

    # poweroff
    alias poweroff='sudo shutdown -p now'

    ;;

esac
