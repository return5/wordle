require("ncurses.sluacurses")
local initscr <const> = initscr
local refresh <const> = refresh
local endwin <const> = endwin
local curs_set <const> = curs_set
local start_color <const> = start_color
local init_color <const> = init_color
local init_pair <const> = init_pair
local COLOR_BLACK <const> = COLOR_BLACK
local COLOR_WHITE <const> = COLOR_WHITE
local COLOR_GREEN <const> = COLOR_GREEN
local COLOR_YELLOW <const> = COLOR_YELLOW
local cbreak <const> = cbreak
local noecho <const> = noecho


local NcursesAux   <const> = {}
NcursesAux.__index = NcursesAux

_ENV = NcursesAux

function NcursesAux:initNcurses()
    initscr()
    cbreak()  --disable line buffering
    noecho() --dont show user input on screen
    curs_set(0)  --dont show cursor
    refresh()
end

function NcursesAux.initColors(colors)
    start_color()
    init_color(COLOR_YELLOW,700,700,98)
    init_color(COLOR_WHITE,1000,1000,1000)
    init_pair(colors.black,COLOR_BLACK,COLOR_BLACK)
    init_pair(colors.white,COLOR_WHITE,COLOR_BLACK)
    init_pair(colors.green,COLOR_GREEN,COLOR_BLACK)
    init_pair(colors.yellow,COLOR_YELLOW,COLOR_BLACK)
end

function NcursesAux:endNcurses()
    endwin()
end

return NcursesAux

