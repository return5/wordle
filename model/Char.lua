local Output <const> = require('io.Output')
local setmetatable <const> = setmetatable
local ncurse   <const> = require("ncurses.sluacurses")

local Char <const> = {}
Char.__index = Char
_ENV = Char

function Char:print(x,y,w)
	Output:print(x,y,self.char,self.color,w)
end

function Char:new(char,color)
	return setmetatable({char = char,color = color},self)
end

return Char