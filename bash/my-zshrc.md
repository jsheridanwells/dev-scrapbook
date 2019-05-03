# My .zshrc

```bash
# last update 2 may 2019 -Jw

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/jeremywells/.oh-my-zsh"
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

plugins=(
  git
)

source $ZSH/oh-my-zsh.sh

# autojump
[[ -s /Users/jeremywells/.autojump/etc/profile.d/autojump.sh ]] && source /Users/jeremywells/.autojump/etc/profile.d/autojump.sh

# GENERAL

alias c='clear'
alias ca='clear &&'
alias la='ls -la'
alias c-="code ."

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

# Create standard .gitignore for .net core projects...
alias dn-gitignore="cp ~/git_templates/gitignore_templates/.gitignore-dotnetcore ./.gitignore"
#... and for flask projects
alias f-gitignore="cp ~/git_templates/gitignore_templates/.gitignore-flask ./.gitignore"
#... and python
alias py-gitignore="cp ~/git_templates/gitignore_templates/.gitignore-python ./.gitignore"

# list tree (requires brew install exa) (eg. lt 2 for tree w/ depth of 2)
alias l="exa --long --header --git"
alias li="exa --long --header --git --git-ignore"

# list files as tree
lt () {
    if [ -z "$1" ]
        then
            exa --long --tree --git --git-ignore --header 
        else
            exa --long --tree --git --git-ignore --header --level $1    
    fi  
}

```
