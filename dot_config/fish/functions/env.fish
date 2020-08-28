function varclear --description 'Remove duplicates from environment variable'
    if test (count $argv) = 1
        set -l newvar
        set -l count 0
        for v in $$argv
            if contains -- $v $newvar
                set count (math $count+1)
            else
                set newvar $newvar $v
            end
        end
        set $argv $newvar
        test $count -gt 0
    else
        for a in $argv
            varclear $a
        end
    end
end

set _path /usr/local/{bin,} /usr/{bin,sbin} /{bin,sbin} $PATH
varclear _path

set _manpath /usr/local/share/man /usr/share/man $MANPATH
varclear _manpath

set _infopath /usr/local/share/info /usr/share/info $INFOPATH
varclear _infopath

set -g -x PATH $_path
set -x -g INFOPATH $_infopath
set -x -g MANPATH $_manpath

# Set pyenv
set -q PYENV_ROOT; or set -l PYENV_ROOT $HOME/.pyenv
set PATH $PYENV_ROOT/shims $PYENV_ROOT/bin $PATH
