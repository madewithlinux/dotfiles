#!/usr/bin/env python3
import os
import shutil
from pathlib import Path
from typing import Dict

import sh

"""
ref:
https://wiki.xfce.org/howto/xfwm4_theme#list_of_frame_and_button_part_names
requires imagemagick
    image_width() uses identify
"""


global_themes_dir = Path('/usr/share/themes/')
user_themes_dir = Path(os.path.expanduser('~/.themes/'))


files_to_skip = {
    'bottom-active.png',
    'bottom-active.xpm',
    'bottom-inactive.png',
    'bottom-inactive.xpm',
    'bottom-left-active.png',
    'bottom-left-active.xpm',
    'bottom-left-inactive.png',
    'bottom-left-inactive.xpm',
    'bottom-right-active.png',
    'bottom-right-active.xpm',
    'bottom-right-inactive.png',
    'bottom-right-inactive.xpm',
    'left-active.png',
    'left-active.xpm',
    'left-inactive.png',
    'left-inactive.xpm',
    'right-active.png',
    'right-active.xpm',
    'right-inactive.png',
    'right-inactive.xpm',
}


def image_width(image_path: Path) -> int:
    return int(sh.identify('-format', '%W', image_path))


def fix_top_border_width(xfwm4_path: Path):
    width_top_left_active = image_width(xfwm4_path / 'top-left-active.xpm')
    width_top_right_active = image_width(xfwm4_path / 'top-right-active.xpm')
    width_top_left_inactive = image_width(xfwm4_path / 'top-left-inactive.xpm')
    width_top_right_inactive = image_width(xfwm4_path / 'top-right-inactive.xpm')

    if not (
        width_top_left_active == width_top_right_active and
        width_top_left_active == width_top_left_inactive and
        width_top_left_active == width_top_right_inactive
    ):
        raise Exception(f'top left/righ active/inactive are different width!')

    button_offset = width_top_left_active

    themerc = xfwm4_path / 'themerc'
    themerc.write_text('\n'.join(
        line if not str(line).startswith('button_offset')
        else f'button_offset={button_offset}'
        for line in themerc.read_text().split('\n')
    ))

    print(f'set {button_offset=}')


def make_minimal_border_xfce4_theme(theme_name, *, hard_link=False):
    theme_name = str(theme_name)

    in_folder = global_themes_dir / theme_name / 'xfwm4'
    if not in_folder.exists():
        raise Exception(f'theme not found: {theme_name}')

    out_folder = user_themes_dir / f'{theme_name}_min_borders' / 'xfwm4'
    out_folder.mkdir(exist_ok=True, parents=True)

    for filepath in in_folder.iterdir():
        if not filepath.is_file:
            continue
        filename = filepath.name
        if filename in files_to_skip:
            continue

        dest_path = out_folder / filename
        if dest_path.exists():
            dest_path.unlink()

        if hard_link:
            # TODO: hard link files instead of copying
            assert False, 'hard linking is not implemented yet'
        else:
            shutil.copy(filepath, dest_path)
        print(f'{filepath} -> {dest_path}')

    fix_top_border_width(out_folder)


if __name__ == '__main__':
    import clize
    clize.run(
        make_minimal_border_xfce4_theme,
    )
