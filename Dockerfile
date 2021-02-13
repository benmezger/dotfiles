FROM archlinux:base-devel
MAINTAINER Ben Mezger <me@benmezger.nl>

# TEMP-FIX for pacman issue
RUN patched_glibc=glibc-linux4-2.33-4-x86_64.pkg.tar.zst && \
        curl -LO "https://repo.archlinuxcn.org/x86_64/$patched_glibc" && \
        bsdtar -C / -xvf "$patched_glibc"

RUN pacman -Syu --noconfirm
RUN pacman -S sudo git file awk gcc base-devel reflector --noconfirm

RUN reflector --latest 5 \
        --save "/etc/pacman.d/mirrorlist" \
        --sort rate \
        --verbose

RUN useradd -ms /bin/bash archie
RUN gpasswd -a archie wheel
RUN echo 'archie ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER archie

RUN mkdir /home/archie/dotfiles
COPY  --chown=archie:users . ./home/archie/dotfiles
WORKDIR /home/archie/dotfiles

ENTRYPOINT ["sh", "docker-entrypoint.sh"]
