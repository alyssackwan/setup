#!/bin/bash

if [ "$(uname)" == "Darwin" ]; then

    if [ ! -d "${HOME}/Applications/Insync.app" ]; then
        echo "Please install and configure insync."
        exit 1
    fi

    # make sure opt exists
    if [ ! -d "${HOME}/opt" ]; then
        mkdir "${HOME}/opt"
    fi

    # pkgconfig
    export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/opt/X11/lib/pkgconfig:${PKG_CONFIG_PATH}"

    # Homebrew
    if [ ! -d "${HOME}/opt/homebrew" ]; then
        mkdir "${HOME}/opt/homebrew"
        (cd ~/opt && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew)
        "${HOME}/opt/homebrew/bin/brew" update
    fi
    export HOMEBREW="${HOME}/opt/homebrew"
    export HOMEBREW_CACHE="${HOME}/Library/Caches/Homebrew"
    export PATH="$HOMEBREW/bin:$HOMEBREW/sbin:$PATH"
    export PKG_CONFIG_PATH="$HOMEBREW/lib/pkgconfig:$PKG_CONFIG_PATH"
    export CPATH="$CPATH:$HOMEBREW/include"
    export HOMEBREW_CASK_OPTS="--appdir=${HOME}/Applications"

    brew install git

    if [ ! -d "${HOME}/.gnupg" ]; then
        mkdir "${HOME}/.gnupg"
        touch "${HOME}/.gnupg/gpg-agent.conf"
    fi

    if [ x"" == x"$(brew ls --versions pinentry-mac)" ]; then
        brew install pinentry-mac
        echo "pinentry-program ${HOMEBREW}/bin/pinentry-mac" >> "${HOME}/.gnupg/gpg-agent.conf"
    fi
    [ x"" == x"$(brew ls --versions gnupg       )" ] && brew install gnupg

elif [ "$(uname)" == "Linux" ]; then
    if [ -d /etc/redhat-release ]; then
        sudo yum install git
    elif [ -f /etc/debian_version ]; then

        if [ ! -f "/etc/apt/sources.list.d/insync.list" ]; then
            sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ACCAF35C
            echo "deb http://apt.insynchq.com/debian stretch non-free contrib" | sudo tee /etc/apt/sources.list.d/insync.list
            sudo apt-get update
            sudo apt-get install insync-headless
        fi
        if [ ! -d "${HOME}/Google Drive" ]; then
            insync-headless start
            echo 'http://www.insynchq.com/auth to get the auth_code.'
            read -p 'auth_code: ' AUTH_CODE
            insync-headless add_account -a ${AUTH_CODE}
            insync-headless move_folder "${HOME}/me@alyssackwan.name" "${HOME}/Google Drive"
            insync-headless set_autostart yes
        fi

        sudo -S apt-get install -y git

    elif [ -f /etc/arch_release ]; then
        sudo pacman -Sy git
    fi
fi

pushd "${HOME}" > /dev/null

rm -rf .password-store
git clone https://github.com/alyssackwan/.password-store.git

dotglob_shopt=$(shopt -q dotglob)
shopt -qs dotglob

sudo chmod -R a-x .password-store/.gnupg
sudo chmod -R u=rwX,g=,o= .password-store/.gnupg
cp -r .password-store/.gnupg/. .gnupg/
cp -r .password-store/.ssh/. .ssh/

gpgconf --kill gpg-agent
pushd .gnupg > /dev/null
gpg --output secret-keys.asc --decrypt secret-keys.asc.gpg
gpg --import secret-keys.asc
rm secret-keys.asc
popd > /dev/null

pushd .ssh > /dev/null
gpg --output id_rsa --decrypt id_rsa.gpg
chmod 400 id_rsa
popd > /dev/null

[ ! "${dotglob_shopt}" ] && shopt -qu dotglob

rm -rf .password-store
git clone git@github.com:alyssackwan/.password-store.git

dotglob_shopt=$(shopt -q dotglob)
shopt -qs dotglob

sudo chmod -R a-x .password-store/.gnupg
sudo chmod -R u=rwX,g=,o= .password-store/.gnupg
cp -r .password-store/.gnupg/. .gnupg/
cp -r .password-store/.ssh/. .ssh/

gpgconf --kill gpg-agent
pushd .gnupg > /dev/null
gpg --output secret-keys.asc --decrypt secret-keys.asc.gpg
gpg --import secret-keys.asc
rm secret-keys.asc
popd > /dev/null

echo "Enter the local user's password"
read -sp 'password: ' PASSWORD
echo "${PASSWORD}" | gpg --encrypt -o ~/.gnupg/.password.gpg -r 'Alyssa Kwan (unattended)'

[ ! "${dotglob_shopt}" ] && shopt -qu dotglob

git clone git@github.com:alyssackwan/setup.git
if [ ! -f "${HOME}/bin" ] && [ ! -d "${HOME}/bin" ] && [ -d "${HOME}/setup/bin" ]; then
    pushd "${HOME}" > /dev/null
    ln -s "./setup/bin" .
    popd > /dev/null
fi
if [ "$(uname)" == "Darwin" ]; then
    if [ ! -f "${HOME}/bin_platform" ] && [ ! -d "${HOME}/bin_platform" ] && [ -d "${HOME}/setup/platform/uname/Darwin/bin" ]; then
        pushd "${HOME}" > /dev/null
        ln -s "./setup/platform/uname/Darwin/bin" bin_platform
        popd > /dev/null
    fi
    if [ ! -d "${HOME}/Applications" ]; then
        mkdir "${HOME}/Applications"
    fi
fi

function link_setup() {
    if [ -f "${HOME}/setup/${1}" ]; then
        [ -f "${HOME}/${1}" ] && mv "${HOME}/${1}" "${HOME}/${1}.bak"
        pushd "${HOME}" > /dev/null
        ln -s "./setup/${1}" .
        popd > /dev/null
    fi
}
link_setup '.bash_profile'
link_setup '.bashrc'
link_setup '.bash_logout'
link_setup '.tmux.conf'
link_setup '.emacs.el'
link_setup '.offlineimaprc'

if [ ! -d "${HOME}/bin_local" ]; then
    mkdir "${HOME}/bin_local"
fi

popd > /dev/null
