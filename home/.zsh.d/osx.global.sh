# https://minus9d.hatenablog.com/entry/2015/01/14/234726
setopt interactivecomments

# anyenv
if [ -d $HOME/.anyenv ]; then
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"
fi

# Java
#export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
export JAVA_HOME=`/usr/libexec/java_home -v 11`

# vcs_info使うぞ
autoload -Uz add-zsh-hook
autoload -Uz vcs_info
autoload -Uz colors
colors

setopt prompt_subst

zstyle ':vcs_info:*'  formats '[%b]'

precmd () {
    vcs_info
}

# もうユーザー名とかいらんわ
# relative full path
PROMPT='%(!.%F{magenta}.%F{cyan})# %~ %(!.#.$)%f ${vcs_info_msg_0_}
'
# short path
# PS1="%(!.%F{magenta}.%F{cyan})# %. %(!.#.$)%f
# "

# github関係
alias g='cd $(ghq root)/$(ghq list | grep -v -e "^src" -v -e "^pkg" -v -e "^\d"| peco)'
alias ghopen='hub browse $(ghq list | peco | cut -d "/" -f 2,3)'
alias gcop='git branch -a --sort=-authordate | cut -b 3- | perl -pe '\''s#^remotes/origin/###'\'' | perl -nlE '\''say if !$c{$_}++'\'' | grep -v -- "->" | peco | xargs git switch'

# peco使うやつ
function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection

# lesspipe
export LESSOPEN="|/usr/local/bin/lesspipe.sh %s"

# thefuck
eval $(thefuck --alias)

# kuso alias
function yarn_upgrade_wrapper () {
    yarn upgrade "$1" --latest
}
alias imano_yarn_pkg="yarn outdated"
alias ageru_yarn_pkg=yarn_upgrade_wrapper
alias aaa="fuck"
alias aaaa="fuck"

# 便利
alias restart='exec $SHELL -l'
alias fbrew="HOMEBREW_NO_AUTO_UPDATE=1 brew install"
alias nbra='git switch -c'
alias mm='make'
alias get-new-yarn='curl -o- -L https://yarnpkg.com/install.sh | bash'
alias kirei_branch='git branch --merged|grep -v -E "\*|master"|xargs -n1 -I{} git branch -d {}'
alias korosu_closed_branch='join -v 1 <(git branch |grep -v -E "\*|master"|sed -e "s:\S*::g") <(git branch -r |grep -v master|sed -e "s:\S*origin/::g")|xargs -n1 -I{} git branch -D {}'
alias jcurl='curl -H "Content-Type: application/json"'


# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

# fastlane
export PATH="$HOME/.fastlane/bin:$PATH"

# gettext
export GIT_INTERNAL_GETTEXT_TEST_FALLBACKS=1

function github-releases()
{
    if [[ $# -lt 1 ]]; then
        echo $0 "repos-name" "[finish-condition(tag-name)]"
        return 1
    fi

    GITHUB_CLIENT_ID=""
    GITHUB_CLIENT_SECRET=""
    BASE_URL="https://api.github.com/repos/"$1"/releases?client_id="$GITHUB_CLIENT_ID"&client_secret="$GITHUB_CLIENT_SECRET

    FINISH_CONDITION=""
    if [[ $# -ge 2 ]]; then
        FINISH_CONDITION=$2
    fi

    PAGE=1

    RESULT=""

    while :; do
        REQ_URL=${BASE_URL}"&page="${PAGE}
        RESP=`curl -s ${REQ_URL}| jq -r ".[].html_url"`
        RESULT=$RESULT"\n"$RESP
        [[ "$FINISH_CONDITION" = "" ]] && break
        if [[ "$RESP" =~ "$FINISH_CONDITION" ]]; then
            break
        fi
        PAGE=`expr $PAGE + 1`
    done

    echo $RESULT
}

export PATH="$HOME/local/bin:$PATH"

function github-change-email()
{
    if [[ $# -lt 2 ]]; then
        echo $0 "old_email" "new_email"
        return 1
    fi

    git filter-branch -f --commit-filter '
        if [ "$GIT_COMMITTER_EMAIL" = '$1' ];
        then
                GIT_COMMITTER_EMAIL='$2';
                GIT_AUTHOR_EMAIL='$2';
                git commit-tree "$@";
        else
                git commit-tree "$@";
        fi' HEAD
}

alias okite-touch-bar='pkill "Touch Bar agent"'

function git-mv-name()
{
    if [[ $# -lt 2 ]]; then
        echo $0 "old_path" "new_path"
        return 1
    fi

    git mv $1 $1.tmp
    git mv $1.tmp $2
}

# 最新のMakeが使いたいのでbrewで入れてalias張る
alias make=$(which gmake 1> /dev/null; [ $? -eq 0 ] && which gmake || which make)
alias ls='lsd'

# Go
export GOENV_DISABLE_GOPATH=1
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH
alias gghq='GHQ_ROOT=${GOPATH}/src ghq'
alias gg='cd ${GOPATH}/$(ghq list| grep -E "^src"|peco)'

export PATH=${HOME}/.local/bin:${PATH}
export PATH=$PATH:${HOME}/.dotnet/tools

alias grep="ggrep --color"

export PATH=${PATH}:${HOME}/local
