#!/usr/bin/env bash

duplicity \
	--exclude-other-filesystems \
	--no-encryption \
	--full-if-older-than 1M \
	/home/j0sh \
	rsync://j0sh@192.168.0.101//sharedfolders/WdPassport2tb/home-j0sh-backup
