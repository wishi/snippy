on adding folder items to this_folder after receiving added_items
	tell application "Finder"
		repeat with this_item in added_items
			set ppath to POSIX path of this_item
			do shell script "touch " & quoted form of ppath
			
		end repeat
	end tell
end adding folder items to