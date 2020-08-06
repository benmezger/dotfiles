# Dotfiles

My personal dotfiles. The following configuration exists:

```sh
drwxr-xr-x    6 benmezger staff  192 Jul 17 11:35 X
drwxr-xr-x    3 benmezger staff   96 Jul 17 11:35 bin
drwxr-xr-x    3 benmezger staff   96 Jul 17 11:35 doom-emacs
drwxr-xr-x    3 benmezger staff   96 Jul 17 11:35 dunst
drwxr-xr-x    3 benmezger staff   96 Jul 17 11:35 emacs
drwxr-xr-x    3 benmezger staff   96 Jul 17 11:35 fish
drwxr-xr-x    5 benmezger staff  160 Jul 17 12:24 git
drwxr-xr-x    3 benmezger staff   96 Jul 17 11:35 gnupg
drwxr-xr-x    3 benmezger staff   96 Jul 17 11:35 i3
drwxr-xr-x    3 benmezger staff   96 Jul 17 11:35 ipython
drwxr-xr-x    9 benmezger staff  288 Jul 21 16:44 misc
drwxr-xr-x    3 benmezger staff   96 Jul 17 11:35 tmux
drwxr-xr-x    3 benmezger staff   96 Jul 17 11:35 vim
drwxr-xr-x    5 benmezger staff  160 Jul 17 12:24 zsh
```

## Installing

### Requirements

- Ansible

Install Ansible galaxy requirements with `ansible-galaxy install -r requirements.yml`

### Installing

- Install `chezmoi`
- `chezmoi -S ~/dotfiles init https://github/benmezger/dotfiles`
- `chezmoi -S ~/dotfiles apply -v`

## Dependencies

- ZSH
  - [Antibody](https://github.com/getantibody/antibody)
  - [FZF](https://github.com/junegunn/fzf)
- Emacs
  - [Emacs doom](https://github.com/hlissner/doom-emacs)
- System utilities
  - [wakatime](https://github.com/wakatime/wakatime)
  - [emacs](https://www.gnu.org/software/emacs/)
  - [stow](https://www.gnu.org/software/stow/)
- OSX
  - [brew](https://brew.sh/)
  - [mas](https://github.com/mas-cli/mas)
- Linux
  - [i3](https://i3wm.org/)
  - [aura](https://github.com/fosskers/aura) (archlinux)
