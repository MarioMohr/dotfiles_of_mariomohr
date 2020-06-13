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

# long listing of directory content, including dotfiles
alias ll='ls -laA'

# long listing of directory content, including dotfiles and sort them by date (new entries are at the bottom)
alias lt='ls -ltra'

# list directories only
function lsd(){
	ls -laA "$@" | grep ^d | awk '{print $9}' | column
}

# use ls after cd
function CD_LS(){
	cd "$@" && ls .
}
alias cd='CD_LS'

# don't remove, instead move to trash (.local/share/Trash/files/)
# Remove trash via "gio trash --empty"
function MOVE2TRASH(){
	if [ -n "$XDG_CURRENT_DESKTOP" ]; then
		hash gio && gio trash "$@"
	else
		echo "Removing file(s) is a bad habbit, instead you should move or rename them."
		echo "If you really have to remove some thing(s) you can use the full path i.e. /bin/rm"
	fi
}
alias rm='MOVE2TRASH'
