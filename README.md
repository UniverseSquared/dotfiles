# dotfiles

The configuration files that I use on Arch Linux.

## Installation

```sh
$ alias dfg="git --git-dir=$HOME/dotfiles --work-tree=$HOME"
$ git clone --bare https://github.com/UniverseSquared/dotfiles.git
$ dfg checkout
$ dfg config --local status.showUntrackedFiles no
```

I use the [next branch of picom](https://github.com/yshui/picom) for a
compositor with the dual\_kawase blur method. (remember to start using latest
release when it comes with dual\_kawase)
