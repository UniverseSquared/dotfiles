# magical fix for gtk apps taking forever to open
dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

# load the xresources file
xrdb -merge ~/.Xresources

# remap caps lock to escape
setxkbmap -option caps:escape

# remap right alt to the Compose key
xmodmap -e 'keycode 108 = Multi_key'

# funny thing make java app work
wmname LG3D

# more funny magic to make java app work
export _JAVA_AWT_WM_NONREPARENTING=1

exec bspwm
