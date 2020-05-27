# /etc/skel/.bashrc or  ~/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# enable vi-editing-mode for the cmd line by pressing ESC and go back to cmd-mode via i or a.
set -o vi

#https://stackoverflow.com/questions/15883416/adding-git-branch-on-the-bash-command-prompt
source ~/.local/bin/git-prompt.sh

# https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
DefaultColor='\[\e[0;34m\]'	# Default color
NoColor='\001\e[0m\002'		# this is needed to end color changes of fonts

PID_Color='\[\e[1;33m\]'	# Color of Process ID
ERR_Color='\[\e[0;31m\]'	# Color of Error Code

# function need to be executed with a DEBUG trap
function Timer_Start {
	timer=${timer:-$SECONDS}	# timer start on execution of commands in bash
	PID_Number="$!"			# get the Process Identification of the last background command (&) in bash
	if [ "$PID_Number" != "$PID_Number2" ]; then	# checks if a new Process Identification was created
		PID_Show="${DefaultColor},${NoColor} ${PID_Color}PID:${PID_Number}${NoColor}"	# pretty print PID of last background command
		PID_Number2="$PID_Number"				# copy PID
	else
		PID_Show=""	# remove old PID string
	fi
}

# function needs to be executed in PROMPT_COMMAND 
function Timer_Stop {
	Status_Code="$?"			# Error Code of last command
	Timer_Secs=$(($SECONDS - $timer))	# get duration (seconds) of last executed command
	unset timer				# stop counting
	if [ $Timer_Secs -gt 59 ]; then		# greater than
		((h=${Timer_Secs}/3600))	# calculate how many hours were used
		((m=(${Timer_Secs}%3600)/60))	# calculate remaining minutes
		((s=${Timer_Secs}%60))		# calculate remaining seconds
		Timer_HMS=`printf "%02dh:%02dm:%02ds\n" $h $m $s`
		Timer_Show="${DefaultColor},${NoColor} ${Timer_HMS}"	# pretty print duration of last executed command
	else
		Timer_Show=""						# remove old string
	fi
	if [ "$Status_Code" -ne "0" ]; then		# not equal
		Status_Code="${DefaultColor},${NoColor} ${ERR_Color}ERR:${Status_Code}${NoColor}"	# pretty print error code
	else
		Status_Code=						# remove old string
	fi
	Git_Branch=$(__git_ps1 "%s")
	if [ -n "$Git_Branch" ]; then	# string does exsist
		Git_Show="${DefaultColor} = ${Git_Branch}${NoColor}"	# pretty print git branch
	else
		Git_Show=""		# remove old string
	fi
	PS1=$(echo -e "${DefaultColor}[${NoColor}\\W${Git_Show}${PID_Show}${Status_Code}${Timer_Show}${DefaultColor}]${NoColor} ")	# prompt output
	Timer_Show=""	# remove old string
	Status_Code=""	# remove old string
}

trap 'Timer_Start' DEBUG	# start function when execute a command in bash
PROMPT_COMMAND=Timer_Stop	# start function after execution of a command in bash

####################
# escape sequences #
####################

# \a	das ASCII bell Zeichen (07)
# \A	Uhrzeit im 24-Stunden Format (hh:mm)
# \d	Datum in "Wochentag Monat Tag" z.B., "Mit Mai 26")
# \e	ASCII escape Zeichen (033)
# \h	Hostname auf dem die Shell läuft bis zum ersten "."
# \H	Hostname komplett
# \j	Anzahl der Jobs in der Shell
# \l	Das tty, auf dem die Shell läuft
# \n	Neue Zeile
# \t	Uhrzeit im 24-Stunden Format (hh:mm:ss)
# \T	Uhrzeit im 12-Stunden Format (hh:mm:ss)
# \r	carriage return
# \s	Name der verwendeten Shell (sh, bash, ..)
# \u	Name des Nutzers, der die Shell gestartet hat
# \v	Version der bash (z.B. 2.00)
# \V	Release der bash, Version, Patchlevel
# \w	momentanes Arbeitsverzeichnis
# \W	letzte Komponente des Arbeitsverzeichnisses
# \! 	Aktuelle History-Nummer
# \# 	Aktuelle Befehls-Nummer
# \$ 	Wenn root ein "#", sonst ein "$"
# \\ 	Backslash
# \nnn	Zeichen entsprechend der oktalen Zahl nnn
# \[	Beginn einer Sequenz von nicht-darstellbaren Zeichen
# \]	Ende einer Sequenz von nicht-darstellbaren Zeichen
# \@	Aktuelle Zeit im 12-Stunden am/pm Format 

###############
# some colors #
###############

#Black='\[\e[0;30m\]'
#DarkGray='\[\e[1;30m\]'
#Red='\[\e[0;31m\]'
#LightRed='\[\e[1;31m\]'
#DarkGold='\001\e[38;5;178m\002'
#DarkOrange='\001\e[38;5;214m\002'
#LightRed='\001\e[1;31m\002'
#DarkGreen='\001\e[38;5;22m\002'
#Green='\[\e[0;32m\]'
#LightGreen='\[\e[1;32m\]'
#Brown='\[\e[0;33m\]'
#Yellow='\[\e[1;33m\]'
#Blue='\[\e[0;34m\]'
#LightBlue='\[\e[1;34m\]'
#Purple='\[\e[0;35m\]'
#LightPurple='\[\e[1;35m\]'
#DarkTurquoise='\[\e[0;36m\]'
#Turquoise='\[\e[1;36m\]'
#LightGray='\[\e[0;37m\]'
#White='\[\e[1;37m\]'
