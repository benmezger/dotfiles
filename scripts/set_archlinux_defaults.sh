#!/usr/bin/env bash
set -euo pipefail

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
. "$DIR/base.sh"
. "$DIR/ansi"
. "$DIR/minimalcheck.sh"

if [[ "$OSTYPE" != "linux-gnu"* ]]; then
	ansi --yellow "Platform is not linux-gnu"
fi

if [ ! -f "/etc/arch-release" ]; then
	ansi --yellow "Not running arch. Skipping."
fi

# ask sudo upfront
sudo -v

ansi --green "Updating pacman.conf.."
sudo sed -i '/Color$/s/^#//g' /etc/pacman.conf
sudo sed -i '/TotalDownload$/s/^#//g' /etc/pacman.conf
sudo sed -i '/CheckSpace$/s/^#//g' /etc/pacman.conf
sudo sed -i '/VerbosePkgLists$/s/^#//g' /etc/pacman.conf
sudo sed -i '/^#\[multilib\]/{N;s/#//g}' /etc/pacman.conf

ansi --green "Enable timedatectl and set up timezone"
sudo timedatectl set-timezone America/Sao_Paulo
sudo timedatectl set-ntp 1
sudo timedatectl set-local-rtc 0
sudo ln -sf /usr/share/zoneinfo/Ameriaca/Sao_Paulo /etc/localtime

ansi --green "Setup locale"
sudo sed -i '/en_US.UTF-8$/s/^#//g' /etc/pacman.conf
sudo locale-gen

ansi --green "Enable non-root access to dmesg"
sudo /sbin/sysctl kernel.dmesg_restrict=0
echo kernel.dmesg_restrict=0 | sudo tee -a /etc/sysctl.d/99-dmesg.conf

ansi --green "Updating geoclue.conf.."
redshift_line="\n[redshift]\nallowed=true\nsystem=false\nusers=\n"

grep -qF "[redshift]" "/etc/geoclue/geoclue.conf" \
	|| echo -e "$redshift_line" | sudo tee -a "/etc/geoclue/geoclue.conf"

ansi --green "Importing Spotify GPG key"
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | gpg --import -

ansi --green "Importing Chaotic AUR"
sudo pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key FBA220DFC880C036
sudo pacman -U --noconfirm \
	'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' \
	'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

chaoticaur_lines="\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist"
grep -qF "[chaotic-aur]" "/etc/pacman.conf" \
	|| echo -e "$chaoticaur_lines" | sudo tee -a "/etc/pacman.conf"
