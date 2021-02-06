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
	@echo '    make ensure-deps        Install dependencies.'
	@echo '    make chezmoi-init       Initialize chezmoi.'
	@echo '    make chezmoi-apply      Apply chezmoi files (runs all scripts).'
	@echo '    make post-chezmoi       Run post chezmoi scripts.'
	@echo '    make run		   Ensure deps and apply chezmoi'
	@echo '    make all		   Run all.'
	@echo ''
	@echo '    Author   		   Ben Mezger (github.com/benmezger)'
	@echo

start-services:
	@echo "Starting services.."
	bash ./scripts/run_once_0003_start_services.sh

git-repos:
	@echo "Cloning Git repos.."
	bash ./scripts/run_once_0004_install_git_repos.sh

conf-sys:
	@echo "Configuring system.."
	bash ./scripts/run_once_0005_configure_sys.sh

ssh-perms:
	@echo "Setting SSH permissions.."
	bash ./scripts/run_once_0006_set_ssh_perms.sh

pyenv:
	@echo "Installing pyenv.."
	bash ./scripts/run_once_0007_install_pyenv.sh

ensure-deps:
	@echo "Ensuring dependencies.."
	bash ./scripts/0001_install_chezmoi.sh
	bash ./scripts/run_once_0002_install_deps.sh

chezmoi-init: 
	@echo "Initializing chezmoi.."
	chezmoi init -S ${CURDIR} -v

chezmoi-apply: 
	@echo "Applying chezmoi.."
	chezmoi apply -v

all: ensure-deps \
	start-services \
	git-repos \
	conf-sys \
	ssh-perms \
	chezmoi-init \
	chezmoi-apply

run: ensure-deps \
	chezmoi-init \
	chezmoi-apply

post-chezmoi: start-services \
	git-repos \
	conf-sys \
	ssh-perms
	@echo "Done"
