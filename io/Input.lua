require("ncurses.sluacurses")

local read <const> = getch

local Input <const> = {}
Input.__index = Input
_ENV = Input


function Input:readInput()
	return read()
end

return Input
