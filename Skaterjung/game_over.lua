-- Display game-over screen
function game_over()

    -- Purple background
    love.graphics.clear(150/255, 129/255, 182/255, 255/255)

    love.graphics.setFont(large_font)

    -- Black text color
    love.graphics.setColor(0, 0, 0, 1)

    -- Render text
    love.graphics.printf('Game Over\n\n\n\n\nYou can restart and try again\n\nPress ESC to quit', math.floor(map.camX), 55, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Your score is ' .. math.floor(skater.x), math.floor(map.camX), 90, VIRTUAL_WIDTH, 'center')
end