#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
  xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
  xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
  xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
  xmodmap "$usermodmap"
fi

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

export XDG_SESSION_TYPE=x11

# xsetroot -solid "#181818" # background
xsetroot -solid "#32573b" # green
# xsetroot -solid "#49646b" # green to gray
# xsetroot -solid "#4f676b" # green to gray, lighter

sxhkd &
$HOME/go/bin/remote-touchpad -bind :8081 -secret crSTL2Evnwqyp6eGgiZH &> $HOME/remote-touchpad.log &
exec bspwm
