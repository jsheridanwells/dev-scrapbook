# Last update 2024-11-08 -@jsheridanwells
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="/home/jsheridanwells/.oh-my-zsh"
export PATH=$PATH:/home/jsheridanwells/.local/bin
eval "$(oh-my-posh init zsh --config /home/jsheridanwells/oh-my-posh-extras/stelbent.minimal.omp.json)"
# oh-my-zsh theme
ZSH_THEME="passion"
# ZSH_THEME="powerlevel10k/powerlevel10k"
# ZSH_THEME="arrow"
# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="false"
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
alias h="history"
alias hg="history grep | "
alias cv="command -v"
alias vi="vim"
alias v="vim"
alias omp="oh-my-posh"


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

# 11ty ALIASES
alias ety="npx @11ty/eleventy"

# PYTHON ALIASES
alias py="python3"
alias python="python3"
alias vact=". venv/bin/activate"

#DOTNET ALIASES, ETC
alias dn="dotnet"
alias dna="dotnet add"
alias dnap="dotnet add package"
alias dnres="dotnet restore"
alias dnr="dotnet run"
alias dnwr="dotnet watch run"
alias dnb="dotnet build"
export PATH="$HOME/.dotnet/tools:$PATH"

# RUBY BUNDLER &/| JEKYLL
# Install Ruby Gems to ~/gems' 
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"
alias be="bundle exec"
alias js="bundle exec jekyll serve --livereload"
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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Load Angular CLI autocompletion.
source <(ng completion script)
