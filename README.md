# Dotfiles

![Screenshot](https://raw.github.com/russmckendrick/dotfiles/master/assets/screenshot.png)

## Installation

See the following blog posts
 - https://www.russ.cloud/2014/08/10/dotfiles/ (from 2014)
 - https://www.russ.cloud/2024/04/02/updating-my-dotfiles/ (from 2024)

## Basic Settings

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
brew tap homebrew/cask-fonts
brew install font-hack-nerd-font starship
brew install tree pygments conda ffmpeg yt-dlp visual-studio-code drawio thefuck stow zoxide gh
gh extension install github/gh-copilot # enable the gh-copilot  extension
gh copilot alias -- zsh # run one and accept the t&cs
conda config --set changeps1 False
```

For IDEs update the `terminal.integrated.fontFamily` setting to `Hack Nerd Font Mono`.

## Deploying Dotfiles

Deploy the dotfiles using GNU Stow:

```bash
cd ~/.dotfiles
stow .
```

**Note:** Runtime data (history, projects, debug logs) stays local and is not synced.

## See it action

[![asciicast](https://asciinema.org/a/PTUqbpxikms7nFWNs4R7OhMQR.svg)](https://asciinema.org/a/PTUqbpxikms7nFWNs4R7OhMQR)

## Bashstrap

This started as my fork of [Bashstrap](https://github.com/barryclark/bashstrap).