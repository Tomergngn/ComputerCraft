function Split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

local fileRead = io.open("savestate.txt", "r")
local filestr = nil
if fileRead then
	filestr = fileRead:read("*a")
	fileRead:close()
else
	error("Failed to open Save State")
end
local saveData = Split(filestr, "\n")
for _=1, saveData[1] do -- Right rotation
    turtle.turnLeft()
end
for _=1, saveData[2] do -- Back movement
    turtle.forward()
end
if saveData[3] < 0 then -- Up/Down Movement
    for _=1, -saveData[3] do
        turtle.up()
    end
else
    for _=1, saveData[3] do
        turtle.down()
    end
end
local fileWrite = io.open("savestate.txt", "w")
if fileWrite then
    fileWrite:write("0\n0\n0\n") -- Resetting the save state
    fileWrite:close()
else
    error("Failed to write to Save State")
end
shell.run("chop.lua")