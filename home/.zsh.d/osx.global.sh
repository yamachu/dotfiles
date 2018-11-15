# anyenv
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"

# Java
export JAVA_HOME=`/usr/libexec/java_home -v 10`

# Rust
export PATH="$HOME/.cargo/bin:${PATH}"

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
alias g='cd $(ghq root)/$(ghq list | peco)'
alias gh='hub browse $(ghq list | peco | cut -d "/" -f 2,3)'
alias gcop='git branch -a --sort=-authordate | cut -b 3- | perl -pe '\''s#^remotes/origin/###'\'' | perl -nlE '\''say if !$c{$_}++'\'' | grep -v -- "->" | peco | xargs git checkout'

# peco使うやつ
function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection

# lesspipe
export LESSOPEN="|/usr/local/bin/lesspipe.sh %s" LESS_ADVANCED_PREPROCESSOR=1

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
alias nbra='git checkout -b'
alias mm='make'
alias get-new-yarn='curl -o- -L https://yarnpkg.com/install.sh | bash'
alias kirei_branch='git branch --merged|grep -v -E "\*|master"|xargs -n1 -I{} git branch -d {}'
alias korosu_closed_branch='join -v 1 <(git branch |grep -v -E "\*|master"|sed -e "s:\s*::g") <(git branch -r |grep -v master|sed -e "s:\s*origin/::g")|xargs -n1 -I{} git branch -D {}'
alias jcurl='curl -H "Content-Type: application/json"'


# added by travis gem
[ -f /Users/yk-yamada/.travis/travis.sh ] && source /Users/yk-yamada/.travis/travis.sh

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
