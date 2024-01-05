# convenience marker so we can make sure this file has been sourced
MARKER_BASH_PROFILE=7

###############
## functions ##
###############
binary_exists() {
    [ -n "$(which $1 2>/dev/null)" ]
}
file_exists() {
    [ -f "$1" ]
}
folder_exists() {
    [ -d "$1" ]
}
source_if_exists() {
    if file_exists "$1"; then
        source "$1"
    fi
}

#########################
## Paths and constants ##
#########################
export GOPATH="$HOME/.go"
source_if_exists "$HOME/Dropbox/.bashrc_private" # stuff that doesn't belong on a public git
source_if_exists "$HOME/.bash_profile_local" # system-specific stuff
export PATH="$PATH:/sbin:/usr/sbin"
export PATH="$HOME/.local/bin/:$PATH"
export PATH="/opt/cmake/bin:$PATH"
export PATH="$HOME/.npm/bin/:$PATH"
export PATH="$HOME/.npm-global/bin/:$PATH"
export PATH="$HOME/bin/:$PATH"
# export PATH="/opt/ghc/8.0.1/bin/:$PATH"
# PATHS=(
#     "$HOME/bin/"
#     "$HOME/Dropbox/bin"
#     "$HOME/.local/bin/"
#     "/usr/local/go/bin/"
#     "/opt/cmake/bin/"
#     "$HOME/.go/bin"
#     "$HOME/.cabal/bin"
#     "$HOME/.cargo/bin"
#     "$HOME/.npm-global/bin"
# )
# for path in "${PATHS[@]}"; do
#     if folder_exists $path; then
#         export PATH="$path:$PATH"
#     fi
# done
export EDITOR="vim"
export TERMINAL="st"
# need this for tmux to use 256 colors
if [[ "$TERM" = "xterm" ]]; then
	export TERM="xterm-256color"
fi

# source system-specific overrides if they exist
source_if_exists "$HOME/.bash_profile_local"

if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.go/bin:$PATH"
export PATH=$PATH:/usr/local/go/bin

# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"

# if [ -e /home/j0sh/.nix-profile/etc/profile.d/nix.sh ]; then . /home/j0sh/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

source_if_exists ~/bin/_just.bash


export DENO_INSTALL="/home/j0sh/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
