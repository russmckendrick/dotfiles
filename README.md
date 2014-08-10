# Dotfiles

![Screenshot](https://raw.github.com/russmckendrick/dotfiles/master/screenshot.png)

### Installation

Quick installation guide, backs up original dot files and stores them out of the way in a git ignored directory.

```bash
git clone git@github.com:russmckendrick/dotfiles.git ~/.dotfiles
sudo easy_install Pygments
brew install tree
mv ~/.bash_profile ~/.dotfiles/backups/
mv ~/.bashrc ~/.dotfiles/backups/
mv ~/.gitconfig ~/.dotfiles/backups/
ln -s ~/.dotfiles/.bash_profile ~/.bash_profile 
ln -s ~/.dotfiles/.bashrc ~/.bashrc
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.hushlogin ~/.hushlogin
ln -s ~/.dotfiles/z.sh ~/.z.sh
```

### Features

**Faster directory navigation**

- `s .` or `s filename.txt` will open your current directory or a file in [Sublime Text 2](http://www.sublimetext.com/2)
- `m README.md` will open the specified file in [Marked 2](http://marked2app.com/)
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
