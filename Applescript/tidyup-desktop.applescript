tell application "Finder"
	set myDesktop to (path to desktop folder)
	if not (exists folder "DesktopStuff" of myDesktop) then
		make new folder at myDesktop with properties {name:"DesktopStuff"}
	end if
	set myDesktopStuff to alias ((myDesktop as text) & "DesktopStuff:")
	
	-- check if initial folders exist, otherwise create them
	if not (exists folder "DesktopMusic" of myDesktopStuff) then
		make new folder at myDesktopStuff with properties {name:"DesktopMusic"}
	end if
	if not (exists folder "DesktopApps" of myDesktopStuff) then
		make new folder at myDesktopStuff with properties {name:"DesktopApps"}
	end if
	if not (exists folder "DesktopImages" of myDesktopStuff) then
		make new folder at myDesktopStuff with properties {name:"DesktopImages"}
	end if
	if not (exists folder "DesktopVideos" of myDesktopStuff) then
		make new folder at myDesktopStuff with properties {name:"DesktopVideos"}
	end if
	if not (exists folder "DesktopDocs" of myDesktopStuff) then
		make new folder at myDesktopStuff with properties {name:"DesktopDocs"}
	end if
	if not (exists folder "DesktopCompressed" of myDesktopStuff) then
		make new folder at myDesktopStuff with properties {name:"DesktopCompressed"}
	end if
	if not (exists folder "Folders" of myDesktopStuff) then
		make new folder at myDesktopStuff with properties {name:"Folders"}
	end if
	
	-- folders to sort into
	set DesktopMusic to alias ((myDesktopStuff as text) & "DesktopMusic:")
	set DesktopApps to alias ((myDesktopStuff as text) & "DesktopApps:")
	set DesktopImages to alias ((myDesktopStuff as text) & "DesktopImages:")
	set DesktopVideos to alias ((myDesktopStuff as text) & "DesktopVideos:")
	set DesktopDocs to alias ((myDesktopStuff as text) & "DesktopDocs:")
	set DesktopCompressed to alias ((myDesktopStuff as text) & "DesktopCompressed:")
	set DesktopFolders to alias ((myDesktopStuff as text) & "Folders:")
	
	--extension lists
	set musicExt to {".mp3", ".aac"}
	set programsExt to {".dmg", ".sit", ".app"}
	set picsExt to {".jpg", ".gif", ".tif", ".png", ".psd", ".jpeg"}
	set compressedExt to {".rar", ".zip"}
	set videosExt to {".avi", ".mpg", ".mov", ".mkv", ".m4v"}
	set docsExt to {".pdf", ".txt", ".doc", ".xls", ".sav", ".key", ".pages", ".jmp", ".rtf"}
	
	set allFiles to files of myDesktop
	repeat with theFile in allFiles
		copy name of theFile as string to FileName
		
		repeat with ext in musicExt
			if FileName ends with ext then
				if exists file FileName of DesktopMusic then
					set n to 1
					set {tid, AppleScript's text item delimiters} to {AppleScript's text item delimiters, "."}
					set newName to (text items 1 thru -2 of (FileName)) as text
					set newExt to (text item -1 of (FileName)) as text
					tell (get name of DesktopMusic's files) to repeat while FileName is in it
						set FileName to newName & "_" & n & "." & newExt
						set n to n + 1
					end repeat
					set name of theFile to FileName
					move file FileName to DesktopMusic
				else
					move theFile to DesktopMusic
				end if
			end if
		end repeat
		repeat with ext in compressedExt
			if FileName ends with ext then
				if exists file FileName of DesktopCompressed then
					set n to 1
					set {tid, AppleScript's text item delimiters} to {AppleScript's text item delimiters, "."}
					set newName to (text items 1 thru -2 of (FileName)) as text
					set newExt to (text item -1 of (FileName)) as text
					tell (get name of DesktopCompressed's files) to repeat while FileName is in it
						set FileName to newName & "_" & n & "." & newExt
						set n to n + 1
					end repeat
					set name of theFile to FileName
					move file FileName to DesktopCompressed
				else
					move theFile to DesktopCompressed
				end if
			end if
		end repeat
		
		repeat with ext in programsExt
			if FileName ends with ext then
				if exists file FileName of DesktopApps then
					set n to 1
					set {tid, AppleScript's text item delimiters} to {AppleScript's text item delimiters, "."}
					set newName to (text items 1 thru -2 of (FileName)) as text
					set newExt to (text item -1 of (FileName)) as text
					tell (get name of DesktopApps's files) to repeat while FileName is in it
						set FileName to newName & "_" & n & "." & newExt
						set n to n + 1
					end repeat
					set name of theFile to FileName
					move file FileName to DesktopApps
				else
					move theFile to DesktopApps
				end if
			end if
		end repeat
		
		repeat with ext in picsExt
			if FileName ends with ext then
				if exists file FileName of DesktopImages then
					set n to 1
					set {tid, AppleScript's text item delimiters} to {AppleScript's text item delimiters, "."}
					set newName to (text items 1 thru -2 of (FileName)) as text
					set newExt to (text item -1 of (FileName)) as text
					tell (get name of DesktopImages's files) to repeat while FileName is in it
						set FileName to newName & "_" & n & "." & newExt
						set n to n + 1
					end repeat
					set name of theFile to FileName
					move file FileName to DesktopImages
				else
					move theFile to DesktopImages
				end if
			end if
		end repeat
		repeat with ext in docsExt
			if FileName ends with ext then
				if exists file FileName of DesktopDocs then
					set n to 1
					set {tid, AppleScript's text item delimiters} to {AppleScript's text item delimiters, "."}
					set newName to (text items 1 thru -2 of (FileName)) as text
					set newExt to (text item -1 of (FileName)) as text
					tell (get name of DesktopDocs's files) to repeat while FileName is in it
						set FileName to newName & "_" & n & "." & newExt
						set n to n + 1
					end repeat
					set name of theFile to FileName
					move file FileName to DesktopDocs
				else
					move theFile to DesktopDocs
				end if
			end if
		end repeat
		
		repeat with ext in videosExt
			if FileName ends with ext then
				if exists file FileName of DesktopVideos then
					set n to 1
					set {tid, AppleScript's text item delimiters} to {AppleScript's text item delimiters, "."}
					set newName to (text items 1 thru -2 of (FileName)) as text
					set newExt to (text item -1 of (FileName)) as text
					tell (get name of DesktopVideos's files) to repeat while FileName is in it
						set FileName to newName & "_" & n & "." & newExt
						set n to n + 1
					end repeat
					set name of theFile to FileName
					move file FileName to DesktopVideos
				else
					move theFile to DesktopVideos
				end if
			end if
		end repeat
		
	end repeat
	
	set allFolders to folders of myDesktop
	repeat with theFolder in allFolders
		copy name of theFolder as string to Foldername
		
		if Foldername is not "DesktopStuff" then
			if exists folder Foldername of DesktopFolders then
				set n to 1
				set newName to (text of (Foldername)) as text
				tell (get name of DesktopFolders's folders) to repeat while Foldername is in it
					set Foldername to newName & "_" & n
					set n to n + 1
				end repeat
				set name of theFolder to Foldername
				move folder Foldername to DesktopFolders
			else
				move theFolder to DesktopFolders
			end if
		end if
		
	end repeat
	
end tell