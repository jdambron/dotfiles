#!/bin/bash

# Make vim the default editor
export VISUAL=vim;
export EDITOR="$VISUAL";
# Improve bash history
export HISTCONTROL=erasedups:ignorespace;
export HISTIGNORE=" *:ls:cd:cd -:pwd:exit:date:* --help:* -h";
