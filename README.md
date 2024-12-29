## Personal Setup

### Requirements

- Chezmoi
- Arch Linux, NixOS, or macOS

### Installation

#### Without NixOS

**⚠️ Note:** _If you're not me, you won't have access to my 1Password account. To
prevent chezmoi from applying files with secrets, set the `SECRETS_OFF=1`
environment variable. If you do not use this flag, chezmoi will fail when
attempting to connect to my 1Password account ¯\_(ツ)_/¯._

```shell
SECRETS_OFF=1 chezmoi init https://github.com/benmezger/dotfiles.git -S ~/dotfiles
```

#### With NixOS

This method is guaranteed to work out of the box since `chezmoi` will not
attempt to download all dependencies. To install my NixOS configuration, simply
run the following command in the [./nix](./nix) directory:

```shell
sudo nixos-rebuild switch --flake .#default
```

### Environment Variables

The following environment variables can be used to configure `chezmoi` during
initialization and when applying changes:

- `ASK`: Set to `1` to enable prompts in `chezmoi`.
- `SECRETS_OFF`: Set to `1` to disable 1Password integration (uses my personal
  secrets defined in `.chezmoi.yaml`).
- `DOTFILES_MINIMAL`: Set to `1` to install the minimal version of the dotfiles.
- `WORKCONF`: Set to `1` to enable work-related configurations (e.g., work
  email, etc.).

For example, run `ASK=1 chezmoi apply` to enable prompts or `DOTFILES_MINIMAL=1
chezmoi apply` to generate the minimal configuration.

## Troubleshooting

### Chezmoi Is Not Reloading the Configuration

Run `chezmoi init <dotfiles-path>` again. This will reload the configuration by
regenerating [chezmoi.yaml](.chezmoi.yaml.tmpl) in
`$HOME/.config/chezmoi/chezmoi.yaml`.

### Sourcing Environment Variables With i3

For some reason, i3 sources `.xprofile` instead of `.xinitrc`. To get the GitHub
plugin for [i3status-rust](dot_config/i3/status.toml) to work, you need to set a
variable in your `.xprofile`:

```shell
export I3RS_GITHUB_TOKEN="your-github-token"
```

## Screenshots

### macOS

![](./static/osx-screenshot.png)

### Arch Linux

![](./static/arch-screenshot.png)

### Weechat IRC

![](./static/weechat.png)

### Emacs

![](./static/emacs.png)

## Contributing

1. Feel free to contribute and/or report any issues.
