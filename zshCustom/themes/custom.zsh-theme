#!bin/zsh

THEME_BLOCK_PREFIX="["
THEME_BLOCK_SUFFIX="]"
THEME_PROMPT_SYMBOL="»"

###################################################
###						CWD 				 	###
###################################################

THEME_CWD_COLOR="004"
THEME_CWD_TRUNC="0"

function theme_cwd() {
	res=""
	res+="%{$FG[${THEME_CWD_COLOR}]%}"
	res+="%${THEME_CWD_TRUNC}~";
	res+="%{$reset_color%}"
	echo ${THEME_BLOCK_PREFIX}$res${THEME_BLOCK_SUFFIX}
}

###################################################
###				  Background jobs	 			###
###################################################

THEME_BGJOBS_SYMBOL=""
THEME_BGJOBS_COLOR="magenta"

function theme_bgjobs() {
	bgjobs=$(jobs | wc -l | awk '{print $1}' 2> /dev/null)
	res=""
	if [[ ! $bgjobs == "0" ]]; then
		res+="%{$FG[${THEME_BGJOBS_COLOR}]%}"
		res+="${THEME_BGJOBS_SYMBOL}${bgjobs}";
		res+="%{$reset_color%}"
	fi
	echo $res
}

###################################################
###				  	  HOST			 			###
###################################################

THEME_HOST_USER_SHOW_ALWAYS="false"
THEME_HOST_USER_COLOR="011"
THEME_HOST_USER_ROOT_COLOR="009"
THEME_HOST_MACHINE_SHOW_ALWAYS="false"
THEME_HOST_MACHINE_COLOR="011"

function theme_host() {
	USER_COLOR=$THEME_HOST_USER_COLOR
	[[ $USER == "root" ]] && USER_COLOR=$THEME_HOST_USER_ROOT_COLOR
	info=""
	if [[ $THEME_HOST_USER_SHOW_ALWAYS == true ]] || [[ $(whoami) != $USER ]]; then
		info+="%{$FG[$USER_COLOR]%}%n%{$reset_color%}"
	fi
	if [[ $THEME_HOST_MACHINE_SHOW_ALWAYS == true ]] || [[ -n $SSH_CONNECTION ]]; then
		[[ $info != "" ]] && info+="@"
		info+="%{$FG[${THEME_HOST_MACHINE_COLOR}]%}%m%{$reset_color%}"
	fi
	if [[ $info != "" ]]; then
		echo "${THEME_BLOCK_PREFIX}$info${THEME_BLOCK_SUFFIX}"
	fi
}

###################################################
###				  		GIT  					###
###################################################

THEME_GIT_DETACHED_HEAD_COLOR="009";
THEME_GIT_DETACHED_HEAD_ICON=;

THEME_GIT_CLEAN_COLOR="010";
THEME_GIT_CLEAN_ICON=✔;

THEME_GIT_DIRTY_COLOR="011";
THEME_GIT_DIRTY_ICON=✘;

THEME_GIT_UNPULLED_COLOR="009"
THEME_GIT_UNPULLED_ICON="⇣"

THEME_GIT_UNPUSHED_COLOR="004"
THEME_GIT_UNPUSHED_ICON="⇡"

THEME_GIT_THEME_UNPULLED="%{$FG[${THEME_GIT_UNPULLED_COLOR}]%}$THEME_GIT_UNPULLED_ICON%{$reset_color%}"
THEME_GIT_THEME_UNPUSHED="%{$FG[${THEME_GIT_UNPUSHED_COLOR}]%}$THEME_GIT_UNPUSHED_ICON%{$reset_color%}"

function theme_git_remote_status() {
	local git_local=$(command git rev-parse @ 2> /dev/null)
	local git_remote=$(command git rev-parse @{u} 2> /dev/null)
	local git_base=$(command git merge-base @ @{u} 2> /dev/null)
	if ! [[ ${git_remote} = "" ]]; then
		if [[ ${git_local} = ${git_remote} ]]; then
			echo ""
		elif [[ ${git_local} = ${git_base} ]]; then
			echo " $THEME_GIT_THEME_UNPULLED"
		elif [[ ${git_remote} = ${git_base} ]]; then
			echo " $THEME_GIT_THEME_UNPUSHED"
		else
			echo " $THEME_GIT_THEME_UNPULLED $THEME_GIT_THEME_UNPUSHED"
		fi
	fi
}

function theme_git_is_git_repo() {
	git rev-parse --is-inside-work-tree &>/dev/null
  return $status
}

function theme_git_get_repo_name() {
	echo $(basename `git rev-parse --show-toplevel` | tr '[:lower:]' '[:upper:]')
}

function theme_git() {
	res=""
	if theme_git_is_git_repo; then
		local git_ps1="$(theme_git_get_repo_name) - $(__git_ps1 '%s')"
		local remote="$(theme_git_remote_status)"
		if [[ $(git rev-parse --abbrev-ref HEAD 2> /dev/null) == 'HEAD' ]]; then
			git_ps1="%{$FG[${THEME_GIT_DETACHED_HEAD_COLOR}]%}$THEME_GIT_DETACHED_HEAD_ICON $git_ps1%{$reset_color%}"
		else
			if [[ -z "$(git status --porcelain --ignore-submodules)" ]]; then
				git_ps1="%{$FG[${THEME_GIT_CLEAN_COLOR}]%}$THEME_GIT_CLEAN_ICON $git_ps1%{$reset_color%}"
			else
				git_ps1="%{$FG[${THEME_GIT_DIRTY_COLOR}]%}$THEME_GIT_DIRTY_ICON $git_ps1%{$reset_color%}"
			fi
		fi
		res=${git_ps1}${remote}
	fi
	echo $res
}

setopt prompt_subst
autoload -Uz promptinit && promptinit
autoload -Uz colors && colors

_newline=$'\n'
_lineup=$'\e[1A'
_linedown=$'\e[1B'

PROMPT=$'$(theme_host)$(theme_cwd)${_newline}${THEME_PROMPT_SYMBOL}  '
RPROMPT=$'%{${_lineup}%}$(theme_git)%{${_linedown}%}'
