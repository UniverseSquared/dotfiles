# dotfiles

The configuration files that I use on Arch Linux.

## Installation

I use a bare git repository to manage my dotfiles - they can be installed as follows:

```sh
$ alias dotfiles-git="git --git-dir=$HOME/dotfiles --work-tree=$HOME"
$ git clone --bare https://github.com/UniverseSquared/dotfiles.git
$ dotfiles-git checkout
$ dotfiles-git config --local config.showUntrackedFiles no
```

From then on, the repository can be managed as normal, substituting `git` for `dotfiles-git`

### Initial setup

To setup a repository in a similar fashion to this one, the following commands can be used:

```sh
# create the bare repository:
$ cd
$ mkdir dotfiles && cd dotfiles
$ git init --bare

# put this alias in your shell's configuration too:
$ alias dotfiles-git="git --git-dir $HOME/dotfiles --work-tree=$HOME"

# make `dotfiles-git status` quieter
$ dotfiles-git config --local config.showUntrackedFiles no

# then, add/commit files as normal
$ dotfiles-git add .config/alacritty.yml
$ dotfiles-git commit -m "alacritty: add config"
```

## Prerequisites

I use (among others) the following software:
* bspwm as a window manager, sxhkd as a hotkey daemon and picom as a compositor
* rofi for application launching
* alacritty as a terminal emulator
* zsh as a shell
* emacs (running as a daemon) for text/code editing
* mpd/ncmpcpp for listening to music
* and firefox as a web browser.

I primarily use the Fira Code font, but use kiwi (which can be obtained [here](https://github.com/turquoise-hexagon/fonts/blob/master/kiwi.bdf) from [turquoise-hexagon/fonts](https://github.com/turquoise-hexagon)) in polybar.

I use the [feature/dual_kawase branch of picom](https://github.com/tryone144/compton/tree/feature/dual_kawase) as my compositor, which includes the dual_kawase blur method. You will have to build this from source for blur to work correctly.
