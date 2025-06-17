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
            turtle.select(13)
            turtle.turnLeft()
            turtle.turnLeft()
            turtle.suck(64) -- Getting fuel from the chest
            if not BruteRefuel() then
                error("No fuel found in the chest or inventory!")
            end
            turtle.turnLeft()
            turtle.turnLeft()
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
        return blockName == "air"
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
    if IsBlock("minecraft:oak_log") then -- Checking if the tree grew:
        turtle.dig()
        turtle.forward()
        local height = 0
        while not IsBlockUp("minecraft:oak_leaves") do
            turtle.digUp()
            turtle.up()
            height = height + 1
        end
        for i = 1, height do
            turtle.down()
        end
        turtle.back()

        if Select("minecraft:oak_sapling") then -- Selecting sapling
            turtle.placeDown()
        end
    end
    sleep(1) -- Wait for a second before checking again
end