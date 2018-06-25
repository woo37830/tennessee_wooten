on run
	set info to ""
	set info2 to ""
	tell application "System Events"
		set num to count (every process whose name is "iTunes")
	end tell
	if num > 0 then
		tell application "iTunes"
			if player state is playing then
				set who to artist of current track
				set what to name of current track
				set info to what & " by " & who as string
			end if
		end tell
	end if
	return info
end run
