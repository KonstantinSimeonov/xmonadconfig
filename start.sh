#!/usr/bin/env bash
#sh ~/.fehbg &
compton &
feh --bg-scale ~/.xmonad/are-we.png

setxkbmap "us+bg(phonetic):2+group(alt_shift_toggle)" -option caps:escape

xmobar ~/.xmobarrc &

exec xmonad
