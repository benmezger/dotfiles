#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR=$(chezmoi source-path)
export SOURCE_DIR

. "$SOURCE_DIR/scripts/buildcheck.sh"

. "$SOURCE_DIR/scripts/run_once_0002_install_deps.sh"
. "$SOURCE_DIR/scripts/run_once_0003_start_services.sh"

. "$SOURCE_DIR/scripts/run_once_0004_install_git_repos.sh"
. "$SOURCE_DIR/scripts/run_once_0005_configure_sys.sh"

. "$SOURCE_DIR/scripts/run_once_0006_set_ssh_perms.sh"
echo "Done"
