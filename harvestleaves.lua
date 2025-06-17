function BreakLeaves()
    function BreakTriplet()
        turtle.dig()
        turtle.forward()
        turtle.digUp()
        turtle.digDown()
    end
    local shortTree = 0
    if not turtle.detectDown() then
        shortTree = 1
        turtle.down()
    end
    turtle.digDown()
    turtle.down()
    turtle.down()
    turtle.down()
    turtle.down()
    for _=1, 4 do
        BreakTriplet()
        turtle.turnRight()
    end
    for i=1, 3 do
        for j=1, 4 do BreakTriplet() end
        turtle.turnRight()
    end
    BreakTriplet()
    turtle.turnRight()
    for _=1, 3 do BreakTriplet() end
    for i=1, 2 do
        turtle.turnLeft()
        for j=1, 2 do BreakTriplet() end
    end
    turtle.up()
    turtle.digUp()
    for _=1, (4+shortTree) do turtle.up() end
    turtle.turnLeft()
    turtle.forward()
    turtle.turnRight()
    turtle.back()
end

Modem = peripheral.find("modem") or error("No modem attached", 0)
while true do
    local event, side, channel, replyChannel, message, distance
    repeat
    event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    until channel == 1
    Modem.transmit(replyChannel, 1, true)
    BreakLeaves()
    Modem.transmit(replyChannel, 1, false)
end