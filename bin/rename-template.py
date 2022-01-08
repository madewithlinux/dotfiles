#!/usr/bin/env python3

# header just so that sublime text auto detects the syntax
header          = '#!/usr/bin/env bash'
# start with space so commands don't save in bash history
move            = ' mv '
# this is just something easy to search for
filename_prefix = '///'

import os
import sys
import os.path as path

def quote_for_posix(string):
    """
        http://code.activestate.com/recipes/498202-quote-python-strings-for-safe-use-in-posix-shells/
    """
    return "\\'".join("'" + p + "'" for p in string.split("'"))

if len(sys.argv) > 1:
    files = sys.argv[1:]
else:
    from pyperclip import paste
    files = paste().split('\n')

files = sorted(files)
fullpaths = [quote_for_posix(path.abspath(f))  for f in files]
basenames = [quote_for_posix(path.basename(f)) for f in files]
maxlen = max(len(f) for f in fullpaths)


content = (header + '\n' + '\n'.join(
    move + 
    fp.ljust(maxlen+1) +
    filename_prefix +
    b
    for (fp, b) in zip(fullpaths, basenames)
))
try:
    from pyperclip import copy
    copy(content)
except:
    print(content)
    print('# failed to import pyperclip')

