local Output <const> = require('io.Output')

local Screen <const> = {}
Screen.__index = Screen
_ENV = Screen

function Screen:printDividers(window)
	for j=2,11,2 do
		Output:wPutChar(window,j,1,"|")
	end
	Output:wRefresh(window)
end

function Screen:makeBorder(window)
	Output:wBorder(window)
end

function Screen:initScreen()
	local windows <const> = {}
	local y = -1
	for i=1,5,1 do
		y = y + 2
		windows[i] = Output:newWindow(2,y,3,11)
		self:printDividers(windows[i])
	end
	return windows,Output:newWin(0,0,1,32)
end


return Screen