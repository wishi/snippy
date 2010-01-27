tell application "Finder"
	if (exists the disk "YourDisk") then
		eject "YourDisk"
	end if
end tell