# Dotfiles

![Screenshot](https://raw.github.com/russmckendrick/dotfiles/master/screenshot.png)

### Installation

Quick installation guide, backs up original dot files and stores them out of the way in a git ignored directory.

```bash
git clone git@github.com:russmckendrick/dotfiles.git ~/.dotfiles
sudo easy_install Pygments
brew install tree
brew cask install ksdiff
mv ~/.bash_profile ~/.dotfiles/backups/
mv ~/.bashrc ~/.dotfiles/backups/
mv ~/.gitconfig ~/.dotfiles/backups/
ln -s ~/.dotfiles/.bash_profile ~/.bash_profile
ln -s ~/.dotfiles/.bashrc ~/.bashrc
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.hushlogin ~/.hushlogin
ln -s ~/.dotfiles/z.sh ~/.z.sh
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/starship.toml ~/.config/starship.toml
```

### Features

**Faster directory navigation**

- `v .`, `s .`, `a .` or `v filename.txt` will open your current directory or a file in SublimeText
- Jump directories rapidly, without having to set aliases using [Z](https://github.com/rupa/z)
- Tab bar displays your current directory
- Lots of quick shortcut aliases used for git and moving around directories

**Customized bash prompt line**

- Git branch status inline
- ⚡ An easily customizable symbol

**Updated color scheme**

- Colored 'ls'
- Syntax highlighted 'cat'

### Bashstrap

This is my fork of [Bashstrap](https://github.com/barryclark/bashstrap).
