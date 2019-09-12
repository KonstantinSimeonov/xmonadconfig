#!/usr/bin/env bash

compton &
feh --bg-scale ~/.xmonad/hearthstone-jaina-proudmoore.jpg

setxkbmap "us+bg(phonetic):2+group(alt_shift_toggle)" -option caps:escape

xmobar ~/.xmonad/xmobar.hs &

exec xmonad
