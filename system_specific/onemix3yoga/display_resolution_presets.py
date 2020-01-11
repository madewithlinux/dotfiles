#!/usr/bin/env python3
from typing import List, Dict
import sys, os, stat

desktopLauncherBasePath = os.path.expanduser('~/.local/share/applications/')
scriptBasePath = os.path.expanduser('~/bin/')

def uiScaleSh(scale: int) -> str:
    return f"""gsettings set org.gnome.settings-daemon.plugins.xsettings overrides "{{'Gdk/WindowScalingFactor': <{scale}>}}" """

def textScaleSh(factor: float) -> str:
    return f"gsettings set org.gnome.desktop.interface text-scaling-factor {factor}"

def xrandrSh(outputs: Dict[str, dict]):
    code = 'xrandr'
    for name, options in outputs.items():
        code += f' --output {name}'
        if  options.get('enabled') == False or \
            options.get('disabled') == True or \
            options.get('off') == True:
            code += f' --off'
        if options.get('auto') == True:
            code += f' --auto'
        if 'rotate' in options:
            code += f' --rotate {options["rotate"]}'
        if 'scale' in options:
            code += f' --scale {options["scale"]}x{options["scale"]}'
        if 'mode' in options:
            code += f' --mode {options["mode"]}'
    return code


def writePreset(name: str,
        *,
        xrandr=None,
        uiScale=None,
        textScale=1.2,
    ):
    file_name = 'xrandr-' + name.replace(' ', '-')
    name = 'xrandr ' + name

    scriptPath = os.path.join(scriptBasePath, file_name+'.sh')
    with open(scriptPath, 'w') as f:
        f.write('#!/usr/bin/env bash\n')
        if xrandr:
            f.write(xrandrSh(xrandr))
            f.write('\n')
        if uiScale:
            f.write(uiScaleSh(uiScale))
            f.write('\n')
        if textScaleSh:
            f.write(textScaleSh(textScale))
            f.write('\n')
    os.chmod(scriptPath, os.stat(scriptPath).st_mode | stat.S_IEXEC)

    desktopLauncherPath = os.path.join(desktopLauncherBasePath, file_name+'.desktop')
    print(desktopLauncherPath)
    with open(desktopLauncherPath, 'w') as f:
        f.write(f"""[Desktop Entry]
Version=1.1
Type=Application
Name={name}
Comment=A small descriptive blurb about this application.
Icon=applications-other
Exec={scriptPath}
Actions=
Categories=menulibre-xrandr;
""")

writePreset(
    'internal display only normal',
    xrandr={
        'eDP-1': {
            'enabled': True,
            'auto': True,
            'scale': 1,
            'rotate': 'left',
        },
        'DP-1': { 'enabled': False },
        'HDMI-1': { 'enabled': False },
    },
    uiScale=2)

def downscaledMode(a,b):
    writePreset(
        f'internal display only {a}',
        xrandr={
            'eDP-1': {
                'enabled': True,
                'auto': False,
                'mode': b,
                'scale': 1,
                'rotate': 'left',
            },
            'DP-1': { 'enabled': False },
            'HDMI-1': { 'enabled': False },
        },
        uiScale=1)
downscaledMode('1280x720', '720x1280_60.00')
downscaledMode('1280x800', '800x1280_60.00')
downscaledMode('1920x1080', '1080x1920_60.00')
downscaledMode('2560x1440', '1440x2560_60.00')

writePreset(
    'internal display only right',
    xrandr={
        'eDP-1': {
            'enabled': True,
            'auto': True,
            'scale': 1,
            'rotate': 'normal',
        },
        'DP-1': { 'enabled': False },
        'HDMI-1': { 'enabled': False },
    },
    uiScale=2)

writePreset(
    'DP-1 only auto scale=1',
    xrandr={
        'eDP-1': { 'enabled': False },
        'DP-1': {
            'enabled': True,
            'auto': True,
            'scale': 1,
        },
        'HDMI-1': { 'enabled': False },
    },
    uiScale=1,
)

writePreset(
    'DP-1 only 1080p scale=2',
    xrandr={
        'eDP-1': { 'enabled': False },
        'DP-1': {
            'enabled': True,
            'mode': '1920x1080',
            'scale': 1,
        },
        'HDMI-1': { 'enabled': False },
    },
    uiScale=2,
)


writePreset(
    'HDMI-1 only 1080p scale=2',
    xrandr={
        'eDP-1': { 'enabled': False },
        'HDMI-1': {
            'enabled': True,
            'mode': '1920x1080',
            'scale': 1,
        },
        'DP-1': { 'enabled': False },
    },
    uiScale=2,
)
