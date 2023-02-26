local ReadFile <const> = require('auxiliary.ReadFile')
local Output <const> = require('io.Output')
local Input <const> = require("io.Input")
local Char <const> = require('model.Char')
local NcurseAux <const> = require('ncurses.NcursesAux')
local Screen <const> = require('model.Screen')
local concat <const> = table.concat

local colors <const> = {
	black = 1,
	green = 2,
	yellow = 3,
	white = 4
}

--pre-allocate white characters for all english alphabet letters and the space character.
local function makeDefaultChars()
	local chars = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"," "}
	local tbl <const> = {}
	for i=1,#chars,1 do
		tbl[chars[i]] = Char:new(chars[i],colors.white)
	end
	return tbl
end

local defaultChars <const> = makeDefaultChars()

--go over the word the user has guessed and check if it matches with the correct word.
local function checkMatch(str,wArr,wDic,window)
	local greenCount = 0
	for i=0,4,1 do
		--for each individual character in the word
		local char <const> = str[i + 1]
		--if the character is in the word
		if wDic[char] then
			--if the character at the same location in the correct word is the same as the current character
			if wArr[i + 1] == char then
				Char:new(char,colors.green):print(i * 2 + 1,1,window)
				greenCount = greenCount + 1
			else
				--character is correct, but in incorrect location
				Char:new(char,colors.yellow):print(i * 2 + 1,1,window)
			end
		end
	end
	return greenCount
end

local function gameOver(word)
	Output:printLine(1,12,"Sorry, you lost this round. the correct word was: " .. word)
end

local function gameWon()
	Output:printLine(1,12,"Congratulations, you won this round.")
end

local function getNewGame()
	Output:printLine(1,13,"would you like to try a new word?(y/n)")
	local choice = Input:readInput()
	return choice == "y" or choice == "Y"
end

local function getInput(wordDict,cont,window,msgWindow)
	local x = -1
	local str <const> = {}
	local i = 0
	repeat
		local input = Input:readInput()
		Output:wClear(msgWindow)
		Output:wRefresh(msgWindow)
		--if user pressed backspace and we have atleast one character already
		if input:byte() == 127 and i > 0 then
			--replace current char with empty space
			defaultChars[" "]:print(x,1,window)
			str[i] = ""
			x = x - 2
			i = i -1
		--if user enters a non space character and we have less than 5 characters already entered.
		elseif i < 5 and defaultChars[input] and input ~= " " then
			x = x + 2
			i = i + 1
			defaultChars[input]:print(x,1,window)
			str[i] = input
		--when user pressed enter.
		elseif input == "\n" then
			if i < 5 then
				Output:wPutChar(msgWindow,1,1,"Sorry,word is too short.")
				Output:wRefresh(msgWindow)
			elseif i == 5 and not wordDict[concat(str)] then
				Output:wPutChar(msgWindow,1,1,"Sorry,word is not in dictionary.")
				Output:wRefresh(msgWindow)
			elseif i == 5 and wordDict[concat(str)] then
				return str
			end
		end
	until input == ";"
	cont[1] = false
	return str
end

local function gameLoop(wArr,wDic,wordDict,screens,msgWindow)
	--each word the user has guessed
	local rep <const> = string.rep
	local y = 1
	local cont = {true}
	Output:move(0,y)
	repeat
		--only allow 5 tries to get the word
		if y > 5 then
			gameOver(concat(wArr))
			break
		end
		local str <const> = getInput(wordDict,cont,screens[y],msgWindow)
		if cont[1] then
			local count <const> = checkMatch(str,wArr,wDic,screens[y])
			--if all five of the characters in the word match then the user won this round.
			if count == 5 then
				gameWon()
				break
			end
			y = y + 1
			Output:move(0,y)
		end
	until not cont[1]
	return getNewGame()
end

--get a random word from the list of words.
local function getWord(f)
	local word <const> = f[math.random(#f)]
	--hold each individual character of the word as an in order array of characters.
	local wArr <const> = {}
	--holds each individual character of the word as a key in a table
	local wDic <const> = {}
	--for each individual character in the word
	for char in word:gmatch(".") do
		wArr[#wArr + 1] = char
		wDic[char] = true
	end
	return wArr,wDic
end


local function clearScreen(screen)
	Output:clear()
	for i=1,#screen,1 do
		Output:wClear(screen[i])
		Screen:makeBorder(screen[i])
		Screen:printDividers(screen[i])
	end
end

local function main()
	math.randomseed(os.time())
	local wordDict, wordList <const>  = ReadFile("assets/words.txt","(%a+),?",true,"%a+","%a+")
	NcurseAux.initNcurses()
	NcurseAux.initColors(colors)
	local screen,msgWindow <const> = Screen:initScreen()
	repeat
		local wArr,wDict <const> = getWord(wordList)
		local cont <const> = gameLoop(wArr,wDict,wordDict,screen,msgWindow)
		clearScreen(screen)
	until not cont
	NcurseAux:endNcurses()
end

main()
