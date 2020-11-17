-- Display the start menu
function main_menu()
    
    -- Purple background
    love.graphics.clear(150/255, 129/255, 182/255, 255/255)

    -- Draw the big title
    love.graphics.draw(title, 16, 0)

    -- Black text color
    love.graphics.setColor(0, 0, 0, 1)

    love.graphics.setFont(large_font)

    -- Render the main menu buttons
    love.graphics.printf('Play', 0, 115, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Style', 0, 150, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Instructions', 0, 185, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Exit', 0, 220, VIRTUAL_WIDTH, 'center')

    -- Render a rectangles around the button chosen

    -- Play rectangle
    if menu_pointer == 'play' then
        love.graphics.rectangle('line', 190, 113, 49, 25)

    -- Style rectangle
    elseif menu_pointer == 'style' then
        love.graphics.rectangle('line', 185, 148, 59, 25)

    -- Instructions rectangle
    elseif menu_pointer == 'instructions' then
        love.graphics.rectangle('line', 145, 182, 137, 23)

    -- Exit rectangle
    elseif menu_pointer == 'exit' then
        love.graphics.rectangle('line', 194, 218, 41, 21)
    end
end
