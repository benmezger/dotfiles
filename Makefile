LOGFILE=/tmp/dotfiles.log

default: run
help:
	@echo 'Management commands for dotfiles:'
	@echo
	@echo 'Usage:'
	@echo '    make start-services     Starts services (systemd, brew services..).'
	@echo '    make git-repos          Clone Git repos.'
	@echo '    make conf-sys           Configure system files.'
	@echo '    make ssh-perms          Set SSH permissions.'
	@echo '    make gnupg-perms        Set GnuPG permissions.'
	@echo '    make pyenv              Install pyenv.'
	@echo '    make osx-defaults       Configure defaults for OSX'
	@echo '    make ensure-deps        Install all dependencies.'
	@echo '    make chezmoi-init       Initialize chezmoi.'
	@echo '    make chezmoi-apply      Apply chezmoi files (runs all scripts).'
	@echo '    make post-chezmoi       Run post chezmoi scripts.'
	@echo '    make install-homebrew   Install Homebrew.'
	@echo '    make install-chezmoi    Install chezmoi.'
	@echo '    make install-aur        Install AUR packages .'
	@echo '    make install-deps       Install system dependencies.'
	@echo '    make ensure-dirs        Creates required directories.'
	@echo '    make install-riscv      Install RISC-V toolchain and dependencies.'
	@echo '    make install-rust       Install Rust.'
	@echo '    make install-go-deps    Install go dependencies.'
	@echo '    make install-osx-app    Install MacOS applications (requires mas).'
	@echo '    make install-grub-theme Install Archlinux\'s grub theme (requires grub and git)'

	@echo
	@echo '    make run                Ensure deps and apply chezmoi.'
	@echo '    make all                Run all.'
	@echo
	@echo '    Logs are stored in      $(LOGFILE)'
	@echo
	@echo '    Author                  Ben Mezger (github.com/benmezger)'

install-riscv:
	@echo "Installing RISCV dependencies.."
	bash ./scripts/install_riscv.sh | tee -a $(LOGFILE) || exit 1

archlinux-firewall:
	@echo "Setting up firewall.."
	bash ./scripts/set_firewall_rules.sh | tee -a $(LOGFILE) || exit 1

start-services:
	@echo "Starting services.."
	bash ./scripts/start_services.sh | tee -a $(LOGFILE) || exit 1

git-repos:
	@echo "Cloning Git repos.."
	bash ./scripts/install_git_repos.sh | tee -a $(LOGFILE) || exit 1

conf-sys:
	@echo "Configuring system.."
	bash ./scripts/configure_sys.sh | tee -a $(LOGFILE) || exit 1

ssh-perms:
	@echo "Setting SSH permissions.."
	bash ./scripts/set_ssh_perms.sh | tee -a $(LOGFILE) || exit 1

gnupg-perms:
	@echo "Setting GnuPG permissions.."
	bash ./scripts/fix_gnupg_perms.sh | tee -a $(LOGFILE) || exit 1

pyenv:
	@echo "Installing pyenv.."
	bash ./scripts/install_pyenv.sh | tee -a $(LOGFILE) || exit 1

osx-defaults: 
	@echo "Applying OSX defaults.."
	bash ./scripts/set_osx_defaults.sh | tee -a $(LOGFILE) || exit 1

archlinux-defaults: 
	@echo "Applying Archlinux defaults.."
	bash ./scripts/set_archlinux_defaults.sh | tee -a $(LOGFILE) || exit 1

install-chezmoi:
	@echo "Installing chezmoi.."
	bash ./scripts/install_chezmoi.sh | tee -a $(LOGFILE) || exit 1

install-deps:
	@echo "Installing dependencies.."
	bash ./scripts/install_deps.sh | tee -a $(LOGFILE) || exit 1

install-aur:
	@echo "Installing AUR packages.."
	bash ./scripts/install_aur_packages.sh | tee -a $(LOGFILE) || exit 1

install-homebrew:
	@echo "Installing homebrew.."
	bash ./scripts/install_homebrew.sh | tee -a $(LOGFILE) || exit 1

ensure-dirs:
	@echo "Ensuring directories.."
	bash ./scripts/ensure_directories.sh | tee -a $(LOGFILE) || exit 1

install-go-deps:
	@echo "Installing go packages.."
	bash ./scripts/install_go_packages.sh | tee -a $(LOGFILE) || exit 1

ensure-deps:
	@echo "Ensuring dependencies.."
	$(MAKE) install-homebrew
	$(MAKE) install-chezmoi
	$(MAKE) install-deps
	$(MAKE) install-aur
	$(MAKE) install-go-deps

chezmoi-init: 
	@echo "Initializing chezmoi.."
	chezmoi init -S ${CURDIR} -v 

chezmoi-apply: 
	@echo "Applying chezmoi.."
	chezmoi apply -v 

all:
	$(MAKE) ensure-deps
	$(MAKE) start-services
	$(MAKE) git-repos
	$(MAKE) conf-sys
	$(MAKE) ssh-perms
	$(MAKE) gnupg-perms
	$(MAKE) chezmoi-init
	$(MAKE) osx-defaults
	$(MAKE) ensure-dirs
	$(MAKE) chezmoi-apply

run:
	$(MAKE) ensure-deps 
	$(MAKE) chezmoi-init 
	$(MAKE) chezmoi-apply

post-chezmoi:
	$(MAKE) start-services
	$(MAKE) git-repos
	$(MAKE) conf-sys
	$(MAKE) ssh-perms
	$(MAKE) gnupg-perms
	$(MAKE) ensure-dirs
	$(MAKE) pyenv
	@echo "Done"

install-rust:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	rustup toolchain add nightly
	rustup default nightly

	rustup component add rust-src rustc-dev llvm-tools-preview clippy-preview
	rustup target add riscv32imac-unknown-none-elf
	rustup target add riscv64imac-unknown-none-elf

	cargo install racer


install-osx-apps:
	@echo "Installing Amphetamine"
	mas install 937984704

generate-changelog:
	git-chglog -o CHANGELOG.md

install-python-system-pip:
	/usr/bin/pip3 install -r scripts/requirements.txt

install-grub-theme:
	@echo "Installing Grub theme.."
	bash ./scripts/install_grub.sh | tee -a $(LOGFILE) || exit 1
