-- This file contains the function to create quads

function generateQuads(atlas, tileWidth, tileHeight)

    -- Calculate spritesheet size tile-wise
    local sheetWidth_tilewise = atlas:getWidth() / tileWidth
    local sheetHeight_tilewise = atlas:getHeight() / tileHeight
    
    -- Table which holds the quads
    quads = {}

    -- The number used to index into the quads table
    sheetCounter = 1

    -- Chop up the spritesheet and populate the quads table
    for y = 0, sheetHeight_tilewise - 1 do
        for x = 0, sheetWidth_tilewise - 1 do
            quads[sheetCounter] = love.graphics.newQuad(
                                      x * tileWidth, y * tileHeight,
                                      tileWidth, tileHeight, atlas:getDimensions()
                                  )
            sheetCounter = sheetCounter + 1
        end
    end

    return quads
end