#!/usr/bin/env bash

info() {
	echo "origin: $(git config --get remote.origin.url)"
	echo "HEAD: $(git rev-parse HEAD)"
	# echo "diff:"
	git diff HEAD | cat
}

info
# in tests, gzip has best compression for these small text snippets
echo "############################# gzip -9 | base64 #############################"
info | gzip -9 | base64
# echo "############################# bzip2 -9 | base64 ############################"
# info | bzip2 -9 | base64
# echo "############################# xz -9 | base64 ###############################"
# info | xz -9 | base64
