#!/usr/bin/env bash

LOG="$HOME/.backup_logs/remote-backup-$(date +'%Y-%m-%d_%H.%M').txt"
source $HOME/.b2_secrets

echo "$(date) starting remote backup" >> $LOG

duplicity \
	--exclude-other-filesystems \
	--exclude $HOME/.cache/ \
	--exclude $HOME/Downloads/stuff/ \
	--exclude $HOME/.local/share/Trash/ \
	--exclude "$HOME/VirtualBox VMs/Win10Metal" \
	--no-encryption \
	--full-if-older-than 1M \
	/home/j0sh \
	"b2://${B2_ACCOUNT_ID}:${B2_APPLICATION_KEY}@home-j0sh-backup/" \
	>> $LOG 2>&1

echo "$(date) finished duplicity remote backup" >> $LOG

rclone sync \
	/home/j0sh \
	home-j0sh-backup-b2:home-j0sh-backup-b2 \
	--one-file-system \
	--copy-links \
	--ignore-errors \
	--transfers 32 \
	--exclude $HOME/.cache/ \
	--exclude $HOME/Downloads/stuff/ \
	--exclude $HOME/.local/share/Trash/ \
	>> $LOG 2>&1

echo "$(date) finished rclone remote backup" >> $LOG
