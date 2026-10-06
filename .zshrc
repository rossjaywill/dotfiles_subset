plugins=(
    git
    zsh-autosuggestions
    sudo
)

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

if [ -e ${HOME}/.local/share/zinit/zinit.git/zinit.zsh ]; then
    source "$HOME/.local/share/zinit/zinit.git/zinit.zsh";
fi

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust
### End of Zinit's installer chunk

# Load a few important annexes, without Turbo
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
# zinit light unixorn/fzf-zsh-plugins
zinit light laggardkernel/zsh-tmux
zinit light zdharma-continuum/fast-syntax-highlighting

setopt PROMPT_SUBST
git_prompt_info() {
    local branch
    branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) || branch=$(git rev-parse --short HEAD 2>/dev/null) || return 0
    print -r -- "($branch)"
}
PROMPT="%F{magenta}%~ %F{green}\$(git_prompt_info)%f%F{green}
→ %f"
RPROMPT=''

bindkey -M vicmd v edit-command-line
bindkey "^V" edit-command-line

# unbind C-j C-k, so they can be read by fzf
# bindkey -r '^J'
# bindkey -r '^K'

fast-theme -q XDG:catppucin-frappe 2>/dev/null
set -o vi

# tmux hist preservation
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000

setopt inc_append_history
setopt inc_append_history_time
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_find_no_dups
setopt hist_save_no_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt extended_history
setopt share_history
unsetopt hist_verify

setopt autocd
setopt nobeep
setopt numeric_glob_sort

# if [ -e ${HOME}/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel9k.zsh-theme ]; then
#     source ${HOME}/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel9k.zsh-theme;
# fi

# oh-my-zsh
# fpath+="${ZSH_CUSTOM:-${ZSH}/custom}/plugins/zsh-completions/src"

zmodload zsh/computil
autoload -Uz compinit && compinit
autoload -z edit-command-line
zle -N edit-command-line

autoload bashcompinit
bashcompinit

# [[ -f $ZSH/oh-my-zsh.sh ]] && source $ZSH/oh-my-zsh.sh
[[ -f ~/.profile ]] && emulate sh -c 'source ~/.profile'
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh


if [ -f $ECN_ROOT/source/ecn/source/util/bash_completions.sh ]; then
  . $ECN_ROOT/source/ecn/source/util/bash_completions.sh || true
fi
