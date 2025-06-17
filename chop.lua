function Refuel()
    function BruteRefuel()
        for i=1, 16 do
            if turtle.getItemCount(i) > 0 then
                local itemDetail = turtle.getItemDetail(i)
                if itemDetail and itemDetail.name == "minecraft:charcoal" then
                    turtle.select(i)
                    return turtle.refuel()
                end
            end
        end
        return false
    end
    if turtle.getFuelLevel() < 20 then
        if not BruteRefuel() then
            local slct = turtle.getSelectedSlot()
            if not turtle.up() then
                turtle.digUp()
                turtle.up()
                turtle.turnLeft()
                turtle.turnLeft()
                turtle.dig()
                turtle.turnLeft()
                turtle.turnLeft()
            end
            turtle.back()
            turtle.back()
            turtle.suckDown(62)
            turtle.back()
            turtle.suckDown(64) -- Getting fuel from the chest
            local dlyr = not BruteRefuel()
            turtle.select(slct)
            turtle.forward()
            turtle.forward()
            turtle.forward()
            turtle.down()
            if dlyr then
                error("No fuel found in the chest or inventory!")
            end
        end
    end
end

function GetBoneMeal()
    if not turtle.up() then
        turtle.digUp()
        turtle.up()
        turtle.turnLeft()
        turtle.turnLeft()
        turtle.dig()
        turtle.turnLeft()
        turtle.turnLeft()
    end
    turtle.back()
    turtle.back()
    turtle.suckDown(62)
    turtle.forward()
    turtle.forward()
    turtle.down()
end

function IsBlock(blockName)
    local success, data = turtle.inspect()
    if not success then
        return blockName == "minecraft:air"
    end
    return data.name == blockName
end

function IsBlockUp(blockName)
    local success, data = turtle.inspectUp()
    if not success then
        return blockName == "minecraft:air"
    end
    return data.name == blockName
end

function Find(name)
    for i = 1, 16 do
        if turtle.getItemDetail(i) and turtle.getItemDetail(i).name == name then
            return i
        end
    end
    return 0
end

function Count(name)
    local cnt = 0
    for i = 1, 16 do
        if turtle.getItemDetail(i) and turtle.getItemDetail(i).name == name then
            cnt = cnt + turtle.getItemCount(i)
        end
    end
    return cnt
end

function FreeSlots()
    local cnt = 0
    for i = 1, 16 do
        if turtle.getItemCount(i) == 0 then
            cnt = cnt + 1
        end
    end
    return cnt
end

function WoodSlots()
    local cnt = 0
    for i = 1, 16 do
        if turtle.getItemDetail(i) then
            local itemDetail = turtle.getItemDetail(i)
            if itemDetail.name == "minecraft:birch_log" or (itemDetail.name == "minecraft:stick" and itemDetail.count >= 2) then
                cnt = cnt + 1
            end
        end
    end
    return cnt
end

function Select(name)
    local tmp = Find(name)
    if tmp == 0 then return false end
    turtle.select(Find(name))
    return true
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
    Refuel()
    if IsBlock("minecraft:birch_log") then -- Checking if the tree grew:
        turtle.dig()
        turtle.forward()
        local height = 2
        turtle.digUp()
        turtle.up()
        turtle.digUp()
        turtle.up()
        while not IsBlockUp("minecraft:birch_leaves") do
            turtle.digUp()
            turtle.up()
            height = height + 1
        end
        for _ = 1, height do
            turtle.down()
        end
        turtle.back()
    elseif IsBlock("minecraft:birch_sapling") then
        local cnt = turtle.getItemCount(1)
        if cnt > 1 then
            for _=2, cnt do
                if not Select("minecraft:bone_meal") then break end
                turtle.place()
                if IsBlock("minecraft:birch_log") then
                    modem.transmit(1, 2, "Hello, world!")
                    break
                end
            end
        else 
            GetBoneMeal()
        end
    elseif Select("minecraft:birch_sapling") then -- Placing a sapling if there is no tree
        turtle.place()
    end

    turtle.suckUp() -- Act as another hopper
    turtle.suck()

    -- If the turtle filled up, it will drop items to the chests
    local cnt = Count("minecraft:birch_sapling")
    if (cnt == 0 and WoodSlots() > 0) or FreeSlots() == 0 then
        turtle.down()
        turtle.turnRight()
        for i = 1, 16 do
            if turtle.getItemCount(i) > 0 then
                local itemDetail = turtle.getItemDetail(i)
                if itemDetail then
                    if itemDetail.name == "minecraft:birch_log" then
                        turtle.select(i)
                        turtle.drop(64) -- Dropping birch logs to the chest on the right
                    elseif itemDetail.name == "minecraft:stick" and itemDetail.count >= 2 then
                        turtle.select(i)
                        turtle.dropDown(itemDetail.count - (itemDetail.count%2)) -- Dropping sticks to the chest below
                    elseif itemDetail.name == "minecraft:birch_sapling" and cnt > 64 then
                        cnt = cnt - itemDetail.count
                        turtle.select(i)
                        turtle.dropDown(64) -- Dropping other items to the chest in front of the turtle
                    end
                end
            end
        end
        turtle.turnLeft()
        turtle.up()
    end
    sleep(0.2)
end
end

local modem = peripheral.find("modem") or error("No modem attached", 0)
harvestingLeaves = false
parallel.waitForAny(Listen, MainLoop)