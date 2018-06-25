#!/bin/bash
osascript - title <<END
on run a
tell app "Reminders"
tell list "Reminders" of default account
make new reminder with properties {name:item 1 of a}
end
end
end
END
