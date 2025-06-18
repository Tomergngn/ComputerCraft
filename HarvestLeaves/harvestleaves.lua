local Locator = {}

function Locator:update()
    SaveState:write(self.rightRot .. "\n" .. self.backMov .. "\n" .. self.upMov .. "\n")
    SaveState:flush()
end

function Locator:forward()
    if turtle.forward() then
        if self.rightRot == 0 then
            self.backMov = self.backMov - 1
        elseif self.rightRot == 1 then
            self.leftMov = self.leftMov - 1
        elseif self.rightRot == 2 then
            self.backMov = self.backMov + 1
        elseif self.rightRot == 3 then
            self.leftMov = self.leftMov + 1
        end
        Locator:update()
        return true
    end
    return false
end
function Locator:back()
    if turtle.back() then
        if self.rightRot == 0 then
            self.backMov = self.backMov + 1
        elseif self.rightRot == 1 then
            self.leftMov = self.leftMov + 1
        elseif self.rightRot == 2 then
            self.backMov = self.backMov - 1
        elseif self.rightRot == 3 then
            self.leftMov = self.leftMov - 1
        end
        Locator:update()
        return true
    end
    return false
end
function Locator:up()
    if turtle.up() then
        Locator.upMov = Locator.upMov + 1
        Locator:update()
        return true
    end
    return false
end
function Locator:down()
    if turtle.down() then
        Locator.upMov = Locator.upMov - 1
        Locator:update()
        return true
    end
    return false
end
function Locator:turnLeft()
    turtle.turnLeft()
    Locator.rightRot = (Locator.rightRot - 1) % 4
    Locator:update()
end
function Locator:turnRight()
    turtle.turnRight()
    Locator.rightRot = (Locator.rightRot + 1) % 4
    Locator:update()
end
function BreakLeaves()
    function BreakTriplet()
        turtle.dig()
        Locator:forward()
        turtle.digUp()
        turtle.digDown()
    end
    function BreakDouble()
        turtle.dig()
        Locator:forward()
        turtle.digDown()
    end
    local shortTree = 0
    while not turtle.detectDown() do
        shortTree = shortTree + 1
        turtle.down()
    end
    turtle.digDown()
    for _=1, 3 do turtle.down() end
    
    BreakTriplet()
    Locator:turnLeft()
    BreakTriplet()

    for _=1, 3 do
        Locator:turnLeft()
        BreakTriplet()
        BreakTriplet()
    end

    BreakDouble()

    Locator:turnLeft()
    BreakDouble()
    BreakDouble()
    BreakDouble()

    for _=1, 3 do
        Locator:turnLeft()
        BreakDouble()
        BreakDouble()
        BreakDouble()
        BreakDouble()
    end

    Locator:turnLeft()
    Locator:forward()
    Locator:forward()
    Locator:turnRight()

    for i = 1, 16 do
        if turtle.getItemDetail(i) then
            turtle.select(i)
            turtle.dropDown()
        end
    end

    for _=1, (3+shortTree) do turtle.up() end
    Locator:back()
    Locator:back()
end

SaveState = io.open("savestate.txt", "w")
Modem = peripheral.find("modem") or error("No modem attached", 0)
Modem.open(1)

while true do
    local event, side, channel, replyChannel, message, distance
    repeat
    event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    until channel == 1

    Modem.transmit(replyChannel, 1, true)
    BreakLeaves()
    Modem.transmit(replyChannel, 1, false)
end