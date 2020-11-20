# last update 17 Apr 2020 -Jw

# Path to your oh-my-zsh installation.
export ZSH="/Users/jeremywells/.oh-my-zsh"
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

plugins=(
  git node bundler osx rake ruby
)

source $ZSH/oh-my-zsh.sh

# autojump
[[ -s /Users/jeremywells/.autojump/etc/profile.d/autojump.sh ]] && source /Users/jeremywells/.autojump/etc/profile.d/autojump.sh

# GENERAL

alias c='clear'
alias ca='clear &&'
alias la='ls -la'
alias c-="code ."
alias rid="rider"
alias ws="webstorm"
alias h="history"
alias hg="history grep | "

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

# NPM ALIASES
alias ninit="npm init"
alias nr="npm run"
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
alias vact=". venv/bin/activate"

#DOTNET ALIASES
alias dn="dotnet"
alias dna="dotnet add"
alias dnap="dotnet add package"
alias dnres="dotnet restore"
alias dnr="dotnet run"
alias dnwr="dotnet watch run"
alias dnb="dotnet build"

#NODE ALIASES
alias ns="npm run start"

# RUBY BUNDLER &/| JEKYLL
alias be="bundle exec"
alias js="bundle exec jekyll serve"
alias jst="JEKYLL_ENV=test bundle exec jekyll serve"
alias jsp="JEKYLL_ENV=production bundle exec jekyll serve"

# Create standard .gitignore for .net core projects...
alias dn-gitignore="cp ~/git_templates/gitignore_templates/.gitignore-dotnetcore ./.gitignore"
#... and for flask projects
alias f-gitignore="cp ~/git_templates/gitignore_templates/.gitignore-flask ./.gitignore"
#... and python
alias py-gitignore="cp ~/git_templates/gitignore_templates/.gitignore-python ./.gitignore"

# list tree (requires brew install exa) (eg. lt 2 for tree w/ depth of 2)
# alias l="exa --long --header --git"
# alias li="exa --long --header --git --git-ignore"

alias ls="lsd"
alias l="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias lt="ls --tree"

# list files as tree
# lt () {
#     if [ -z "$1" ]
#         then
#             exa --long --tree --git --git-ignore --header
#         else
#             exa --long --tree --git --git-ignore --header --level $1
#     fi
# }

# GETTING AROUND
alias workspace="pushd ~/workspace && clear && ls"
alias tut="pushd ~/workspace/tutorials && clear && ls"
alias exp="pushd ~/workspace/experiments && clear && ls"
alias proj="pushd ~/workspace/projects && clear && ls"


# rbenv
eval export PATH="/Users/jeremywells/.rbenv/shims:${PATH}"
export RBENV_SHELL=zsh
source '/usr/local/Cellar/rbenv/1.1.2/libexec/../completions/rbenv.zsh'
command rbenv rehash 2>/dev/null
rbenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "$(rbenv "sh-$command" "$@")";;
  *)
    command rbenv "$command" "$@";;
  esac
}

# NVM
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# DOCKER

# Make column format available when listing images
export COL="\nID\t{{.ID}}\nIMAGE\t{{.Image}}\nCOMMAND\t{{.Command}}\nCREATED\t{{.RunningFor}}\nSTATUS\t{{.Status}}\nPORTS\t{{.Ports}}\nNAMES\t{{.Names}}\n"

# POSTGRES
PATH=/Library/PostgreSQL/12/bin:$PATH
