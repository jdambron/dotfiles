if status is-interactive
    # Commands to run in interactive sessions can go here
    set -gx GPG_TTY (tty)
    starship init fish | source
    fzf --fish | source
    zoxide init fish | source
    atuin init fish | source
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
