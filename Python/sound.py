#!/usr/bin/env python

## MacOS ѕpecific 
# plays an mp3 file

from AppKit import NSSound

sound = NSSound.alloc()
sound.initWithContentsOfFile_byReference_("/Users/wishi/test.mp3", True)
sound.play()
