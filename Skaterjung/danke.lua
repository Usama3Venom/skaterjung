-- Display victory message and thanks
function danke()

    -- Purple background
    love.graphics.clear(150/255, 129/255, 182/255, 255/255)

    love.graphics.setFont(large_font)

    -- Black text color
    love.graphics.setColor(0, 0, 0, 1)

    -- Render text
    love.graphics.printf('Victorious you are!\n\n' .. 'Your score is ' .. math.floor(skater.x), map.camX, 15, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(small_font)
    love.graphics.printf('You can restart and try again\n\n\nThis game was made by Usama Abdur-Rahman (Artour Tiger)\n\n\nSpecial thanks to\n\nDavid J. Malan\nColton Ogden\nBrian Yu\nDoug Lloyd\nTommy MacWilliam\n\n(and extra-special thanks to)', map.camX, 85, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(large_font)
    love.graphics.printf('Maria Muhammad', map.camX, 215, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(small_font)
    love.graphics.printf('Press ESC to quit', map.camX, 229, VIRTUAL_WIDTH - 5, 'right')
end