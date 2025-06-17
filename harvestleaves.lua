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
    
    BreakTriplet()
    turtle.turnLeft()
    BreakTriplet()
    turtle.turnLeft()
    BreakTriplet()
    BreakTriplet()
    turtle.turnLeft()
    BreakTriplet()
    BreakTriplet()
    turtle.turnLeft()
    BreakTriplet()
    BreakTriplet()
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
    Modem.transmit(replyChannel, 1, false)
end