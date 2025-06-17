-- Checking if the tree grew:
turtle.select(16)
if turtle.compare() then
    turtle.dig()
    turtle.forward()
    turtle.select(15)
    local height = 0
    while not turtle.compare() do
        turtle.digUp()
        turtle.up()
        height = height + 1
    end
    for i = 1, height do
        turtle.down()
    end
    turtle.back()
end