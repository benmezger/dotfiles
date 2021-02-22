LOGFILE="/tmp/dotfiles.log"

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
	@echo '    make hugo-build         Update documentation.'
	@echo '    make ensure-dirs        Creates required directories.'
	@echo '    make install-riscv      Install RISC-V toolchain and dependencies.'
	@echo '    make install-rust       Install Rust.'
	@echo '    make run                Ensure deps and apply chezmoi.'
	@echo '    make all                Run all.'
	@echo ''
	@echo '    Author                  Ben Mezger (github.com/benmezger)'
	@echo

install-riscv:
	@echo "Installing RISCV dependencies.."
	bash ./scripts/install_riscv.sh | tee -a $(LOGFILE)

archlinux-firewall:
	@echo "Setting up firewall.."
	bash ./scripts/set_firewall_rules.sh | tee -a $(LOGFILE)

start-services:
	@echo "Starting services.."
	bash ./scripts/start_services.sh | tee -a $(LOGFILE)

git-repos:
	@echo "Cloning Git repos.."
	bash ./scripts/install_git_repos.sh | tee -a $(LOGFILE)

conf-sys:
	@echo "Configuring system.."
	bash ./scripts/configure_sys.sh | tee -a $(LOGFILE)

ssh-perms:
	@echo "Setting SSH permissions.."
	bash ./scripts/set_ssh_perms.sh | tee -a $(LOGFILE)

gnupg-perms:
	@echo "Setting GnuPG permissions.."
	bash ./scripts/fix_gnupg_perms.sh | tee -a $(LOGFILE)

pyenv:
	@echo "Installing pyenv.."
	bash ./scripts/install_pyenv.sh | tee -a $(LOGFILE)

osx-defaults: 
	@echo "Applying OSX defaults.."
	bash ./scripts/set_osx_defaults.sh | tee -a $(LOGFILE)

archlinux-defaults: 
	@echo "Applying Archlinux defaults.."
	bash ./scripts/set_osx_defaults.sh | tee -a $(LOGFILE)

install-chezmoi:
	@echo "Installing chezmoi.."
	bash ./scripts/install_chezmoi.sh | tee -a $(LOGFILE)

install-deps:
	@echo "Installing dependencies.."
	bash ./scripts/install_deps.sh | tee -a $(LOGFILE)

install-aur:
	@echo "Installing AUR packages.."
	bash ./scripts/install_aur_packages.sh | tee -a $(LOGFILE)

install-homebrew:
	@echo "Installing homebrew.."
	bash ./scripts/install_homebrew.sh | tee -a $(LOGFILE)

ensure-dirs:
	@echo "Ensuring directories.."
	bash ./scripts/ensure_directories.sh | tee -a $(LOGFILE)

ensure-deps:
	@echo "Ensuring dependencies.."
	$(MAKE) install-homebrew
	$(MAKE) install-chezmoi
	$(MAKE) install-deps
	$(MAKE) install-aur

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
	@echo "Done"

install-rust:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

hugo-build:
	@echo "Running hugo build.."
	git submodule update --init
	hugo 
