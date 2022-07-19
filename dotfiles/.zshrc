export EDITOR=vim

export PATH=$PATH:$HOME/sdks/flutter/bin

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X';

export HISTORY_IGNORE="(history|ls|l|la|ll|lla|lsa|cd|cd *|pwd|exit|* --help|man *|cls|clear)"

# disable oh my zsh auto updates
export DISABLE_AUTO_UPDATE="true"

export ZSH_CUSTOM=${HOME}/.config/zsh/zshCustom

export STARSHIP_CONFIG=~/.starship

export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable

export NVM_AUTO_USE=true

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/z-a-rust \
    zdharma-continuum/z-a-as-monitor \
    zdharma-continuum/z-a-patch-dl \
    zdharma-continuum/z-a-bin-gem-node

### End of Zinit's installer chunk

zinit light mroth/evalcache

_evalcache dircolors -b
autoload -U colors && colors

# theme
setopt promptsubst
zinit ice from"gh-r" as"command" atload'!_evalcache starship init zsh'
zinit light starship/starship

zinit for \
    light-mode ${ZSH_CUSTOM}/plugins/aliases \
    light-mode ${ZSH_CUSTOM}/plugins/functions \
    light-mode OMZL::history.zsh

zinit wait lucid for \
  ${ZSH_CUSTOM}/plugins/bindkey \
  ${ZSH_CUSTOM}/plugins/completions \
  ${ZSH_CUSTOM}/plugins/opts \
  OMZL::completion.zsh \
  OMZL::compfix.zsh \
  OMZL::spectrum.zsh \
  OMZP::colored-man-pages \
  as"completion" \
    OMZP::docker/_docker \
  as"completion" \
    OMZP::docker-compose/_docker-compose \
  blockf \
    as"completion" \
      zsh-users/zsh-completions \
  lukechilds/zsh-nvm \
  OMZP::gradle \
  atload"unalias mvn! mvnag mvnboot mvnc mvncd mvnce mvnci mvncie mvncini mvncist mvncisto mvncom mvncp mvnct mvncv mvncvst mvnd mvndocs mvndt mvne mvnfmt mvnjetty mvnp mvnqdev mvns mvnsrc mvnt mvntc mvntc7 mvn-updates" \
    OMZP::mvn \
  zsh-users/zsh-history-substring-search \
  zdharma-continuum/history-search-multi-word \
  caarlos0/zsh-open-pr \
  voronkovich/gitignore.plugin.zsh \
  zpm-zsh/clipboard \
  mattmc3/zsh-safe-rm \
  as"program" pick"bin/git-dsf" \
    zdharma-continuum/zsh-diff-so-fancy \
  ${ZSH_CUSTOM}/plugins/colors \
  ptavares/zsh-direnv

# this must be the last loaded
zinit wait lucid for \
  atinit"ZINIT[COMPINIT_OPTS]='-i' zpcompinit; zpcdreplay" \
    zdharma-continuum/fast-syntax-highlighting

# load zmv
autoload -U add-zsh-hook zmv
