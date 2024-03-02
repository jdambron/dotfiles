if status is-interactive
    # Commands to run in interactive sessions can go here
    set -gx GPG_TTY (tty)
    zoxide init fish | source
    atuin init fish | source
end
