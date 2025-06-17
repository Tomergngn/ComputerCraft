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

local start = filestr:find("z-index: 1;\">", 1, true)
start = start + #("z-index: 1;\">")

local finish = filestr:find("</textarea>", start, true)

filestr = filestr:sub(start, finish - 1)
local fileWrite = io.open(filename, "w")
if fileWrite then
    fileWrite:write(filestr)
    fileWrite:close()
else
    error("Failed to write to file: " .. filename)
end