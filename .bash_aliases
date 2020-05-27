# enable color support if possible
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

	alias grep='grep --color=auto'
	alias egrep='egrep --color=auto'
	alias fgrep='fgrep --color=auto'

	alias ip='ip -color=auto'

	# ls does list directories first and file sizes are human-readable
    alias ls='ls --color=auto --group-directories-first --human-readable'
fi

# some more handy ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# use ls after cd
function cd_ls() {
	cd "$@" && ls .
}
alias cd='cd_ls'

# don't remove, instead move to trash (.local/share/Trash/files/)
# Remove trash via "gio trash --empty"
function Move2Trash(){
	if [ -n "$XDG_CURRENT_DESKTOP" ]; then
		hash gio && gio trash "$@"
	else
		echo "Removing file(s) is a bad habbit, instead you should move or rename them."
		echo "If you really have to remove some thing(s) you can use the full path i.e. /bin/rm"
	fi
}
alias rm='Move2Trash'
