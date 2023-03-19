SHELL := /usr/bin/env bash

LOGFILE := dotfiles.log
PACMAN_BUNDLE_FILE := Pacfile
AUR_BUNDLE_FILE := Aurfile
EXTRA_PKGS := 1

host := $(shell uname -s)
arch := $(shell uname -p)

ifeq ($(host),Darwin)
	is_linux = 0
else
	is_linux = 1

	ifeq ($(command -v paru 2>),"/usr/local/bin/paru"))
		paru_installed := $(shell command -v paru 2> /dev/null)
	else
		paru_installed = 0
	endif
endif


ifeq ($(host),Darwin)
all: configure-osx | apply
else
all: configure-linux | apply
endif

configure-linux:
	@echo "Updating pacman.conf.."
	sudo sed -i '/Color$/s/^#//g' /etc/pacman.conf
	sudo sed -i '/TotalDownload$/s/^#//g' /etc/pacman.conf
	sudo sed -i '/CheckSpace$/s/^#//g' /etc/pacman.conf
	sudo sed -i '/VerbosePkgLists$/s/^#//g' /etc/pacman.conf
	sudo sed -i '/^#\[multilib\]/{N;s/#//g}' /etc/pacman.conf

	@echo "Enable timedatectl and set up timezone"
	sudo timedatectl set-timezone America/Sao_Paulo
	sudo timedatectl set-ntp 1
	sudo timedatectl set-local-rtc 0
	sudo ln -sf /usr/share/zoneinfo/Ameriaca/Sao_Paulo /etc/localtime

	@echo "Setup locale"
	sudo sed -i '/en_US.UTF-8$/s/^#//g' /etc/pacman.conf
	sudo locale-gen

	@echo "Enable non-root access to dmesg"
	sudo /sbin/sysctl kernel.dmesg_restrict=0
	echo kernel.dmesg_restrict=0 | sudo tee -a /etc/sysctl.d/99-dmesg.conf

	@echo "Updating geoclue.conf.."
	redshift_line="\n[redshift]\nallowed=true\nsystem=false\nusers=\n"

	grep -qF "[redshift]" "/etc/geoclue/geoclue.conf" || echo -e "$redshift_line" | sudo tee -a "/etc/geoclue/geoclue.conf"

	@echo "Importing Spotify GPG key"
	curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | gpg --import -

	@echo "Importing Chaotic AUR"
	sudo pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
	sudo pacman-key --lsign-key FBA220DFC880C036
	sudo pacman -U --noconfirm \
		'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' \
		'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

	chaoticaur_lines="\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist"
	grep -qF "[chaotic-aur]" "/etc/pacman.conf" \
		|| echo -e "$chaoticaur_lines" | sudo tee -a "/etc/pacman.conf"

configure-osx:
	defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

	@echo "Save to disk and not in iCloud by default"
	defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

	@echo "Quit printer app when jobs are completed"
	defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

	@echo "Disable the “Are you sure you want to open this application?” dialog"
	defaults write com.apple.LaunchServices LSQuarantine -bool false

	@echo "Trackpad: enable tap to click for this user and for the login screen"
	defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
	defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
	defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

	@echo "Increase sound quality for Bluetooth headphones/headsets"
	defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

	@echo "Set a blazingly fast keyboard repeat rate"
	defaults write NSGlobalDomain KeyRepeat -int 1
	defaults write NSGlobalDomain InitialKeyRepeat -int 10

	@echo "Require password immediately after sleep or screen saver begins"
	defaults write com.apple.screensaver askForPassword -int 1
	defaults write com.apple.screensaver askForPasswordDelay -int 0

	@echo "Save screenshots to the desktop"
	defaults write com.apple.screencapture location -string "${HOME}/Desktop"

	@echo "Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)"
	defaults write com.apple.screencapture type -string "png"

	@echo "Finder: show hidden files by default"
	defaults write com.apple.finder AppleShowAllFiles -bool true

	@echo "Finder: show all filename extensions"
	defaults write NSGlobalDomain AppleShowAllExtensions -bool true

	@echo "Avoid creating .DS_Store files on network or USB volumes"
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
	defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

	@echo "Set to check daily instead of weekly"
	defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

	@echo "Set default clock format"
	defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM h:mm:ss a"

	@echo "Set Default Finder Location to Home Folder"
	defaults write com.apple.finder NewWindowTarget -string "PfLo"
	defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

	killall Finder
	killall SystemUIServer

	@echo "build locate database"
	sudo launchctl load -w /system/library/launchdaemons/com.apple.locate.plist || true

	@echo "enable firewall"
	sudo /usr/libexec/applicationfirewall/socketfilterfw --setglobalstate on

	@echo "set clock using network time"
	sudo systemsetup setusingnetworktime on

install-git-dependencies:
	if [[ -f "$(HOME)/.vim/autoload/plug.vim" && -x `command -v nvim` ]]; then \
		pip install neovim
		nvim +PlugInstall +qall --headless; \
		nvim +UpdateRemotePlugins +qall --headless; \
	fi

	if [[ ! -f "$(HOME)/.emacs.d/bin/doom" ]]; then \
		git clone --depth 1 https://github.com/hlissner/doom-emacs "$(HOME)/.emacs.d"; \
		"$(HOME)/.emacs.d/bin/doom" install -!; \
	else \
		"$(HOME)/.emacs.d/bin/doom" sync -e -!; \
	fi

	if [[ ! -f "usr/local/bin/notes" ]]; then \
		curl -L https://raw.githubusercontent.com/pimterry/notes/latest-release/install.sh | sudo bash; \
	fi

install-go-dependencies:
	@echo "Installing gitmux.."
	go install github.com/arl/gitmux@latest

	@echo "Installing gopls.."
	GO111MODULE=on go install golang.org/x/tools/gopls@latest

install-pyenv:
	if [[ "$(host)" == "Darwin"* ]]; then \
		LDFLAGS="-L/usr/local/opt/zlib/lib"; \
	fi

	if [ ! -d "$(HOME)/.pyenv" ]; then \
		curl https://pyenv.run | bash; \
		PATH="$(HOME)/.pyenv/bin:${PATH}"; \
		CFLAGS=-I/usr/include/openssl LDFLAGS=-L/usr/lib pyenv install -s 3.10.2; \
		CFLAGS=-I/usr/include/openssl LDFLAGS=-L/usr/lib pyenv install -s 3.8.12; \
		CFLAGS=-I/usr/include/openssl LDFLAGS=-L/usr/lib pyenv install -s 3.9.9; \
		CFLAGS=-I/usr/include/openssl LDFLAGS=-L/usr/lib pyenv install -s 3.11.0; \
	fi

	eval `pyenv init -)`
	pip install --upgrade -r scripts/requirements.txt


install-extra-dependencies:
	if [[ $(is_linux) -eq 1 ]]; then \
		sudo pacman -Syyu; \
		sudo pacman -S --noconfirm --needed - <"$(PACMAN_BUNDLE_FILE)"; \
		if [ $(paru_installed) -eq 1 ]; then \
			paru -S --noconfirm --nouseask --needed - <"$(AUR_BUNDLE_FILE)"; \
		else \
			git clone https://aur.archlinux.org/paru.git /tmp/paru; \
			(cd /tmp/paru && makepkg -si --noconfirm --needed && rm -rf /tmp/paru); \
			paru -S --noconfirm --nouseask --needed - <"$(AUR_BUNDLE_FILE)"; \
		fi; \
	else \
                brew update; \
                brew bundle; \
	fi

install-required-dependencies:
	if [[ $(is_linux) -eq 1 ]]; then \
		sudo pacman -S chezmoi bitwarden-cli; \
	else \
		brew install chezmoi bitwarden-cli; \
	fi

fix-permissions:
	@echo "Fixing GnuPG permissions"
	chown -R $(USER) ~/.gnupg/
	chmod 700 ~/.gnupg/*
	chmod 700 ~/.gnupg

	chmod 755 $(HOME)/.ssh
	[ -f "$(HOME)/.ssh/id_ed25519" ] && chmod 600 "$(HOME)/.ssh/id_ed25519"
	[ -f "$(HOME)/.ssh/id_ed25519.pub" ] && chmod 600 "$(HOME)/.ssh/id_ed25519.pub"

apply: install-required-dependencies
	bw login || true
	chezmoi apply -v
	$(MAKE) fix-permissions
