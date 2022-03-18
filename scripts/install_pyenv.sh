#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. "$DIR/base.sh"
. "$DIR/minimalcheck.sh"

PYTHON_REQUIREMENTS="$DIR/requirements.txt"
PYTHON_VERSION=3.10.2

# see github.com/pyenv/pyenv/issues/1219
if [[ "$OSTYPE" == "darwin"* ]]; then
	export LDFLAGS="-L/usr/local/opt/zlib/lib"
fi

PYENV_DIR="$HOME/.pyenv"
if [ ! -d "$PYENV_DIR" ]; then
	curl https://pyenv.run | bash
	export PATH="$HOME/.pyenv/bin:$PATH"
	pyenv install -s $PYTHON_VERSION
fi

eval "$(pyenv init -)"
pyenv virtualenv --force $PYTHON_VERSION personal
pyenv local personal
pip install --upgrade -r $PYTHON_REQUIREMENTS
mv $DIR/../.python-version $HOME
