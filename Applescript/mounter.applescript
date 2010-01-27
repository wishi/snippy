property diskname : "NameOfYourDrive"
property diskpath : "Macintosh HD:Users:Youruseraccount:Desktop:YourDrive"



tell application "Finder"
	if not (exists the disk diskname) then
		do shell script "diskutil mount `disktool -l | grep 'YourDrive' | sed 's/.*\\(disk[0-9s]*\\).*/\\1/'`"
		delay 1
	end if
end tell