#!/bin/bash
# borrowed from JessFraz Dotfiles: https://github.com/jessfraz/dotfiles/blob/master/bin/install.sh
set -e
set -o pipefail

USER_REPOS_PATH="$HOME/dev/github.com/lingard"
DOTFILES_ROOT="$USER_REPOS_PATH/dotfiles-1"

usage() {
    echo -e "install.sh\\n\\tThis script installs my basic setup for a MacOS laptop\\n"
    echo "Usage: "
    echo "  packages    - install packages from homebrew"
    echo "  dotfiles    - get dotfiles"
    echo "  tools       - install homebrew"
}

base() {
    install_tools

    echo "installing dependencies from Brewfile..."
    cd "$DOTFILES_ROOT" && brew bundle
}

install_homebrew() {
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install | /usr/bin/ruby
}

install_tools() {
    if ! hash brew 2>/dev/null; then
        echo "installing brew..."
        install_homebrew
    fi

    install_oh_my_zsh
}

create_ssh_key() {
    pub=$HOME/.ssh/id_rsa.pub
    echo 'Checking for SSH key, generating one if it does not exist...'
    [[ -f $pub ]] || ssh-keygen -t rsa
    
    echo 'Copying public key to clipboard. Paste it into your Github account...'
    [[ -f $pub ]] && cat $pub | pbcopy
    open 'https://github.com/account/ssh'
}

setup_xcode_select() {
    # Install Xcode Command Line Tools
    if ! xcode-select --print-path &> /dev/null; then
        # Prompt user to install the XCode Command Line Tools
        xcode-select --install &> /dev/null

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        # Wait until the XCode Command Line Tools are installed
        until xcode-select --print-path &> /dev/null; do
            sleep 5
        done

        print_result $? 'Install XCode Command Line Tools'

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        # Point the `xcode-select` developer directory to
        # the appropriate directory from within `Xcode.app`
        # https://github.com/alrra/dotfiles/issues/13

        sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
        print_result $? 'Make "xcode-select" developer directory point to Xcode'

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        # Prompt user to agree to the terms of the Xcode license
        # https://github.com/alrra/dotfiles/issues/10

        sudo xcodebuild -license
        print_result $? 'Agree with the XCode Command Line Tools licence'
    fi
}

install_oh_my_zsh() {
    # Must be done before symlinking as oh-my-zsh will override .zshrc
    echo 'installing oh my zsh'
    curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
}

get_dotfiles() {    
    echo "getting dotfiles..."
    test -L "$DOTFILES_ROOT" || (
        mkdir -p "$USER_REPOS_PATH"
        git clone git@github.com:lingard/dotfiles-1.git "$DOTFILES_ROOT"
        cd "$DOTFILES_ROOT"
        git remote set-url origin git@github.com:lingard/dotfiles-1.git
        make
    )
}

main() {
    local cmd=$1

    if [[ -z "$cmd" ]]; then
        usage
        exit 1
    fi

    cd "$DOTFILES_ROOT" && if [[ $cmd == "base" ]]; then
        base
    elif [[ $cmd == "dotfiles" ]]; then
        get_dotfiles
    elif [[ $cmd == "homebrew" ]]; then
        install_homebrew
    elif [[ $cmd == "tools" ]]; then
        install_tools
    else
        usage
    fi
}

main "$@"
