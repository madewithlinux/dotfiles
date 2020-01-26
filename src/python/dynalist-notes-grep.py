#!/usr/bin/python3
# finds all text files below CWD, recursively, and print a breadcrumbs-style map of
# the contents of the file. Assumes the file is indented with tabs

import sys, os

def countTabs(line: str) -> int:
    for i in range(len(line)):
        if line[i] != '\t':
            return i
    return 0

def printLines(filenamePathPrefix: str, filename: str):
    linesPath = [filename]
    runningIndent = 0
    with open(filename, 'r') as f:
        for line in f:
            thisLineIndent = countTabs(line)
            line = line.strip()
            if thisLineIndent > runningIndent:
                linesPath.append(line)
                print(filenamePathPrefix + ' |> '.join(linesPath))
                runningIndent = thisLineIndent
            elif thisLineIndent == runningIndent:
                linesPath[-1] = line
                print(filenamePathPrefix + ' |> '.join(linesPath))
            else: # thisLineIndent < runningIndent
                indentsToRemove = runningIndent - thisLineIndent
                linesPath = linesPath[0:len(linesPath) - 1 - indentsToRemove]
                linesPath.append(line)
                print(filenamePathPrefix + ' |> '.join(linesPath))
                runningIndent = thisLineIndent


for dirpath, dirnames, filenames in os.walk('.'):
    print(dirpath, dirnames, filenames)
    for filename in filenames:
        if not filename.endswith('.txt'):
            continue
        filenamePath = os.path.join(dirpath, filename)
        printLines(filenamePath + ':', filenamePath)

