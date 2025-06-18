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
    for _=1, (3+shortTree) do turtle.up() end
    turtle.back()
    turtle.back()
end

Modem = peripheral.find("modem") or error("No modem attached", 0)
Modem.open(1)

while true do
    local event, side, channel, replyChannel, message, distance
    repeat
    event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    until channel == 1
    Modem.transmit(replyChannel, 1, true)
    BreakLeaves()

    for i = 1, 16 do
        if turtle.getItemDetail(i) then
            turtle.select(i)
            turtle.dropDown()
        end
    end
    Modem.transmit(replyChannel, 1, false)
end