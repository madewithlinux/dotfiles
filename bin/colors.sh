#!/usr/bin/env bash

# for C in {0..255}; do
#     tput setab $C
#     echo -n "$C "
# done
# tput sgr0
# echo

echo '# standard colors'
for C in {30..47}; do
    echo -en "\e[${C}m $C  "
    echo "\e[${C}m "
done
echo -e "\e(B\e[m"

echo '# high intensity colors'
for C in {100..107}; do
    echo -en "\e[${C}m $C  "
    echo "\e[${C}m "
done
echo -e "\e(B\e[m"

echo '# 256 colors'
for C in {16..255}; do
    echo -en "\e[48;5;${C}m$C "
    # echo "\e[48;5;${C}m "
done
echo -e "\e(B\e[m"

echo -e "\e(B\e[m"
