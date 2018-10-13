#!/usr/local/bin/fish

# from: https://github.com/toshiya240/fish-tmux/blob/master/functions/__tmux_start.fish

function __tmux_start -d "start tmux"
    # return if requirements are not found.
    if not which tmux >/dev/null ^&1
        return 1
    end

    #
    # Auto Start
    #

    if test -z "$TMUX" -a -z "$EMACS" -a -z "$VIM" \
            -a \( \( -n "$SSH_TTY" -a $TMUX_AUTO_START_REMOTE -eq 1 \) \
                -o \( -z "$SSH_TTY" -a $TMUX_AUTO_START_LOCAL -eq 1 \) \)
        tmux start-server

        # create session
        if not tmux has-session ^/dev/null
            set -l tmux_session 'fish'
            tmux \
                new-session -d -s "$tmux_session" \; \
                set-option -t "$tmux_session" destroy-unattached off >/dev/null ^&1
        end
    end
end

cd /Users/$USER
__tmux_start