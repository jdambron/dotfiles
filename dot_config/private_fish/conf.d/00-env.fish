# editor basics
set -gx EDITOR (which nvim)

# manpager
set -x MANPAGER "nvim +Man!"
set -x MANROFFOPT -c
# less
set -x LESS -rF
