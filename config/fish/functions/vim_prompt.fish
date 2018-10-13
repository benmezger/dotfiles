# from:
# https://github.com/fish-shell/fish-shell/blob/master/share/functions/fish_default_mode_prompt.fish

# Display prompt current mode
function fish_default_mode_prompt --description "Display the default mode for the prompt"
    # Do nothing if not in vi mode
    if test "$fish_key_bindings" = "fish_vi_key_bindings"
        or test "$fish_key_bindings" = "fish_hybrid_key_bindings"
        switch $fish_bind_mode
            case default
                set_color --bold brmagenta
                echo '[N]'
            case insert
                set_color --bold 555 brblack
                echo '[I]'
            case replace_one
                set_color --bold normal
                echo '[R]'
            case visual
                set_color --bold --underline white
                echo '[V]'
        end
        set_color normal
        echo -n ' '
    end
end

