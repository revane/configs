case $- in
    *i*) ;;
      *) return;;
esac

function setps1 {
    PROMPT_CORE="\W$ "
    ACTIVATE_PREFIX=${PW_PROJECT_ROOT+$(basename $(realpath ${PW_PROJECT_ROOT}))}
    printf "\e];${TABNAME:-bash}\a"
    if [[ -z ${TERM+x} ]]; then
        export PS1=${ACTIVATE_PREFIX}|${PROMPT_CORE}
    else
      if [ "$IS_CT" = true ]; then
        # brown
        color=12
      else
        # green
        color=2
      fi
      export PS1="\[$(tput setaf ${color})\]${ACTIVATE_PREFIX}${ACTIVATE_PREFIX:+|}${PROMPT_CORE}\[$(tput sgr0)\]"
    fi
}
function tabname {
    export TABNAME=$@
}

export IS_CT=$([[ `uname -n` =~ .*.c.googlers.com ]] && echo true)
export CLICOLOR=1
export PROMPT_COMMAND="setps1"
export JAVA_HOME=/usr/lib/jvm/java-1.17.0-openjdk-amd64
export STAY_OFF_MY_LAWN=1
export CONAN_COLOR_DARK=1
export NODE_PATH=/usr/local/lib/node_modules
export KOS_HOME=${HOME}/kos
export GN_EDITOR=vim
export AUTH_SSH_CERTIFICATION=false
export HGEDITOR=vim

export ANT_HOME=/Users/edwin.vane/Library/apache-ant-1.9.6
export PATH=/usr/local/google/home/revane/bin:/Users/edwin.vane/bin:/usr/local/opt/gnu-sed/libexec/gnubin:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/22.0.1:$ANT_HOME/bin:$PATH
export PATH=$PATH:$(gem environment gempath | awk 'BEGIN { FS = ":"; OFS=":" }; { for (i = 1; i <= NF; i++) { $i=$i"/bin"} print $0 }')
alias droiddb='m SOONG_GEN_COMPDB=1 SOONG_LINK_COMPDB_TO=$ANDROID_BUILD_TOP nothing'
alias ls='ls -G --color=auto'
alias :e='vim'
alias mp='mvim --remote-silent'
alias agl='ag --no-group --ignore-dir test'
alias gcert-fix='gcert --glogin_connect_timeout=60s --glogin_request_timeout=60s'
alias acid='/google/bin/releases/mobile-devx-platform/acid/acid'

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[ -f /usr/share/bash-completion/completions/git ] && . /usr/share/bash-completion/completions/git
[ -f ~/.git-completion.bash ] && . ~/.git-completion.bash
[ -f ~/.ninja-complete ] && . ~/.ninja-complete

CFG_HOME=${HOME}/dev/configs
cfg() { git --git-dir="${CFG_HOME}/.git/" --work-tree="${HOME}" "$@" ; }

function grt {
  git rev-parse && cd $(git rev-parse --show-toplevel)
  if [[ $# -gt 0 ]]; then
    cd $1
  fi
}

function stop-mux {
  ssh -O stop -S "${HOME}/.ssh/master-revane@${1}:22" ${1}
}

function glog {
  git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit "$@"
}

function glogb {
  git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --branches "$@"
}

if [[ `which pyenv` ]]; then
    eval "$(pyenv init -)"
fi

#/usr/bin/keychain ${HOME}/.ssh/id_rsa
#source ${HOME}/.keychain/${HOSTNAME}-sh

if [[ -n $ACTIVATE ]]; then
  source $ACTIVATE
fi

if [ -f "${HOME}/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

export "ANDROID_HOME=$HOME/Android/Sdk"
export "ANDROID_NDK_HOME=$ANDROID_HOME/ndk/25.1.8937393"
