if ${use_color} ; then
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
	alias diff='colordiff'
fi
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias more=less
alias a2='aria2c --seed-time=0 --file-allocation=none'
alias l='exa'
alias ls='exa'
alias ll='exa -l'
alias la='exa -la'
