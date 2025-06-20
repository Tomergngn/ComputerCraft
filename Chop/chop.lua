Locator = {}
Locator.__index = Locator

function Locator:create()
    local self = {}
    setmetatable(self, Locator)
    self.upMov = 0
    self.rightRot = 0
    self.backMov = 0
    return self
end

function Locator:update()
    SaveState:write(self.rightRot .. "\n" .. self.backMov .. "\n" .. self.upMov .. "\n")
    SaveState:flush()
    end

function Locator:forward()
    if turtle.forward() then
        self.backMov = self.backMov - 1
        self:update()
        return true
    end
    return false
end
function Locator:back()
    if turtle.back() then
        self.backMov = self.backMov + 1
        self:update()
        return true
    end
    return false
end
function Locator:up()
    if turtle.up() then
        self.upMov = self.upMov + 1
        self:update()
        return true
    end
    return false
end
function Locator:down()
    if turtle.down() then
        self.upMov = self.upMov - 1
        self:update()
        return true
    end
    return false
end
function Locator:turnLeft()
    turtle.turnLeft()
    self.rightRot = (self.rightRot - 1) % 4
    self:update()
end
function Locator:turnRight()
    turtle.turnRight()
    self.rightRot = (self.rightRot + 1) % 4
    self:update()
end

local myLocator = Locator:create()

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
            if not myLocator:up() then
                turtle.digUp()
                myLocator:up()
                myLocator:turnLeft()
                myLocator:turnLeft()
                turtle.dig()
                myLocator:turnLeft()
                myLocator:turnLeft()
            end
            myLocator:back()
            myLocator:back()
            turtle.suckDown(62)
            myLocator:back()
            turtle.suckDown(64) -- Getting fuel from the chest
            local dlyr = not BruteRefuel()
            turtle.select(slct)
            myLocator:forward()
            myLocator:forward()
            myLocator:forward()
            myLocator:down()
            if dlyr then
                error("No fuel found in the chest or inventory!")
            end
        end
    end
end

function GetBoneMeal()
    if not myLocator:up() then
        turtle.digUp()
        myLocator:up()
        myLocator:turnLeft()
        myLocator:turnLeft()
        turtle.dig()
        myLocator:turnLeft()
        myLocator:turnLeft()
    end
    myLocator:back()
    myLocator:back()
    turtle.suckDown(62)
    myLocator:forward()
    myLocator:forward()
    myLocator:down()
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
        until channel == 2
        harvestingLeaves = message
        sleep(1)
    end
end

function MainLoop()
while true do
    Refuel()
    if not harvestingLeaves then
        if IsBlock("minecraft:birch_log") then -- Checking if the tree grew:
            turtle.dig()
            myLocator:forward()
            local height = 2
            turtle.digUp()
            myLocator:up()
            turtle.digUp()
            myLocator:up()
            while IsBlockUp("minecraft:birch_log") do
                turtle.digUp()
                myLocator:up()
                height = height + 1
            end
            Modem.transmit(1, 2, true)
            harvestingLeaves = true
            for _ = 1, height do
                myLocator:down()
            end
            myLocator:back()
        elseif IsBlock("minecraft:birch_sapling") then
            local cnt = Count("minecraft:bone_meal")
            if cnt > 1 then
                for i=1, 16 do
                    if turtle.getItemDetail(i) and turtle.getItemDetail(i).name == "minecraft:bone_meal" then
                        if turtle.getItemCount(i) == cnt then
                            cnt = cnt - 1 
                        end
                        turtle.select(i)
                        for _=1, cnt do
                            turtle.place()
                            if IsBlock("minecraft:birch_log") then break end
                        end
                        if IsBlock("minecraft:birch_log") then break end
                    end
                end
            else 
                GetBoneMeal()
            end
        elseif Select("minecraft:birch_sapling") then -- Placing a sapling if there is no tree
            turtle.place()
        end
    end

    turtle.suckUp() -- Act as another hopper
    turtle.suck()

    -- If the turtle filled up, it will drop items to the chests
    if WoodSlots() > 0 then
        myLocator:down()
        myLocator:turnRight()
        local cnt = Count("minecraft:birch_sapling")
        for i = 1, 16 do
            if turtle.getItemCount(i) > 0 then
                local itemDetail = turtle.getItemDetail(i)
                if itemDetail then
                    if itemDetail.name == "minecraft:birch_log" then
                        turtle.select(i)
                        turtle.drop() -- Dropping birch logs to the chest on the right
                    elseif itemDetail.name == "minecraft:stick" then
                        turtle.select(i)
                        turtle.dropDown() -- Dropping sticks to the chest on the bottom
                    elseif itemDetail.name == "minecraft:birch_sapling" and cnt > 64 then
                        cnt = cnt - itemDetail.count
                        turtle.select(i)
                        turtle.dropDown() -- Dropping other items to the chest in front of the turtle
                    end
                end
            end
        end
        myLocator:turnLeft()
        myLocator:up()
    end
    sleep(0.2)
end
end
SaveState = io.open("savestate", "w")
Modem = peripheral.find("modem") or error("No modem attached", 0)
Modem.open(2)
harvestingLeaves = false
parallel.waitForAny(Listen, MainLoop)