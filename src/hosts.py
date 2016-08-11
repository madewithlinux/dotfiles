#!/usr/bin/env pypy3
#!/usr/bin/env python3
# (c) Copyright 2015 Josh Wright

import urllib.request
import os
import sys

with open(os.path.expanduser('~/.hosts_whitelist'), 'rb') as f:
    whitelist = set(f.read().decode('utf-8').split('\n'))

sources = [
    'http://someonewhocares.org/hosts/zero/hosts',
    'http://www.mvps.org/winhelp2002/hosts.txt',
    'http://support.it-mate.co.uk/downloads/HOSTS.txt',
    'http://www.malwaredomainlist.com/hostslist/hosts.txt',
    'http://winhelp2002.mvps.org/hosts.txt',
    'http://pgl.yoyo.org/adservers/serverlist.php?showintro=0;hostformat=hosts',
    'http://hosts-file.net/download/hosts.txt',
    'https://adaway.org/hosts.txt',
]


if '-' in sys.argv:
    sources = []
    for line in sys.stdin:
        sources.append(line)

final_entries = set()

for source in sources:
    # get all lines of the file at the url in a list
    sys.stderr.write("Downloading: " + source + '\n')
    lines = urllib.request.urlopen(source).read().decode('utf-8').split('\n')
    assert isinstance(lines, list)
    for line in lines:
        if line.endswith('\r'):
            line = line[:-1]
        # ignore commented lines
        if line.startswith('#'):
            continue
        if line.startswith('127.0.0.1'):
            # replace it like this just in case 127.0.0.1 somehow appears in the domain name
            line = '0.0.0.0' + line[9:]
        final_entries.add(line)

for x in whitelist:
    if x in final_entries:
        final_entries.remove(x)

print('# hosts file made by j0sh')
if os.path.exists('/etc/hostname'):
    with open('/etc/hostname', 'r') as f:
        print('127.0.0.1 ' + f.read() + "# current hostname for this machine")

print('127.0.0.1 localhost #IPv4 localhost')
print('::1 localhost #IPv6 localhost')
print('\n'.join(final_entries))