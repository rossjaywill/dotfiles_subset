function compiler_env_clang() {
  export CC=clang
  export CXX=clang++
}

function compiler_env_gcc() {
  export CC=gcc
  export CXX=g++
}

function git_cc() {
  local branch=""
  if [[ $# -gt 0 ]]; then
    branch=$1
  else
    echo "No branch specified, getting HEAD of remote to clean checkout"
    branch=`git remote show origin | awk '/HEAD/ {print $NF}'`
  fi
  git checkout ${branch}
  git fetch
  git pull
}

function gdf() {
  preview="git diff $@ --color=always -- {-1}"
  git diff $@ --name-only | fzf -m --ansi --preview $preview
}

function tmup() {
    echo -n "Updating to latest tmux environment...";
    export IFS=",";
    for line in $(tmux showenv -t $(tmux display -p "#S") | tr "\n" ",");
    do
        if [[ $line == -* ]]; then
            unset $(echo $line | cut -c2-);
        else
            export $line;
        fi;
    done;
    unset IFS;
    echo "Done"
}

function g2v() {
  awk -F ":" '{print $1}' | xargs nvim
}

function viM() {
  vi $(git status | grep modified | awk '{print $2}')
}

function show_bin() {
  if [[ $# -gt 0  ]]; then
    which $1 | xargs ls -hltF
  else
    echo "Cannot show bin with no args, please specify which bin"
  fi
}

function startup_ssh_agent() {
  if [ -z "$SSH_AUTH_SOCK" ]; then
    # Check for a currently running instance of the agent
    RUNNING_AGENT="`ps -ax | grep 'ssh-agent -s' | grep -v grep | wc -l | tr -d '[:space:]'`"
    if [ "$RUNNING_AGENT" = "0" ]; then
        ssh-agent -s &> ~/.ssh/ssh-agent
    fi
    eval `ssh-agent` > /dev/null && ssh-add ~/.ssh/id_rsa
  fi
}

function fw {
  result=`rg --ignore-case --color=always --line-number --no-heading "$@" |
    fzf --ansi \
        --color 'hl:-1:underline,hl+:-1:underline:reverse' \
        --delimiter ':' \
        --preview "bat --color=always {1} --theme=TwoDark --highlight-line {2}" \
        --preview-window 'right,60%,border-bottom,+{2}+3/3,~3'`
  file="${result%%:*}"
  linenumber=`echo "${result}" | cut -d: -f2`
  if [ ! -z "$file" ]; then
          $EDITOR +"${linenumber}" "$file"
  fi
}

alias l='eza'
alias ll='eza -algF -s modified -r --icons --color=auto'
alias lf='eza -lgfF -s modified -r --icons --color=auto'
alias lfa='eza -algfF -s modified -r --icons --color=auto'
alias lt='eza -T --icons --color=auto'
alias bat='bat --theme=TwoDark'
alias cat='bat -p'
alias less='less -R'
alias dmesg='dmesg -H -T --color=always'

alias vi='nvim'
alias nf='fd --type f --exclude .git --exclude build --exclude build.clang | fzf-tmux | xargs nvim'
alias vimdiff='nvim -d'

alias rg='rg --hidden --no-heading --color=auto'
alias rgnt="rg -g '!*test*' -g '!*tst*'"
alias ns='sudo netstat -tuplan'
alias pa='ps auxww'
# alias info='pinfo'
alias info='info --vi-keys'

alias gs='git status'
alias gd='git diff'
alias gl='git log'
alias glg='git log --graph --abbrev-commit --decorate --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)" --all'
alias gln='git log --name-status'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gph='git push -u'
alias gpl='git pull'
alias gr='git remote -v'
alias gam="git status | grep modified | awk '{print \$2}' | xargs git add" # add all modified
alias gsc="git diff-tree --no-commit-id --name-only -r"
alias gfp="git pull"
alias gg="git grep --break -p "
alias gC='git clean -fdx -e "build*" -e ".cache" -e ".clang-tidy" -e "compile_commands.json"'

alias dfgit='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dfg='dfgit'
alias dfd='dfgit diff'
alias dfs='dfgit status'
alias dfl='dfgit log'
alias dflg='dfgit log --graph --abbrev-commit --decorate --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)" --all'
alias dfa='dfgit add'
alias dfc='dfgit commit'
alias dfco='dfgit checkout'
alias dfph='dfgit push -u'
alias dfp='dfgit pull'
alias dfr='dfgit remote -v'
alias dfam="dfs | grep modified | awk '{print \$2}' | xargs git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME add" # add all modified
alias dfsc="dfgit diff-tree --no-commit-id --name-only -r"
alias dgg="dfgit grep --break -p "

alias update_cargo='cargo install cargo-update && cargo install-update -a'

alias tmux_agent="eval `ssh-agent` && ssh-add && tmux"

alias dunstify='dbus-launch dunstify'
alias notify-send='dbus-launch notify-send'

# Arch
function pacclean() {
  sudo pacman -Rnsu $(pacman -Qqdt)
}

alias pacup='sudo pacman -Syu && yay -Syu'

alias ..='cd ..'

# alias tmux='eval "$(ssh-agent -s)" && ssh-add && tmux -2'

function update_env() {
  update_cargo &
  zinit self-update &
  zinit update --all &
  sudo pacman -Syu &
}

# FZF
export FZF_DEFAULT_COMMAND='rg --hidden -l ""'
export FZF_DEFAULT_OPTS='--height 40% '
FZF_DEFAULT_OPT='--preview="bat --color=always --style=numbers --line-range=:500 {}" '
FZF_DEFAULT_OPTS+='--pointer="➤ " '
FZF_DEFAULT_OPTS+='--prompt="➤ " '
FZF_DEFAULT_OPTS+='--bind="pgup:preview-up,pgdn:preview-down" '
FZF_DEFAULT_OPTS+='--border --margin=1 --padding=2% --info=inline '
# FZF_DEFAULT_OPTS+='--bind="pgup:preview-up,pgdn:preview-down,ctrl-j:down,ctrl-k:up"'

# rose-pine moon
FZF_DEFAULT_OPTS+="--color=fg:#908caa,bg:#232136,hl:#ea9a97 "
FZF_DEFAULT_OPTS+="--color=fg+:#e0def4,bg+:#393552,hl+:#ea9a97 "
FZF_DEFAULT_OPTS+="--color=border:#44415a,header:#3e8fb0,gutter:#232136 "
FZF_DEFAULT_OPTS+="--color=spinner:#f6c177,info:#9ccfd8 "
FZF_DEFAULT_OPTS+="--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa "

FZF_ALT_C_OPTS='--preview="" --reverse'
FZF_CTRL_T_OPTS='--preview="" --reverse'
FZF_CTRL_R_OPTS='--preview="" --reverse'

# Environment Variables
export BAT_THEME="Solarized (dark)"

# export TERM='screen-256color'
export EDITOR='nvim'
export PSQL_EDITOR='nvim'
export GIT_EDITOR='nvim'
export TERMINAL='kitty'

export PLUGS='~/.local/share/nvim/lazy/'

# export PG_CLI='pgcli'
# export EXTRA_CLI_ARGS="--less-chatty --no-warn"

export SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock
startup_ssh_agent

export PATH=$PATH:$HOME/.local/bin:$HOME/.cargo/bin:/usr/local/bat:$HOME/.local/share/nvim/lazy:$HOME/.local/share/nvim/mason/bin:$HOME/.config/emacs/bin
export PLUGS='~/.local/share/nvim/lazy/'

compiler_env_clang
