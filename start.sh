#!/usr/bin/env bash

compton &
feh --bg-scale ~/.xmonad/are-we.png

setxkbmap "us+bg(phonetic):2+group(alt_shift_toggle)" -option caps:escape

xmobar ~/.xmonad/.xmobarrc &

exec xmonad
