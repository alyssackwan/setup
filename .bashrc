#!/bin/bash


[ -z "$PS1" ] && return
[[ $- != *i* ]] && return

if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi


CURRENT_PYTHON_VERSION='3.7.1'
CURRENT_PYTHON_VERSION_REGEX='3\.7\.1'
CURRENT_NODE_VERSION='v11.14.0'
CURRENT_NODE_VERSION_REGEX='v11\.14\.0'


if [ "$(uname)" == "Darwin" ]; then

    # pkgconfig
    export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/opt/X11/lib/pkgconfig:${PKG_CONFIG_PATH}"

    # Homebrew
    export HOMEBREW="${HOME}/opt/homebrew"
    export HOMEBREW_CACHE="${HOME}/Library/Caches/Homebrew"
    export PATH="$HOMEBREW/bin:$HOMEBREW/sbin:$PATH"
    export PKG_CONFIG_PATH="$HOMEBREW/lib/pkgconfig:$PKG_CONFIG_PATH"
    export CPATH="$CPATH:$HOMEBREW/include"
    export HOMEBREW_CASK_OPTS="--appdir=${HOME}/Applications"

    # coreutils
    [ x"" == x"$(brew ls --versions coreutils)" ] && brew install coreutils
    # coreutils - man
    export "MANPATH=$MANPATH:$HOMEBREW/opt/coreutils/libexec/gnuman"

elif [ "$(uname)" == "Linux" ]; then

    export PATH="${PATH}:/root/.local/bin"

    password=$(gpg --quiet --decrypt "${HOME}/.gnupg/.password.gpg")

fi

if [ "$(uname)" == "Darwin" ]; then
    installed_cache="$(brew ls)"
elif [ "$(uname)" == "Linux" ]; then
    if [ -d /etc/redhat-release ]; then
        installed_cache="$(rpm -qa)"
    elif [ -f /etc/debian_version ]; then
        installed_cache="$(dpkg-query -f '${binary:Package}\n' -W)"
    elif [ -f /etc/arch_release ]; then
        installed_cache="$(pacman -Qqe)"
    else
        installed_cache=""
    fi
else
    installed_cache=""
fi

installedp() {
    local installed=$(echo "${installed_cache}" | egrep ^"${1}"\(-\([0-9.]+\|dev\)\)?\(:amd64\)?$)
    [ x"" != x"${installed}" ]
}

install() {
    installedp "${1}"
    IFS=' ' read -r -a pkg <<< "${2}"
    if [ $? -ne 0 ]; then
        if [ "$(uname)" == "Darwin" ]; then
            brew install ${pkg[*]}
        elif [ "$(uname)" == "Linux" ]; then
            if [ -d /etc/redhat-release ]; then
                sudo yum install ${pkg[*]}
            elif [ -f /etc/debian_version ]; then
                echo "${password}" | sudo -S apt-get install -y ${pkg[*]}
            elif [ -f /etc/arch_release ]; then
                sudo pacman -Sy ${pkg[*]}
            fi
        fi
    fi
}

install mosh mosh

install bash-completion bash-completion
if [ "$(uname)" == "Darwin" ]; then
    source $HOMEBREW/etc/bash_completion
elif [ "$(uname)" == "Linux" ]; then
    source /usr/share/bash-completion/bash_completion
fi

install keychain keychain
if [ "$(uname)" == "Darwin" ]; then
    eval `keychain --eval --agents ssh --inherit any id_rsa`
elif [ "$(uname)" == "Linux" ]; then
    eval `keychain --eval --agents ssh id_rsa`
fi

install mercurial mercurial
install wget      wget
if [ "$(uname)" == "Linux" ]; then
    install software-properties-common software-properties-common
    install dirmngr dirmngr
fi
install tmux      tmux
install direnv    direnv
install pandoc    pandoc

if [ "$(uname)" == "Linux" ]; then
    if [ -f /etc/debian_version ]; then
        install libbz2-dev      libbz2-dev
        install libreadline-dev libreadline-dev
        install libsqlite3-dev  libsqlite3-dev
    fi
fi

# Haskell
if [ "$(uname)" == "Darwin" ]; then
    install haskell-stack haskell-stack
elif [ "$(uname)" == "Linux" ]; then
    if [ -d /etc/arch_release ] ; then
        install stack stack
    else
        if [ ! -d "${HOME}/bin/stack" ]; then
            mkdir -p "${HOME}/tmp"
            rm -rf "${HOME}/tmp/stack"
            curl -sSL 'https://get.haskellstack.org/' > "${HOME}/tmp/stack"
            echo "${password}" | sudo -S sh "${HOME}/tmp/stack" -d "${HOME}/bin/stack"
            rm -rf "${HOME}/tmp/stack"
        fi
        export PATH="${PATH}:${HOME}/bin/stack"
    fi
fi
installedp opam
if [ $? -ne 0 ]; then
    install opam opam
    opam init --enable-shell-hook
fi
eval `opam config env`
eval $(opam env)

# Go
if [ "$(uname)" == "Darwin" ]; then
    install go go
elif [ "$(uname)" == "Linux" ]; then
    if [ -f /etc/debian_version ]; then
        install golang golang
    else
        install go go
    fi
fi
export GOPATH="${HOME}/Projects/go"
export PATH="${PATH}:${GOPATH}/bin"
[ ! -d "${GOPATH}/src/golang.org/x/tools/cmd"        ] && go get -u golang.org/x/tools/cmd/...
[ ! -d "${GOPATH}/src/github.com/kardianos/govendor" ] && go get -u github.com/kardianos/govendor
[ ! -d "${GOPATH}/src/github.com/nsf/gocode"         ] && go get -u github.com/nsf/gocode
[ ! -d "${GOPATH}/src/github.com/rogpeppe/godef"     ] && go get -u github.com/rogpeppe/godef

# Python
if [ "$(uname)" == "Darwin" ]; then
    install pyenv                   pyenv
    install pyenv-virtualenv        pyenv-virtualenv
    # install pyenv-virtualenvwrapper pyenv-virtualenvwrapper
    install readline                readline
    install xz                      xz
    install zlib                    zlib
elif [ "$(uname)" == "Linux" ]; then
    install python-pip python-pip
    if [ ! -d "${HOME}/.pyenv" ]; then
        git clone https://github.com/pyenv/pyenv.git "${HOME}/.pyenv"
        export PYENV_ROOT="${HOME}/.pyenv"
        export PATH="${PYENV_ROOT}/bin:${PATH}"
        git clone https://github.com/pyenv/pyenv-virtualenv.git "$(pyenv root)/plugins/pyenv-virtualenv"
        # git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git "$(pyenv root)/plugins/pyenv-virtualenvwrapper"
    else
        export PYENV_ROOT="${HOME}/.pyenv"
        export PATH="${PYENV_ROOT}/bin:${PATH}"
    fi
    if [ -f /etc/debian_version ]; then
        install make            make
        install libssl-dev      libssl-dev
        install zlib1g-dev      zlib1g-dev
        install libffi-dev      libffi-dev
        install python-openssl  python-openssl
    elif [ -d /etc/redhat-release ]; then
        install openssl-devel   openssl-devel
        install zlib-devel      zlib-devel
        install libffi-devel    libffi-devel
    fi
fi
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
current_python_version_match=$(pyenv versions | grep "^  ${CURRENT_PYTHON_VERSION_REGEX}$")
if [ ! "${current_python_version_match}" == "  ${CURRENT_PYTHON_VERSION}" ]; then
    if [ "$(uname)" == "Darwin" ]; then
        CFLAGS="-I$(brew --prefix readline)/include -I$(brew --prefix openssl)/include -I$(xcrun --show-sdk-path)/usr/include" \
              LDFLAGS="-L$(brew --prefix readline)/lib -L$(brew --prefix openssl)/lib" \
              PYTHON_CONFIGURE_OPTS=--enable-unicode=ucs2 \
              pyenv install "${CURRENT_PYTHON_VERSION}"
    else
        pyenv install "${CURRENT_PYTHON_VERSION}"
    fi
    rm -rf "${HOME}/.beancount"
fi
pyenv global system
# pyenv virtualenvwrapper

# Java
if [ ! -d "${HOME}/.emacs.d/eclipse.jdt.ls/server/" ]; then
    mkdir -p "${HOME}/.emacs.d/eclipse.jdt.ls/server/"
    wget http://download.eclipse.org/jdtls/snapshots/jdt-language-server-latest.tar.gz -O /tmp/jdt-latest.tar
    tar xf /tmp/jdt-latest.tar -C ~/.emacs.d/eclipse.jdt.ls/server/
fi

# Node.js
export NVM_DIR="$HOME/.nvm"
if [ "$(uname)" == "Darwin" ]; then
    install nvm nvm
    mkdir -p "${NVM_DIR}"
    source "$(brew --prefix nvm)/nvm.sh"
elif [ "$(uname)" == "Linux" ]; then
    if [ ! -d "${NVM_DIR}" ]; then
        git clone https://github.com/creationix/nvm.git "${NVM_DIR}"
        pushd "${NVM_DIR}" > /dev/null
        git checkout `git describe --abbrev=0 --tags`
        popd > /dev/null
    fi
    source "${NVM_DIR}/nvm.sh"
fi
[ ! $(nvm version node | grep "${CURRENT_NODE_VERSION_REGEX}") ] && nvm install "${CURRENT_NODE_VERSION}" && nvm alias default "${CURRENT_NODE_VERSION}"
[ $(npm list --depth 0 --global tern > /dev/null 2>&1) ] && npm install -g tern

# Ruby
if [ "$(uname)" == "Darwin" ]; then
    install rbenv      rbenv
    install ruby-build ruby-build
elif [ "$(uname)" == "Linux" ]; then
    if [ ! -d "${HOME}/.rbenv" ]; then
        git clone https://github.com/rbenv/rbenv.git "${HOME}/.rbenv"
    fi
    export PATH="${PATH}:${HOME}/.rbenv/bin"
fi
eval "$(rbenv init -)"

# Miscellaneous

# pass
install pass pass
if [ "$(uname)" == "Darwin" ]; then
    install lastpass-cli "lastpass-cli --with-pinentry"
elif [ "$(uname)" == "Linux" ]; then
    if [ -d /etc/redhat-release ] || [ -f /etc/arch_release ]; then
        install lastpass-cli lastpass-cli
    elif [ -f /etc/debian_version ]; then
        if [ ! -d "${HOME}/.lastpass-cli" ]; then
            echo "${password}" | sudo -S apt-get --no-install-recommends -yqq install \
              bash-completion \
              build-essential \
              cmake \
              libcurl3  \
              libcurl3-openssl-dev  \
              libssl1.0 \
              libssl1.0-dev \
              libxml2 \
              libxml2-dev  \
              pkg-config \
              ca-certificates \
              xclip
            git clone https://github.com/lastpass/lastpass-cli.git "${HOME}/.lastpass-cli"
            pushd "${HOME}/.lastpass-cli" > /dev/null
            git checkout `git describe --abbrev=0 --tags`
            make
            echo "${password}" | sudo -S make install
            popd > /dev/null
        fi
    fi
fi

# Emacs
if [ "$(uname)" == "Darwin" ]; then
    [ x"" != x"$(brew ls | egrep ^emacs\(-\([0-9.]+\|dev\)\)?\(:amd64\)?$)" ] && brew cask install emacs --appdir="${HOME}/Applications/"
elif [ "$(uname)" == "Linux" ]; then
    install emacs emacs
fi

# offlineimap + mu
if [ "$(uname)" == "Darwin" ]; then
    install imagemagick imagemagick
fi
install w3m         w3m
install offlineimap offlineimap
if [ "$(uname)" == "Darwin" ]; then
    install mu mu
elif [ "$(uname)" == "Linux" ]; then
    install maildir-utils maildir-utils
    install mu4e          mu4e
fi

# Beancount
if [ ! -d "${HOME}/.beancount" ]; then
    hg clone https://bitbucket.org/blais/beancount "${HOME}/.beancount"
    pushd "${HOME}/.beancount" > /dev/null
    pyenv virtualenv "${CURRENT_PYTHON_VERSION}" beancount
    pyenv shell beancount
    pip install .
    pyenv shell --unset
    popd > /dev/null
fi

install sox sox
if [ "$(uname)" == "Linux" ]; then
    install libsox-fmt-all libsox-fmt-all
fi


export PATH="${HOME}/bin_platform:${HOME}/bin:${PATH}"
export PATH="${HOME}/bin_local:${PATH}"

[ -f ~/.bashrc_local ] && source ~/.bashrc_local

if [ "$(uname)" == "Linux" ]; then
    if [ "${TILIX}" ] || [ "${VTE_VERSION}" ]; then
        source "/etc/profile.d/vte-2.91.sh"
    fi
fi

export GIT_AUTHOR_NAME='Jenny Kwan'
export GIT_AUTHOR_EMAIL='me@jennykwan.org'
export GIT_COMMITTER_NAME="${GIT_AUTHOR_NAME}"
export GIT_COMMITTER_EMAIL="${GIT_AUTHOR_EMAIL}"

# Direnv - Last
eval "$(direnv hook bash)"

# added by travis gem
# [ -f /Users/alyssackwan/.travis/travis.sh ] && source /Users/alyssackwan/.travis/travis.sh
