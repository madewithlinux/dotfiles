#!/usr/bin/env bash

LOG="$HOME/.backup_logs/backup-$(date +'%Y-%m-%d_%H.%M').txt"

echo "$(date) starting backup" >> $LOG

duplicity \
	--exclude-other-filesystems \
	--exclude $HOME/.cache/ \
	--exclude $HOME/Downloads/stuff/ \
	--exclude $HOME/.local/share/Trash/ \
	--exclude "$HOME/VirtualBox VMs/Win10Metal" \
	--no-encryption \
	--full-if-older-than 1M \
	/home/j0sh \
	rsync://j0sh@192.168.1.72//sharedfolders/WdPassport2tb/home-j0sh-backup \
	>> $LOG 2>&1

echo "$(date) finished backup" >> $LOG
