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
    if turtle.getFuelLevel() < 100 then
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
            turtle.suckDown(64 - turtle.getItemCount(1))
            turtle.back()
            turtle.suckDown(64) -- Getting fuel from the chest
            if not BruteRefuel() then
                error("No fuel found in the chest or inventory!")
            end
            while turtle.suckDown(64) and BruteRefuel() do end
            turtle.select(slct)
            turtle.forward()
            turtle.forward()
            turtle.forward()
            turtle.down()
        end
    end
end

function GetBoneMeal()
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
    turtle.suckDown(64 - turtle.getItemCount(1))
    turtle.back()
    turtle.suckDown(64) -- Getting fuel from the chest
    if not BruteRefuel() then
        error("No fuel found in the chest or inventory!")
    end
    while turtle.suckDown(64) and BruteRefuel() do end
    turtle.select(slct)
    turtle.forward()
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
    local count = 0
    for i = 1, 16 do
        if turtle.getItemDetail(i) and turtle.getItemDetail(i).name == name then
            count = count + turtle.getItemCount(i)
        end
    end
    return count
end

function Select(name)
    local tmp = Find(name)
    if tmp == 0 then return false end
    turtle.select(Find(name))
    return true
end

Refuel()
while true do
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
    elseif IsBlock("minecraft:air") then
        if Select("minecraft:birch_sapling") then
            turtle.place()
        end
    end
    local cnt = turtle.getItemCount(1) -- Checking if we have bone meal:
    if cnt > 1 then
        turtle.select(1)
        for _=2, cnt do
            turtle.place()
            if IsBlock("minecraft:birch_log") then break end
        end
    else GetBoneMeal()end
    sleep(1)
end