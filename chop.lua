function Refuel()
    function BruteRefuel()
        for i=1, 16 do
            if turtle.getItemCount(i) > 0 then
                local itemDetail = turtle.getItemDetail(i)
                if itemDetail and itemDetail.name == "minecraft:charcoal" then
                    turtle.select(i)
                    turtle.refuel(1) -- Refuel with coal
                    return true
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
            turtle.suckDown(64) -- Getting fuel from the chest
            if not BruteRefuel() then
                error("No fuel found in the chest or inventory!")
            end
            turtle.select(slct)
            turtle.forward()
            turtle.forward()
            turtle.down()
        end        
    end
end

function IsBlock(blockName)
    local success, data = turtle.inspect()
    if not success then
        return blockName == "air"
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

function CheckNotEmpty()
    if turtle.getItemCount() == 0 then
        local slct = turtle.getSelectedSlot()
        error("Slot " .. slct .. " is empty!")
    end
end

function Select(name)
    for i = 1, 16 do
        if turtle.getItemDetail(i) and turtle.getItemDetail(i).name == name then
            turtle.select(i)
            return true
        end
    end
    return false
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
    elseif Select("minecraft:birch_sapling") then
        turtle.place()
    end
    sleep(1)
end