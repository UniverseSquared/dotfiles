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
