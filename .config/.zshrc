########## Prompt ##########

# git_prompt() {
#     local branch="$(git symbolic-ref HEAD 2> /dev/null | cut -d'/' -f3-)"
#     local branch_truncated="${branch:0:30}"
#     if (( ${#branch} > ${#branch_truncated} )); then
#         branch="${branch_truncated}..."
#     fi
#
#     [ -n "${branch}" ] && echo "  ${branch}"
# }

# setopt PROMPT_SUBST
# PROMPT='%B%F{blue}󰣇%f%b  %B%F{magenta}%n%f%b %B%F{red}%~%f%b%B%F{yellow}$(git_prompt)%f%b %(?.%B%F{green}✓.%F{red}✕)%f%b %B%F{green}%f%b '

export EDITOR=nvim;
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"


if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.cargo/bin:" ] ;
  then PATH="$HOME/.cargo/bin:$PATH"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.config/zsh/zhistory
HISTSIZE=5000
SAVEHIST=5000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
autoload -Uz add-zsh-hook
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case insensitive tab completion
compinit -d ~/.config/zsh/zcompdump-$ZSH_VERSION
_comp_options+=(globdots)
# End of lines added by compinstall

setopt autocd              # change directory just by typing its name
setopt promptsubst         # enable command substitution in prompt
setopt MENU_COMPLETE       # Automatically highlight first element of completion menu
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt COMPLETE_IN_WORD    # Complete from both ends of a word.

# Waiting dots

expand-or-complete-with-dots() {
  echo -n "\e[31m…\e[0m"
  zle expand-or-complete
  zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots

# Plugins
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
source ~/.config/zsh/web-search.plugin.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

### CHANGE TITLE OF TERMINALS

function xterm_title_precmd () {
	print -Pn -- '\e]2;%n@%m %~\a'
	[[ "$TERM" == 'screen'* ]] && print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
}

function xterm_title_preexec () {
	print -Pn -- '\e]2;%n@%m %~ %# ' && print -n -- "${(q)1}\a"
	[[ "$TERM" == 'screen'* ]] && { print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# ' && print -n -- "${(q)1}\e\\"; }
}

if [[ "$TERM" == (Eterm*|alacritty*|termite*|gnome*|konsole*|kterm*|putty*|rxvt*|screen*|tmux*|xterm*|kitty*|) ]]; then
	add-zsh-hook -Uz precmd xterm_title_precmd
	add-zsh-hook -Uz preexec xterm_title_preexec
fi

#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

alias ls='exa --icons -l'
alias ll='ls -a'
alias df='df -h'
alias v=nvim
alias vi=nvim
alias g=git
alias gp="git push"
alias lg=lazygit
alias fucking='sudo'
alias parsyu='paru -Syu --noconfirm'
alias workspace="cd /mnt/sda2/aENOKH/WorkSpace"
alias ns="npm start"
alias cat="bat --theme base16-256"
alias c=clear
alias tks="tmux kill-session"

eval "$(starship init zsh)"

~/.config/zsh/fetch.sh
