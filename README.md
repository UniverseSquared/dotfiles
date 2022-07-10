# dotfiles

The configuration files that I use on Arch Linux.

## Installation

```sh
$ alias dfg="git --git-dir=$HOME/dotfiles --work-tree=$HOME"
$ git clone --bare https://github.com/UniverseSquared/dotfiles.git
$ dfg checkout
$ dfg config --local status.showUntrackedFiles no
```
