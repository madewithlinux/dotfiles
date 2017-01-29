# (c) Copyright 2017 Josh Wright
# bash_profile for my thinkpad

#########################
## Paths and constants ##
#########################
export PATH="/opt/cabal/1.24/bin:/opt/happy/1.19.5/bin:/opt/alex/3.1.7/bin:$PATH"
export PATH="/opt/cmake/bin:$PATH"
export PATH="/opt/ghc/8.0.1/bin/:$PATH"
# export PATH="/opt/ghc/7.10.3/bin:$PATH"
# for ease of navigation
export CODE="$HOME/Dropbox/code/"
export DOTFILES="$HOME/Dropbox/dotfiles/"
export TAMU="$HOME/Dropbox/Tablet/TAMU/"
export TEXINPUTS=".:/home/j0sh/Dropbox/code/LaTeX/sty:"

# make the printPrtSc key into a menu key
binary_exists xmodmap && [[ -n "$DISPLAY" ]] && xmodmap -e "keycode 107 = Menu NoSymbol Menu"

# use first TTY as login page
if [ -z "$DISPLAY" ] && (fgconsole >/dev/null 2>&1) && [ "$(fgconsole)" -eq 1 ]; then
    exec startx
fi
