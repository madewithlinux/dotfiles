#!/usr/bin/env python3
# (c) Copyright 2016 Josh Wright

import os,sys, webbrowser

if len(sys.argv) < 2:
	print("Usage: " + sys.argv[0] + " <path>")
	exit(1)

# make sure we have a full path
target = os.path.abspath(sys.argv[1])
# constants
julia_url = "http://127.0.0.1:8888/"
julia_cwd = "/home/j0sh/"


if target.endswith(".ipynb"):
	# directly open a notebook
	# remove the working directory
	target = target.replace(julia_cwd, "", 1)
	webbrowser.open(julia_url + "notebooks/" + target)
elif os.path.isdir(target):
	# open the folder
	target = target.replace(julia_cwd, "", 1)
	webbrowser.open(julia_url + "tree/" + target)