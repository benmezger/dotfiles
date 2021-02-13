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
	@echo '    make pyenv              Install pyenv.'
	@echo '    make osx-defaults       Configure defaults for OSX'
	@echo '    make ensure-deps        Install dependencies.'
	@echo '    make chezmoi-init       Initialize chezmoi.'
	@echo '    make chezmoi-apply      Apply chezmoi files (runs all scripts).'
	@echo '    make post-chezmoi       Run post chezmoi scripts.'
	@echo '    make homebrew-install   Install Homebrew.'
	@echo '    make run                Ensure deps and apply chezmoi'
	@echo '    make all                Run all.'
	@echo ''
	@echo '    Author                  Ben Mezger (github.com/benmezger)'
	@echo

start-services:
	@echo "Starting services.."
	bash ./scripts/0003_start_services.sh | tee -a $(LOGFILE)

git-repos:
	@echo "Cloning Git repos.."
	bash ./scripts/0004_install_git_repos.sh | tee -a $(LOGFILE)

conf-sys:
	@echo "Configuring system.."
	bash ./scripts/0005_configure_sys.sh | tee -a $(LOGFILE)

ssh-perms:
	@echo "Setting SSH permissions.."
	bash ./scripts/0006_set_ssh_perms.sh | tee -a $(LOGFILE)

pyenv:
	@echo "Installing pyenv.."
	bash ./scripts/0007_install_pyenv.sh | tee -a $(LOGFILE)

osx-defaults: 
	@echo "Applying OSX defaults.."
	bash ./scripts/0009_set_osx_defaults.sh | tee -a $(LOGFILE)

archlinux-defaults: 
	@echo "Applying Archlinux defaults.."
	bash ./scripts/0009_set_osx_defaults.sh | tee -a $(LOGFILE)

ensure-deps:
	@echo "Ensuring dependencies.."
	bash ./scripts/0001_install_chezmoi.sh | tee -a $(LOGFILE)
	bash ./scripts/0002_install_deps.sh | tee -a $(LOGFILE)

chezmoi-init: 
	@echo "Initializing chezmoi.."
	chezmoi init -S ${CURDIR} -v 

chezmoi-apply: 
	@echo "Applying chezmoi.."
	chezmoi apply -v 

homebrew-install:
	@echo "Installing homebrew.."
	bash ./scripts/0008_install_homebrew.sh | tee -a $(LOGFILE)

all:
	$(MAKE) ensure-deps
	$(MAKE) start-services
	$(MAKE) git-repos
	$(MAKE) conf-sys
	$(MAKE) ssh-perms
	$(MAKE) chezmoi-init
	$(MAKE) osx-defaults
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
	@echo "Done"