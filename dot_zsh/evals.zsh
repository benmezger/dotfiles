#!/usr/bin/env zsh

set_pyenv() {
    if (( ${+commands[pyenv]} )); then
        _set_pyenv() {
            export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
            export PYENV_VIRTUALENV_DISABLE_PROMPT=1
            . $(pyenv root)/completions/pyenv.zsh
        }
        async_start_worker pyenv_worker -n
        async_register_callback pyenv_worker _set_pyenv
        async_job pyenv_worker sleep 0.1
    fi
}


set_dircolors(){
    _set_dircolors() {
        if (( $+commands[dircolors] )); then
            eval $(dircolors -b $HOME/.dircolors )
        elif (( $+commands[gdircolors] )); then
            eval $(gdircolors -b $HOME/.dircolors )
        fi
    }
    async_start_worker dircolors_worker -n
    async_register_callback dircolors_worker _set_dircolors
    async_job dircolors_worker sleep 0.1
}

set_tmuxenv(){
    _set_tmuxenv() {
        if (( $+commands[tmux] )); then
	    tmux set-environment -g PATH $PATH
        fi
    }
    async_start_worker tmux_worker -n
    async_register_callback tmux_worker _set_tmuxenv
    async_job tmux_worker sleep 0.1
}

set_rustsrc(){
    _set_rustsrc() {
	if (( $+commands[rustc] )); then
	    export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/library
        fi
    }
    async_start_worker rustsrc_worker -n
    async_register_callback rustsrc_worker _set_rustsrc
    async_job rustsrc_worker sleep 0.1
}

init_jobs() {
    async_init

    set_pyenv
    set_dircolors

    if [ -n "${TMUX+1}" ]; then
        set_tmuxenv
    fi

    set_rustsrc
}

init_jobs
