# editor basics
set -gx EDITOR (which nvim)
set -gx VISUAL $EDITOR
set -gx SUDO_EDITOR $EDITOR

# manpager
set -x MANPAGER "nvim +Man!"
set -x MANROFFOPT -c
# less
set -x LESS -rF
