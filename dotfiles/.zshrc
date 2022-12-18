# Last update 2021-02-03 -@jsheridanwells

# Path to your oh-my-zsh installation.
export ZSH="/home/jsheridanwells/.oh-my-zsh"

# oh-my-zsh theme
ZSH_THEME="powerlevel10k/powerlevel10k"
# ZSH_THEME="arrow"
# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"
# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"
# oh-my-zsh plugins
plugins=(git)
source $ZSH/oh-my-zsh.sh

# MY STUFF
# General Aliases
alias c="clear"
alias l="ls -la"
alias wr="cd /mnt/c/Users/jsheridanwells"
alias ws="webstorm . </dev/null &>/dev/null &"
alias h="history"
alias hg="history grep | "
alias cv="command -v"

# GETTING AROUND
alias repo="pushd ~/workspace && clear && ls"
alias workspace="pushd ~/workspace && clear && ls"
alias tut="pushd ~/workspace/tutorials && clear && ls"
alias exp="pushd ~/workspace/experiments && clear && ls"
alias proj="pushd ~/workspace/projects && clear && ls"
alias temp="pushd ~/workspace/temp && clear && ls"

# GIT ALIASES
alias g='git'
alias gs='git status'
alias ga='git add'
alias gcmsg='git commit -m'
alias gca='git commit --amend'
alias gcne='git commit --amend --no-edit'
alias gpo='git push origin'
alias gp='git pull'
alias gb='git branch'
alias gbd='git branch -d'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'
alias glog='git log --oneline --decorate --graph --all'
alias grao='git remote add origin'
alias gpom='git push origin master'

# NODE/NPM ALIASES
alias ninit="npm init"
alias nr="npm run"
alias ns="npm run start"
alias nrs="npm run serve"
alias nrws="npm run webservice"
alias nt="npm test"
alias nd="npm run dev"
alias nb="npm run build"
alias ni="npm install"
alias nid="npm install --save-dev"
alias nig="npm install -g"
alias nun="npm uninstall --save"

# PYTHON ALIASES
alias py="python3"
alias python="python3"
alias vact=". venv/bin/activate"

#DOTNET ALIASES
alias dn="dotnet"
alias dna="dotnet add"
alias dnap="dotnet add package"
alias dnres="dotnet restore"
alias dnr="dotnet run"
alias dnwr="dotnet watch run"
alias dnb="dotnet build"

# RUBY BUNDLER &/| JEKYLL
alias be="bundle exec"
alias js="bundle exec jekyll serve"
alias jst="JEKYLL_ENV=test bundle exec jekyll serve"
alias jsp="JEKYLL_ENV=production bundle exec jekyll serve"

## Make life easier
### PATH formatting
### see: https://www.cyberciti.biz/faq/howto-print-path-variable/
function path(){
  echo $PATH | tr ":" "\n" | nl
}

## Tool startup

autoload -U compinit && compinit -u
### X server
export DISPLAY=${DISPLAY:-$(grep -Po '(?<=nameserver ).*' /etc/resolv.conf):0}
export LIBGL_ALWAYS_INDIRECT=1

### nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
### use .nvmrc if found
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

### rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

### docker
### Make column format available when listing images
export COL="\nID\t{{.ID}}\nIMAGE\t{{.Image}}\nCOMMAND\t{{.Command}}\nCREATED\t{{.RunningFor}}\nSTATUS\t{{.Status}}\nPORTS\t{{.Ports}}\nNAMES\t{{.Names}}\n"

### autojump
[[ -s /home/jsheridanwells/.autojump/etc/profile.d/autojump.sh  ]] && source /home/jsheridanwells/.autojump/etc/profile.d/autojump.sh

autoload -U compinit && compinit -u

## Temp abbreviations for active projects
alias bd="cd ~/workspace/projects/BeautifulDay && vi ."
