#!/usr/bin/env python3

import inotify.adapters
import os
import sys
import subprocess
from time import time

def log(x):
    sys.stderr.write(x)
    sys.stderr.write('\n')

def clearscreen():
    os.system('clear')
    #print('') #todo print filename, command, and time?

def runcpp(args):
    # todo
    p = subprocess.run(['g++', '--std=c++11', '-lpthread', args[0]])
    if (p.returncode != 0):
        return None
    else:
        return subprocess.Popen(['./a.out'] + args[1:])


def runfile(args):
    ext = os.path.splitext(args[0])[1]
    runner = runners[ext]
    if isinstance(runner, str):
        # normal things
        return subprocess.Popen([runner] + args)
    elif isinstance(runner, list):
        return subprocess.Popen(runner + args)
    else:
        # special case function
        return runner(args)

runners = {
    '.tex': ['pdflatex', '-output-directory=.latex', '--halt-on-error', '-aux-directory=.latex'],
    '.sh':  'bash',
    '.hs':  'runhaskell',
    '.py':  'python3',
    '.c':   runcpp,
    '.cpp': runcpp,
    '':     'bash',
}
watch_events = {'CLOSE_WRITE', 'IN_MODIFY'}
# todo figure out a better way to do this
build_interval = 1.5 # seconds

if __name__ == '__main__':
    last_build = time()
    if (len(sys.argv) < 2):
        print("Usage:")
        print(sys.argv[0], "<file> [args...]")
        print("    watch <file>")
        print(sys.argv[0], "-s '<shell command>'")
        print("    recursively watch everything in the current folder")
        exit()
    shell = False
    if (sys.argv[1] == '-s'):
        f     = os.path.curdir
        args  = [sys.argv[2]]
        shell = True
    else:
        f     = sys.argv[1]
        args  = sys.argv[1:]
        shell = False
    sub  = None
    i    = inotify.adapters.Inotify()
    i.add_watch(bytes(f, 'utf-8'))

    # run first time
    if shell:
        sub = subprocess.Popen(['bash', '-c', args[0]])
    else:
        sub = runfile(args)

    try:
        for event in i.event_gen():
            if event is not None and time() - last_build > build_interval:
                if len(set(event[1]) & watch_events) != 0: 
                    last_build = time()
                    sub.terminate()
                    clearscreen()
                    if shell:
                        sub = subprocess.Popen(['bash', '-c', args[0]])
                    else:
                        sub = runfile(args)
    finally:
        pass

