#!/usr/bin/env python3

from pathlib import Path
from typing import List, Dict, Tuple, Optional
import sys
import os
import fileinput
import argparse
import re


filename_matcher = re.compile(r'^[A-Za-z0-9\.]+\.((19|20)\d{2}\.|S\d{2}E\d{2}\.|(480|720|1080)p\.)+')


def try_fix_filename(filename: str) -> Optional[str]:
    m = filename_matcher.search(filename)
    if m:
        name = m.group()
        name = (name.rstrip('.')
                .replace('.', ' '))
        return name + Path(filename).suffix
    else:
        return None


def quote_for_posix(s):
    """
        http://code.activestate.com/recipes/498202-quote-python-strings-for-safe-use-in-posix-shells/
    """
    s = str(s)
    return "\\'".join("'" + p + "'" for p in s.split("'"))


def parse_args():
    parser = argparse.ArgumentParser(
        prog='rename-template',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog='''
example usage:
    rename-template --copy movies/*.mp4
    rename-template --print --relative --auto --output renamed --recursive .
    rename-template -par --relative --output renamed .
    rename-template -car --relative --output renamed .
    ''')
    parser.add_argument('--copy', '-c', action='store_true')
    parser.add_argument('--print', '-p', action='store_true')
    parser.add_argument('--no-sort', action='store_true')
    parser.add_argument('--relative', action='store_true', help='output path relative to cwd')

    parser.add_argument('--recursive', '-r', action='store_true', help='match recursively')
    parser.add_argument('--include', '-i', default=r'\.(mp4|mkv|avi|m4v|mov|srt)$',
                        help='regex matching files to include')
    parser.add_argument('--exclude', '-e', help='regex matching files to exclude')
    parser.add_argument('--auto', '-a', action='store_true', help='attempt to automatically rename files')
    parser.add_argument('--output', '-o', required=False, help='output folder')

    parser.add_argument(
        '--header',
        default='#!/usr/bin/env bash',
        help='what to put at the top of the file (e.g. so that text editor will auto detect the syntax',
    )
    parser.add_argument(
        '--cmd',
        default='ln',
        help="command to use (such as cp, mv, or ln)",
    )
    parser.add_argument(
        '--prefix',
        # default='///',
        default='`#`',
        help='string to prefix output filename with. Default is meant to be just something easy to search for.',
    )

    parser.add_argument(
        'files',
        nargs='*',
        help='paths to files to process. "-" to read from stdin'
    )

    return parser.parse_args()


def get_input_paths(files: List[str]) -> List[Path]:
    if len(files) == 1 and files[0] == '-':  # read from stdin
        return [Path(f.rstrip('\n')) for f in fileinput.input('-')]
    return [Path(f) for f in files]


def make_quoted_pairs(
        paths: List[Path],
        output_folder: Optional[str] = None,
        relative=True,
        sort=True,
        auto_rename=False,
) -> List[Tuple[str, str]]:
    paths = [p.absolute() for p in paths]
    if relative:
        cwd = Path('.').absolute()
        paths = [p.relative_to(cwd) for p in paths]
    output_path = None
    if output_folder:
        output_path = Path(output_folder)

    if auto_rename:
        pairs = []
        for p in paths:
            name = try_fix_filename(p.name)
            if not name:
                continue
            if output_path:
                pairs.append((quote_for_posix(p), quote_for_posix(output_path / name)))
            else:
                pairs.append((quote_for_posix(p), quote_for_posix(name)))
    elif output_path:
        pairs = [(
            quote_for_posix(p),
            quote_for_posix(output_path / p.name),
        ) for p in paths]
    else:
        pairs = [(
            quote_for_posix(p),
            quote_for_posix(p.name),
        ) for p in paths]

    if sort:
        pairs = sorted(pairs)
    return pairs


def make_content(quoted_pairs, header, cmd, prefix) -> str:
    maxlen = max(len(f[0]) for f in quoted_pairs)
    return (header + '\n' + '\n'.join(
        f' {cmd} {path:<{maxlen}} {prefix}{name}'
        for (path, name) in quoted_pairs
    ) + '\n')


def recurse_paths(input_paths: List[Path]) -> List[Path]:
    output: List[Path] = []
    for rootpath in input_paths:
        if rootpath.is_file():
            output.append(rootpath)
        elif rootpath.is_dir():
            for root, dirs, files in os.walk(rootpath):
                newroot = Path(root)
                output += [newroot / f for f in files]
    return output


def filter_paths(input_paths: List[Path], include: Optional[str], exclude: Optional[str]) -> List[Path]:
    if include:
        include_pattern = re.compile(include)
        input_paths = [p for p in input_paths if include_pattern.search(str(p))]
    if exclude:
        exclude_pattern = re.compile(exclude)
        input_paths = [p for p in input_paths if not exclude_pattern.search(str(p))]
    return input_paths


def main():
    args = parse_args()

    input_paths = get_input_paths(args.files)
    if args.recursive:
        input_paths = recurse_paths(input_paths)
    input_paths = filter_paths(input_paths, args.include, args.exclude)

    quoted_pairs = make_quoted_pairs(
        input_paths,
        relative=args.relative,
        sort=not args.no_sort,
        auto_rename=args.auto,
        output_folder=args.output,
    )
    content = make_content(
        quoted_pairs,
        header=args.header,
        cmd=args.cmd,
        prefix=args.prefix,
    )

    if args.print:
        print(content)
    if args.copy:
        from pyperclip import copy
        copy(content)


if __name__ == '__main__':
    main()
