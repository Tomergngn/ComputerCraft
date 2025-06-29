function Refuel()
    function BruteRefuel()
        for i=1, 16 do
            if turtle.getItemCount(i) > 0 then
                local itemDetail = turtle.getItemDetail(i)
                if itemDetail and (itemDetail.name == "minecraft:charcoal" or itemDetail.name == "minecraft:coal") then
                    turtle.select(i)
                    return turtle.refuel()
                end
            end
        end
        return false
    end
    if turtle.getFuelLevel() < 25 then
        if not BruteRefuel() then
            turtle.down()
            turtle.turnRight()
            turtle.forward()
            turtle.turnLeft()
            for _=1, 4 do turtle.forward() end
            for _=1, 3 do turtle.up() end
            turtle.suckUp(64) -- Getting fuel from the chest
            local dlyr = not BruteRefuel()
            for _=1, 3 do turtle.down() end
            for _=1, 4 do turtle.back() end
            turtle.turnRight()
            turtle.back()
            turtle.turnLeft()
            turtle.up()
            if dlyr then
                error("No fuel found in the chest or inventory!")
            end
        end
    end
end

local function Listen()
    local event, side, channel, replyChannel, message, distance
    while true do
        repeat
            event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
        until channel == 43
        harvestingLeaves = message
        sleep(1)
    end
end

function MainLoop()
    while true do
        if not harvestingLeaves then
            Refuel()
            local _, furDtls = turtle.inspect()
            if not furDtls.state.lit then
                turtle.up()
                turtle.suck(64)
                if turtle.getItemCount() > 15 then
                    turtle.drop(turtle.getItemCount() - 15)
                end
                turtle.down()
                turtle.craft()
                turtle.drop()
                local cnt = turtle.getItemCount()
                if cnt > 0 then
                    sleep(1.5*cnt)
                    turtle.drop()
                end
            end
        end
        sleep(0.2)
    end
end

harvestingLeaves = false
parallel.waitForAny(Listen, MainLoop)