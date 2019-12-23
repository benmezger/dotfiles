# Dotfiles

## Requirements

1. Ansible

My OSX dotfiles can be found in the `osx` branch.

## Installing

1. Install Ansible roles with from the requirements file:
    * `ansible-galaxy install -r requirements.yml`

### OSX

1. Switch to the `OSX` branch and run:
    * `ansible-playbook -i inventory osx.yml -K`

### Archlinux

1. Switch to the `master` branch and run:
    * `ansible-playbook -i inventory archlinux.yml -K`
