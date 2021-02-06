FROM archlinux
MAINTAINER Ben Mezger <me@benmezger.nl>

RUN pacman -Syu --noconfirm
RUN pacman -S sudo git file awk gcc base-devel --noconfirm

RUN useradd -ms /bin/bash archie
RUN gpasswd -a archie wheel
RUN echo 'archie ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER archie

RUN mkdir /home/archie/dotfiles
COPY  --chown=archie:users . ./home/archie/dotfiles
WORKDIR /home/archie/dotfiles

ENTRYPOINT ["sh", "docker-entrypoint.sh"]
