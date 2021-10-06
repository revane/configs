function setps1 {
    # Things that change the prompt colour:
    #   STY - detects "screen"
    #   ANDROID_PRODUCT_OUT - Android's build/envsetup.sh
    #   BLACK_CORAL_ENVSETUP_MAGIC_COOKIE - Black Coral's build/envsetup.sh
    # Python version is always prefixed.
    PROMPT_CORE="\W$ "
    PROMPT_PREFIX=$(tmp=${BLACK_CORAL_CONANSETUP_MAGIC_COOKIE+B}${ANDROID_PRODUCT_OUT+A}${STY+S}; echo ${tmp}${tmp:+-})
    PY_PREFIX=$(python --version 2>&1 | cut -d ' ' -f 2 | cut -d '.' -f 1)
    printf "\e];${TABNAME:-bash}\a"
    if [[ -z ${TERM+x} ]]; then
        export PS1=${PY_PREFIX}-${PROMPT_CORE}
    else
        color=3
        if [[ -n ${PROMPT_PREFIX:+x} ]]; then
            color=2
        fi
        export PS1="\[$(tput setaf ${color})\]${PY_PREFIX}-${PROMPT_PREFIX}${PROMPT_CORE}\[$(tput sgr0)\]"
    fi
}
function tabname {
    export TABNAME=$@
}

export CLICOLOR=1
export PROMPT_COMMAND="setps1"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_45.jdk/Contents/Home
export ANDROID_NDK=${HOME}/Library/Android/ndk
export ANDROID_SDK=${HOME}/Library/Android/sdk
export ANDROID_HOME=${HOME}/Library/Android/sdk
export STAY_OFF_MY_LAWN=1
export CONAN_COLOR_DARK=1
export NODE_PATH=/usr/local/lib/node_modules
export KOS_HOME=${HOME}/kos

export ANT_HOME=/Users/edwin.vane/Library/apache-ant-1.9.6
export PATH=/Users/edwin.vane/bin:/usr/local/opt/gnu-sed/libexec/gnubin:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/22.0.1:$ANT_HOME/bin:$PATH
export PATH=$PATH:$(gem environment gempath | awk 'BEGIN { FS = ":"; OFS=":" }; { for (i = 1; i <= NF; i++) { $i=$i"/bin"} print $0 }')
alias ls='ls -G'
alias grep='/usr/local/bin/ggrep'
alias :e='vim'
alias mp='mvim --remote-silent'
alias agl='ag --no-group --ignore-dir test'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
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
function ma {
    hdiutil attach ~/dev/android_env.sparseimage -mountpoint /Volumes/android
#    export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_71.jdk/Contents/Home
}
function ua { hdiutil detach /Volumes/android; }

if [[ `which pyenv` ]]; then
    eval "$(pyenv init -)"
fi

/usr/bin/keychain ${HOME}/.ssh/id_rsa
source ${HOME}/.keychain/${HOSTNAME}-sh
