#!/usr/bin/env python3

# btrfs-defrag.py -- Defragment only non-reflinked files on btrfs.
# Written in 2020 by Ruud van Asseldonk.
#
# To the extent possible under law, the author has dedicated all copyright and
# related neighbouring rights to this software to the public domain worldwide.
# See the CC0 dedication at https://creativecommons.org/publicdomain/zero/1.0/.

"""
Defragment all exclusive (non-reflinked) files under the current directory.
"""

import os
import os.path
import subprocess

from typing import Callable, Iterable, List, TypeVar

T = TypeVar('T')
U = TypeVar('U')


def map_chunks(f: Callable[[List[T]], Iterable[U]], n: int, xs: Iterable[T]) -> Iterable[U]:
    chunk = []

    for x in xs:
        chunk.append(x)
        if len(chunk) == n:
            yield from f(chunk)
            chunk = []

    if chunk != []:
        yield from f(chunk)


def list_files() -> Iterable[str]:
    for root, _dirs, files in os.walk('.'):
        for filename in files:
            yield os.path.join(root, filename)


def get_exclusive_files(fnames: List[str]) -> Iterable[str]:
    cmd = ['btrfs', 'filesystem', 'du', '--raw', *fnames]
    lines = subprocess.run(cmd, capture_output=True).stdout.splitlines()
    # Skip over the header line.
    for line in lines[1:]:
        total, exclusive, set_shared, filename = line.split(maxsplit=3)
        if set_shared == b'0' and exclusive != b'0':
            yield filename.decode('utf-8')


def defrag(fnames: List[str]) -> Iterable[int]:
    subprocess.run(['btrfs', 'filesystem', 'defragment', '-t', '512M', '-v', *fnames])
    yield len(fnames)


if __name__ == '__main__':
    all_files = list_files()
    exclusive_files = map_chunks(get_exclusive_files, 5, all_files)
    defrag_counts = map_chunks(defrag, 5, exclusive_files)
    print(sum(defrag_counts), 'files defragmented')
