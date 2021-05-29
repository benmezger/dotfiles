+++
title = "README"
author = ["Ben Mezger"]
date = 2020-08-06T00:00:00-03:00
lastmod = 2021-05-28T23:40:17-03:00
draft = false
+++

<div class="ox-hugo-toc toc">
<div></div>

<div class="heading">Table of Contents</div>

- [Installing this configuration](#installing-this-configuration)
  - [Requirements](#requirements)
  - [Installing](#installing)
    - [Full version](#full-version)
    - [Minimal version](#minimal-version)
- [Keybindings](#keybindings)
  - [OSX](#osx)
    - [MPC](#mpc)
- [Troubleshooting](#troubleshooting)
  - [Chezmoi does not seem to reload the configuration](#chezmoi-does-not-seem-to-reload-the-configuration)
  - [Sourcing env with i3](#sourcing-env-with-i3)

</div>
<!--endtoc-->

{{< figure src="https://github.com/benmezger/dotfiles/workflows/dotfiles/badge.svg" link="https://github.com/benmezger/dotfiles/actions" >}}

## Installing this configuration {#installing-this-configuration}

### Requirements {#requirements}

- Chezmoi
- Archlinux or OSX

### Installing {#installing}

**Note:** You are required to use the `env` variable `SECRETS_OFF=1`, as not passing will
make chezmoi fail when connecting to my bitwarden's account.

The following environment variables can be set to configure Chezmoi on runtime:

- `ASK`: Set to `1` if you want to enable chezmoi prompt
- `SECRETS_OFF`: Set to `1` to enable Bitwarden (uses my personal secrets set in
  .chezmoi.yaml)
- `DOTFILES_MINIMAL`: Set to `1` if you want to install the minimal version

Chezmoi allows easy install of this configuration by running the following
command:

#### Full version {#full-version}

```shell
SECRETS_OFF=1 chezmoi init https://github.com/benmezger/dotfiles.git -S ~/dotfiles
```

#### Minimal version {#minimal-version}

The minimal version installs only the essentials.

- zsh
- git
- vim
- emacs
- tmux
- curl
- alacritty
- neovim
- user-dirs
- editorconfig
- dircolors

<!--listend-->

```shell
SECRETS_OFF=1 DOTFILES_MINIMAL=1 chezmoi init https://github.com/benmezger/dotfiles.git -S ~/dotfiles
```

## Keybindings {#keybindings}

### OSX {#osx}

#### MPC {#mpc}

- `fn + cmd - e` - `opens editor`
- `cmd + return` - `opens alacritty`
- `fn + cmd - f1` - `mpc play`
- `fn + cmd - f2` - `mpc pause`
- `fn + cmd - f3` - `mpc prev`
- `fn + cmd - f4` - `mpc next`
- `fn + cmd - f5` - `mpc volume -10`
- `fn + cmd - f6` - `mpc volume +10`

## Troubleshooting {#troubleshooting}

### Chezmoi does not seem to reload the configuration {#chezmoi-does-not-seem-to-reload-the-configuration}

Run `chezmoi init <dotfiles-path>` again. This should reload the configuration
by copying [chezmoi.yaml](.chezmoi.yaml.tmpl) to `$HOME/.config/chezmoi/chezmoi.yaml`.

### Sourcing env with i3 {#sourcing-env-with-i3}

For some reason, i3 is sourcing `.xprofile` instead of `xinitrc`, so for
getting Github plugin for the [i3status-rust](dot_config/i3/status.toml) you need to set up a variable in
your `.xprofile`

```shell
export I3RS_GITHUB_TOKEN="your-github-token"
```
