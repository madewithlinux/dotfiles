#!/usr/bin/env bash

info() {
	echo "origin: $(git config --get remote.origin.url)"
	echo "HEAD: $(git rev-parse HEAD)"
	# pipe to cat to make sure it doesn't open pager
	git diff HEAD | cat
}

if [[ "$1" == "short" ]]; then
	echo "base64 -d << EOF | gunzip"
	info | gzip -9 | base64
	echo "EOF"
else
	info
	# in tests, gzip has best compression for these small text snippets
	echo "base64 -d << EOF | gunzip"
	info | gzip -9 | base64
	echo "EOF"
	# echo "############################# bzip2 -9 | base64 ############################"
	# info | bzip2 -9 | base64
	# echo "############################# xz -9 | base64 ###############################"
	# info | xz -9 | base64
fi
