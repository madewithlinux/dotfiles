#!/usr/bin/env python3
# (c) Copyright 2015 Josh Wright

import sys, os, hashlib

if len(sys.argv) < 2:
    print("Usage: find_duplicate_files.py [path]")
    exit(1)

# last arg is path
# (accounts for running with interpreter or something...)
scan_dir = os.path.abspath(sys.argv[-1])

def are_files_unique(files, blocksize=1024*10):
    files_dict = {b'init': []}
    for path in files:
        files_dict[b'init'].append([
                path,
                open(path, 'rb'),
                hashlib.sha1(),
            ])
    blocks = int( os.path.getsize(files[0]) / blocksize )
    return_list = []
    # this lets us auto-quit when we reach the end of the file
    for i in range(blocks):
        files_dict_new = {}
        for hash_id in files_dict:
            obj_list = files_dict[hash_id]
            if len(obj_list) == 1:
                # path to file
                # here we skip adding it to files_dict_new, and thus don't check it next time
                # we put it in a list to keep things consistent
                return_list.append([obj_list[0][0] ])
            else:
                for obj in obj_list:
                    # update each, and put in new dict
                    obj[2].update(obj[1].read(blocksize))
                    new_hash_id = obj[2].digest()
                    if new_hash_id in files_dict_new:
                        files_dict_new[new_hash_id].append(obj)
                    else:
                        files_dict_new[new_hash_id] = [obj]
        files_dict = files_dict_new
    for x in files_dict:
        lst = []
        for y in files_dict[x]:
            lst.append(y[0])
        return_list.append(lst)
    return return_list


found_files = {}

# build dict of filesize keys with list of file paths
for root, dirs, files in os.walk(scan_dir):
    for f in files:
        fullpath = os.path.join(root, f)
        size = os.path.getsize(fullpath)
        if size in found_files:
            found_files[size].append(fullpath)
        else:
            found_files[size] = [fullpath]

duplicate_files = []
for file_list in found_files.values():
    # if there is only one file
    if len(file_list) == 1:
        continue
    analyzed_output = are_files_unique(file_list)
    for x in analyzed_output:
        if len(x) > 1:
            duplicate_files.append(x)

for x in duplicate_files:
    for y in x:
        print("Duplicate: "+y)