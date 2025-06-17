while true do
    local event, side, channel, replyChannel, message, distance
    repeat
    event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    until channel == 1
    if not turtle.detectDown() then
        turtle.down()
    end
end