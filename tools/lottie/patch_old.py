#!/usr/bin/env python3
"""Targeted fixes to original designer files whose drawing is fine except for one detail.

Usage: python3 tools/lottie/patch_old.py [--out DIR] [--src DIR] [name ...]

Each patch sets absolute values (not offsets), so applying it twice gives the same file.
"""

import argparse
import copy
import json
import os

ROOT = os.path.join(os.path.dirname(__file__), '..', '..')
ASSETS = os.path.join(ROOT, 'assets', 'animations')


def _layer(data, name):
    return next(l for l in data['layers'] if l['nm'] == name)


def downward_dog(data):
    """The near arm covered the whole face. The head moves a little along the torso towards
    the feet (it hangs between the arms, looking back); the arm stays over the head, as it
    should, but now crosses its back instead of the face."""
    head = _layer(data, 'head')
    # absolute positions of the three breathing keys (the old ones were 272, 320 / 316)
    for kf, (x, y) in zip(head['ks']['p']['k'][:3],
                          [(HEAD_X, 313.0), (HEAD_X, 309.0), (HEAD_X, 313.0)]):
        kf['s'][0], kf['s'][1] = x, y
    return data


HEAD_X = 249.0


ARM_COLOR = [0.259, 0.259, 0.345, 1.0]    # the arm colour of the other files


def l_sit(data):
    """The supporting arms and hands were filled with a dark blue that appears nowhere
    else; they get the normal arm colour."""
    for name in ('arms', 'hands'):
        for shape in _layer(data, name)['shapes']:
            for item in (shape['it'] if shape['ty'] == 'gr' else [shape]):
                if item['ty'] == 'fl':
                    item['c']['k'] = list(ARM_COLOR)
    return data


PATCHES = {
    'cooldown_downward_dog': downward_dog,
    'core_s5_l_sit': l_sit,
}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--src', default=ASSETS)
    ap.add_argument('--out', default=ASSETS)
    ap.add_argument('names', nargs='*')
    args = ap.parse_args()
    for name in args.names or list(PATCHES):
        with open(os.path.join(args.src, name + '.json')) as f:
            data = json.load(f)
        data = PATCHES[name](copy.deepcopy(data))
        path = os.path.join(args.out, name + '.json')
        with open(path, 'w') as f:
            json.dump(data, f, separators=(',', ':'))
        print(path)


if __name__ == '__main__':
    main()
