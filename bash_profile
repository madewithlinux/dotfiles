#!/usr/bin/env bash

if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

if [ -z "$DISPLAY" ] && (fgconsole >/dev/null 2>&1) && [ "$(fgconsole)" -eq 1 ]; then
  exec startx
fi
