#!/usr/bin/python3
import sh

xfconf_query = sh.Command('xfconf-query').bake(_long_sep=None)


keys_to_keep = {
    '/xfwm4/custom/<Primary><Shift>F1',
    '/xfwm4/custom/<Primary><Shift>F2',
    '/xfwm4/custom/<Primary><Shift>F3',
    '/xfwm4/custom/<Primary><Shift>F4',
    '/xfwm4/custom/<Primary><Shift>F5',
    '/xfwm4/custom/<Primary><Shift>F6',
    '/xfwm4/custom/<Primary><Shift>F7',
    '/xfwm4/custom/<Primary><Shift>F8',
    '/xfwm4/custom/<Primary><Shift>F9',
    '/xfwm4/custom/<Primary><Shift>F10',
    '/xfwm4/custom/<Primary><Shift>F11',
    '/xfwm4/custom/<Primary><Shift>F12',
    '/xfwm4/custom/<Shift><Super>Left',
    '/xfwm4/custom/<Shift><Super>Right',
    '/xfwm4/custom/<Primary><Super>Left',
    '/xfwm4/custom/<Primary><Super>Right',
    '/xfwm4/custom/<Alt>F10',
}

def find_duplicate_mappings():
    all_keys = xfconf_query(channel='xfce4-keyboard-shortcuts', list=True)
    key_values = []
    for key in all_keys:
        key = str(key)
        if key[-1] == '\n':
            key = key[:-1]
        if not key.startswith('/xfwm4/custom/'):
            continue
        value: str = xfconf_query(channel='xfce4-keyboard-shortcuts', property=key).strip()
        key_values.append((key, value))
        # print(key, value)
    
    by_value = {}
    for key, value in key_values:
        if value not in by_value:
            by_value[value] = set()
        by_value[value].add(key)
    
    for value, keys in by_value.items():
        if len(keys) == 1:
            continue
        keys_to_remove = keys - keys_to_keep
        print(f'{value}: {", ".join(keys_to_remove)}')
        # for key_to_remove in keys_to_remove:
        #     xfconf_query(channel='xfce4-keyboard-shortcuts', property=key_to_remove, reset=True).strip()


def set_preferred_mappings():
    for i in range(1, 12+1):
        xfconf_query(
        # print(dict(
            channel='xfce4-keyboard-shortcuts',
            property=f'/xfwm4/custom/<Primary><Shift>F{i}',
            set=f'move_window_workspace_{i}_key',
            type='string',
            create=True,
        # ))
        )
        xfconf_query(
        # print(dict(
            channel='xfce4-keyboard-shortcuts',
            property=f'/xfwm4/custom/<Primary>F{i}',
            set=f'workspace_{i}_key',
            type='string',
            create=True,
        # ))
        )

if __name__ == '__main__':
    import clize
    clize.run(
        set_preferred_mappings,
        find_duplicate_mappings,
    )

