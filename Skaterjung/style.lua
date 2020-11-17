-- Display styles
function style()

    -- Purple background
    love.graphics.clear(150/255, 129/255, 182/255, 255/255)

    love.graphics.setFont(small_font)

    -- Black text color
    love.graphics.setColor(0, 0, 0, 1)

    love.graphics.setFont(large_font)

    -- Render style info and buttons
    love.graphics.printf('Background:   Dark     Light\n\n\nTheme:         Normal   Trippy', 5, 5, VIRTUAL_WIDTH, 'left')

    -- Render Back button
    love.graphics.printf('Back', 0, 200, VIRTUAL_WIDTH, 'center')

    -- Render a rectangle around the button chosen

    -- Dark rectangle
    if style_pointer == 'dark' then
        love.graphics.rectangle('line', 161, 2, 53, 24)

    -- Light rectangle
    elseif style_pointer == 'light' then
        love.graphics.rectangle('line', 260, 2, 56, 26)

    -- Normal rectangle
    elseif style_pointer == 'normal' then
        love.graphics.rectangle('line', 161, 62, 73, 24)

    -- Trippy rectangle
    elseif style_pointer == 'trippy' then
        love.graphics.rectangle('line', 260, 62, 67, 26)

    -- Back rectangle
    elseif style_pointer == 'back' then
        love.graphics.rectangle('line', 188, 197, 53, 24)
    end
end