FROM archlinux
MAINTAINER Ben Mezger <me@benmezger.nl>

RUN pacman -Syu --noconfirm
RUN pacman -S git file awk gcc ansible base-devel --noconfirm

COPY . ./usr/src/
WORKDIR ./usr/src/

ENTRYPOINT ["sh", "docker-entrypoint.sh"]
