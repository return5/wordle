require("ncurses.sluacurses")

local write <const> = mvprintw
local windowWrite <const> = mvwprintw
local wrefresh <const> = wrefresh
local wattron <const> = wattron
local wattroff <const> = wattroff
local color_pair <const> = COLOR_PAIR
local clear <const> = clear
local refresh <const> = refresh
local move <const> = move
local wborder <const> = wborder
local newwin <const> = newwin
local wclear <const> = wclear

local Output <const> = {}
Output.__index = Output
_ENV = Output

function Output:move(x,y)
	move(y,x)
end

function Output:clear()
	clear()
	refresh()
end

function Output:printLine(x,y,line)
	write(y,x,line)
end

function Output:wRefresh(w)
	wrefresh(w)
end

function Output:wClear(w)
	wclear(w)
end

function Output:wPutChar(w,x,y,char)
	windowWrite(w,y,x,char)
end

function Output:print(x,y,char,color,w)
	wattron(w,color_pair(color))
	windowWrite(w,y,x,char)
	wattroff(w,color_pair(color))
	wrefresh(w)
end

function Output:newWin(x,y,height,width)
	return newwin(height,width,y,x)
end

function Output:wBorder(w)
	wborder(w,"|","|","-","-","+","+","+","+")  --create border around window 'w'
end

function Output:newWindow(x,y,height,width)
	local w <const> = self:newWin(x,y,height,width)
	self:wBorder(w)
	self:wRefresh(w)
	return w
end

return Output
