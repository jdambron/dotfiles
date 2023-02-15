#!/bin/bash

# Make nvim the default editor
export VISUAL=nvim;
export EDITOR="$VISUAL";
# Improve bash history
export HISTCONTROL=erasedups:ignorespace;
export HISTIGNORE=" *:ls:cd:cd -:pwd:exit:date:* --help:* -h";
# "bat" as manpager
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# Configure fzf with catppuccin-frappe
export FZF_DEFAULT_OPTS=" \
--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
--color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"
