## Cross Platform Bash Startup Files

The Bash shell ‘Bourne-Again SHell’ is installed by default on most operating systems. If you are working with multiple different operating systems, desktop environments, servers, virtual machines and containers. It it time consuming to manage Bash startup files for each platform. A 'universal' set of Bash startup files can be easily maintained in a git repo or just copied in to place whenever a new system is activated.

## Bash startup file execution

**6.2 Bash Startup Files**  
[Bash Reference Manual](https://www.gnu.org/software/bash/manual/bash.html#Bash-Startup-Files)

> **Invoked as an interactive login shell, or with --login**  

> When Bash is invoked as an interactive login shell, or as a non-interactive shell with the --login option, it first reads and executes commands from the file /etc/profile, if that file exists. After reading that file, it looks for ~/.bash_profile, ~/.bash_login, and ~/.profile, in that order, and reads and executes commands from the first one that exists and is readable. The --noprofile option may be used when the shell is started to inhibit this behavior.

> When an interactive login shell exits, or a non-interactive login shell executes the exit builtin command, Bash reads and executes commands from the file ~/.bash_logout, if it exists. 

> **Invoked as an interactive non-login shell**

> When an interactive shell that is not a login shell is started, Bash reads and executes commands from ~/.bashrc, if that file exists. This may be inhibited by using the --norc option. The --rcfile file option will force Bash to read and execute commands from file instead of ~/.bashrc. 

In summary, a Bash login shell will source the system profile, followed by .bash_profile or .profile. For a interactive non-login shell (for instance launching a new terminal instance), Bash will will source ~/.bashrc.

In the real world. This is not always the case. Depending on the operating system, desktop environment or login manager you are using. Results may vary. For instance on MacOS, an interactive non-login shell will source .bash_profile (or .profile if that doesn't exist.) Ignoring .bashrc. On Debian with GDM and Wayland. A login will source your .bash_profile. However with an X11 login it will source .profile (and not .bash_profile). On Debian with LightDM it will source .xsessionrc, ignoring bash startup files. In that case it is a good idea to `ln -s .profile .xsessionrc.`

## Bash startup files

Given the variations of how bash startup files are executed (or not.) This repo consists of three files that should cover most situations:

#### .profile

This file is often sourced by a shell other than Bash. Usually `sh` or `dash` so it should be compliant with `sh`. You can test this by simply executing the file `sh .profile` and checking for any errors. This is the file to set your `$PATH` and environment variables and other globals like `$EDITOR`.

To differentiate operating systems it uses a `case` statement with the `uname` command:

```bash
# EXAMPLE

# Global Variables
export EDITOR=nvim

# Platform Specific
case $(uname) in
Linux)
    # Linux Environment
    ;;
Darwin)
    # MacOS Environment
    ;;
FreeBSD)
    # FreeBSD Environment
    ;;
esac
```

#### .bash_profile

This file is simple and small. It sources `.profile` and it sources `.bashrc` for interactive shells.

```bash
# source profile
. ~/.profile
# source bashrc for interactive shells
case $- in *i*) . ~/.bashrc ;; esac
```

#### .bashrc

This file contains your command prompt and all of your aliases and functions. It uses the Bash `$OSTYPE` variable to identify the operating system, and `/etc/os-release` to further subdivide linux distributions.

```bash
#==============================================================================
#  ~/.bashrc
#  executed by bash(1) for non-login shells.
#==============================================================================

### set the command line prompt

#------------------------------------------------------------------------------
#  Global aliases & functions #
#------------------------------------------------------------------------------

### add aliases and functions

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
        # Debian derived aliases and functions
        ;;

    ID=fedora | 'ID="centos"')
        # RedHat derived aliases and functions
        ;;

    esac

    ;;

#------------------------------------------------------------------------------
#  MacOS
#------------------------------------------------------------------------------

darwin*)
    # MacOS aliases and functions
    ;;

#------------------------------------------------------------------------------
#  FreeBSD
#------------------------------------------------------------------------------

freebsd*)
    # FreeBSD aliases and functions
    ;;

esac
``` 
