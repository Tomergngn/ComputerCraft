local filename = "chop.lua"

shell.run("delete " .. filename)
shell.run("wget https://github.com/Tomergngn/ComputerCraft/blob/main/" .. filename .. " " .. filename)
local fileRead = io.open(filename, "r")
local filestr = nil
if fileRead then
	filestr = fileRead:read("*a")
	fileRead:close()
else
	error("Failed to open file: " .. filename)
end
local start, _ = string.find(filestr, "rawLines", 1)
start = start + 12
local bracketCount = 1
local finish = start
while true do
    local char = string.sub(filestr,finish, finish)
    if char == "[" then
        bracketCount = bracketCount + 1
    elseif char == "]" then
        bracketCount = bracketCount - 1
        if bracketCount == 0 then
            break
        end
    end
    finish = finish + 1
end
if finish == start then
    error("No rawLines found in the file.")
end
filestr = string.sub(filestr, start, finish - 2)
filestr = string.gsub(filestr, "\",\"", "\n")
-- Making characters such as \u003c readable by converting all "\u" to "\x" and then converting the hex code to a character:
filestr = string.gsub(filestr, "\\u(%x%x%x%x)", function(hex)
    return string.char(tonumber(hex, 16))
end)

local fileWrite = io.open(filename, "w")
if fileWrite then
    fileWrite:write(filestr)
    fileWrite:close()
else
    error("Failed to write to file: " .. filename)
end