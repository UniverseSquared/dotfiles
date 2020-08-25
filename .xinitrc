# load the xresources file
xrdb -merge ~/.Xresources

# remap caps lock to escape
setxkbmap -option caps:escape

# remap right alt to the Compose key
xmodmap -e 'keycode 108 = Multi_key'

exec bspwm
