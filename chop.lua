function FuelUp()
    -- Check if the turtle has enough fuel
    if turtle.getFuelLevel() < 10 then
        local slct = turtle.getSelectedSlot()
        turtle.select(14)
        if not turtle.refuel() then
            debug_print("Not enough fuel! Please refuel the turtle.")
            turtle.select(slct)
            return false
        end
        turtle.select(slct)
        return true
    end
end

-- Checking if the tree grew:
turtle.select(16)
if turtle.compare() then
    turtle.dig()
    FuelUp()
    turtle.forward()
    turtle.select(15)
    local height = 0
    while not turtle.compareUp() do
        turtle.digUp()
        turtle.up()
        height = height + 1
    end
    for i = 1, height do
        turtle.down()
    end
    turtle.back()
end