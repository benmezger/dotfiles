#!/bin/bash
IPYTHON_OPTS="notebook --port 8888 \
    --notebook-dir=~/workspace \
    --ip='*' --no-browser"
jupyter $IPYTHON_OPTS > /dev/null 2>&1 &
