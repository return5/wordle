local open   = io.open
local gmatch = string.gmatch
local setmetatable = setmetatable
local error = error

local ReadFile = {}

_ENV = ReadFile

local function makeKeyValue(match,t,keyPat,valuePat)
    local key = match:match(keyPat)
    local value = match:match(valuePat)
    t[key] = value
end

local function getContents(file,pat,keyValue,keyPat,valuePat)
    local tbl = {}
    local list = {}
    local makeValue =  keyValue and function(match,t) makeKeyValue(match,t,keyPat,valuePat)  end or function(match,t) t[#t + 1] = match end
    for match in gmatch(file:read("a*"),pat) do
        makeValue(match,tbl)
        list[#list + 1] = match
    end
        return tbl,list
end

--read a file and put the contents into a table.
--table is parsed based on pat.
--if readonly is true then make resulting table a readOnly table.
--if keyValue is true then file is treated as a list of key value pairs.
--if text is a list of key,value pairs then keyPat is pattern to find the keys.
--if text is a list of key,value pairs then valuePat is pattern to find the values.
local function new(__,filePath,pat,keyValue,keyPat,valuePat)
    if not filePath then error("filepath is nil\n") end
    local file = open(filePath,"r")
    if not file then error("could not open file at: "..filePath .. "\n") end
    local contents,list = getContents(file,pat,keyValue,keyPat,valuePat)
    file:close()
    return contents,list
end


return setmetatable(ReadFile,{__index = ReadFile,__call = new})
