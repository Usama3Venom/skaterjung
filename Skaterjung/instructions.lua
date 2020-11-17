-- Display the instructions
function instructions()

    -- Purple background
    love.graphics.clear(150/255, 129/255, 182/255, 255/255)

    love.graphics.setFont(small_font)

    -- Black text color
    love.graphics.setColor(0, 0, 0, 1)

    -- Render instructions
    love.graphics.print("Welcome to Skaterjung!\n\n\n\nYou can't stop the skater, but you can accelerate by pressing D, or decelerate by pressing A.\n\nYou jump by pressing the space bar.\n\nAt any point, you can press the ESC button or ALT+F4 to quit.\n\nYou start playing by hitting the space bar or D.\n\nYou should avoid all obstacles (even the flagpole near the end) until you reach the end.\n\nHave fun!", 2, 2)
    
    love.graphics.setFont(large_font)

    -- Render Back button
    love.graphics.printf('Back', 0, 200, VIRTUAL_WIDTH, 'center')

    -- Render a rectangle around the Back button
    love.graphics.rectangle('line', 188, 197, 53, 24)
end