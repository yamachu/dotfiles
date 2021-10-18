# base: https://gist.github.com/informationsea/5401321

# ========= History ============
HISTFILE=${HOME}/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_dups ## ignore duplicated history
setopt extended_history
setopt share_history
setopt hist_ignore_space
bindkey -e

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# ========== Completion ===========
zstyle :compinstall filename '$HOME/.zshrc'

if [ -e ~/.zsh.d/completion ]; then
    fpath=(~/.zsh.d/completion $fpath)
fi

autoload -Uz compinit
compinit -i
# http://journal.mycom.co.jp/column/zsh/009/index.html
zstyle ':completion:*' list-colors ''  # color completion
zstyle ':completion:*' format '%BCompleting %d%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' menu select=1

setopt nolistbeep     # do not beep on completion
setopt extendedglob

# ========= Covinient Functions ======
setopt auto_cd           # auto pushd
setopt correct           # correct your mis-spelled command
setopt list_packed       # pack 'ls'
setopt no_flow_control   # disable flow control
setopt noautoremoveslash # disable auto remove directory's slash
autoload zed

# http://www.clear-code.com/blog/2011/9/5.html
WORDCHARS=${WORDCHARS:s,/,,} # "/" is not word char

# ========== Alias ======
alias grep='grep --color=auto'
alias nkf='nkf -w'
alias la="ls -A" # -G only normal ls
alias ll="ls -lh" # -G only normal ls
alias lla="ls -lhA" # -G only normal ls
alias l='ls -F' # -G only normal ls, and -C
alias ls="ls" # -G only normal ls


# ========== Custom Env ======
case ${OSTYPE} in
    darwin*)
        [ -f ${HOME}/.zsh.d/osx.global.sh ] && source ${HOME}/.zsh.d/osx.global.sh
        [ -f ${HOME}/.zsh.d/osx.private.sh ] && source ${HOME}/.zsh.d/osx.private.sh
        ;;
    linux*)
        source ${HOME}/.zsh.d/linux.global.sh
        source ${HOME}/.zsh.d/linux.private.sh
        ;;
esac

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# added by travis gem
[ -f /Users/yamachu/.travis/travis.sh ] && source /Users/yamachu/.travis/travis.sh
