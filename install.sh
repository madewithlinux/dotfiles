#!/bin/bash
# installs these things, even if the git repo isn't cloned
# ideal for curl|bash

# start actual items at index 1 because that's easier for selecting from
ITEMS=("" bashrc bash_profile inputrc tmux.conf)
ITEM_URLS=("" \
    "https://raw.githubusercontent.com/madewithlinux/dotfiles/master/bashrc.sh" \
    "https://raw.githubusercontent.com/madewithlinux/dotfiles/master/bash_profile.sh" \
    "https://raw.githubusercontent.com/madewithlinux/dotfiles/master/inputrc" \
    "https://raw.githubusercontent.com/madewithlinux/dotfiles/master/tmux.conf" \
)
ITEM_PATHS=("" "$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.inputrc" "$HOME/.tmux.conf")

count=1
for item in ${ITEMS[*]}; do
    echo "${count}) ${item}"
    count=$[$count+1]
done

read -p '>>> ' selection

for item in $selection; do
    # echo "{$item}: ${ITEMS[$item]}"
    if [[ -a "${ITEM_PATHS[$item]}" ]]; then
        echo -n "file ${ITEM_PATHS[$item]} already exists.! (O)verwrite (A)ppend, (S)kip? "
        read choice
        case $choice in
            ["O|o"])
                echo "overwriting ${ITEM_PATHS[$item]}"
                ;;
            ["A|a"])
                echo "appending to ${ITEM_PATHS[$item]}"
                wget -O - "${ITEM_URLS[$item]}" >> "${ITEM_PATHS[$item]}"
                continue
                ;;
            ["S|s"])
                continue
                ;;
        esac
    fi
    wget -O - "${ITEM_URLS[$item]}" > "${ITEM_PATHS[$item]}"
done

