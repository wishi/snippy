#! /usr/bin/zsh

# fixes an issue with SUN Java 6 and non-reparenting Window Managers
# fixes an issue with OpenJDK and non-reparenting Window Managers
# see: http://awesome.naquadah.org/wiki/Problems_with_Java
# depends on dwm-tools

wmname LG3D

# SUN fix
AWT_TOOLKIT=MToolkit
export AWT_TOOLKIT

# OpenJDK fix
_JAVA_AWT_WM_NONREPARENTING=1
export _JAVA_AWT_WM_NONREPARENTING

