local Locator = {}
Locator.new = function()
    local self = {}

    self.upMov = 0
    self.rightRot = 0
    self.backMov = 0
    self.leftMov = 0

    self.update = function() SaveState:write(self.rightRot .. "\n" .. self.backMov .. "\n" .. self.leftMov .. "\n" .. self.upMov .. "\n") SaveState:flush() end

    self.forward = function()
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
            self.update()
            return true
        end
        return false
    end
    self.back = function()
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
            self.update()
            return true
        end
        return false
    end
    self.up = function()
        if turtle.up() then
            self.upMov = self.upMov + 1
            self.update()
            return true
        end
        return false
    end
    self.down = function()
        if turtle.down() then
            self.upMov = self.upMov - 1
            self.update()
            return true
        end
        return false
    end
    self.turnLeft = function()
        Locator.turnLeft()
        self.rightRot = (self.rightRot - 1) % 4
        self.update()
    end
    self.turnRight = function()
        turtle.turnRight()
        self.rightRot = (self.rightRot + 1) % 4
        self.update()
    end
    return self
end

function BreakLeaves()
    function BreakTriplet()
        turtle.dig()
        turtle.forward()
        turtle.digUp()
        turtle.digDown()
    end
    function BreakDouble()
        turtle.dig()
        turtle.forward()
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
    turtle.turnLeft()
    BreakTriplet()

    for _=1, 3 do
        turtle.turnLeft()
        BreakTriplet()
        BreakTriplet()
    end

    BreakDouble()

    turtle.turnLeft()
    BreakDouble()
    BreakDouble()
    BreakDouble()

    for _=1, 3 do
        turtle.turnLeft()
        BreakDouble()
        BreakDouble()
        BreakDouble()
        BreakDouble()
    end

    turtle.turnLeft()
    turtle.forward()
    turtle.forward()
    turtle.turnRight()

    for i = 1, 16 do
        if turtle.getItemDetail(i) then
            turtle.select(i)
            turtle.dropDown()
        end
    end

    for _=1, (3+shortTree) do turtle.up() end
    turtle.back()
    turtle.back()
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