FROM archlinux
MAINTAINER Ben Mezger <me@benmezger.nl>

RUN pacman -Syu --noconfirm
RUN pacman -S git file awk gcc ansible base-devel --noconfirm

WORKDIR ~/
COPY . ./dotfiles
WORKDIR ./dotfiles

ENTRYPOINT ["sh", "docker-entrypoint.sh"]
