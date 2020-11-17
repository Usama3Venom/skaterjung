-- This file contains map-related code

-- Create Map class
Map = Class{}

-- Import Animation class to use on the flag
require 'Animation'

-- Mappings of tiles
local TILE_EMPTY = 4
local TILE_BRICK = 1

local CLOUD_LEFT = 6
local CLOUD_RIGHT = 7

local COLUMN_TOP = 10
local COLUMN_BOTTOM = 11

local FLAGPOLE_TOP = 8
local FLAGPOLE_MIDDLE = 12
local FLAGPOLE_BOTTOM = 16

-- Camera speed
local SCROLL_SPEED = 230

function Map:init()
    
    -- Default theme is normal    
    self.spritesheet = love.graphics.newImage('graphics/spritesheet normal.png')
    
    self.tileWidth = 16
    self.tileHeight = 16
    self.mapWidth_tilewise = 2520
    self.mapHeight_tilewise = 16
    self.mapWidth_pixelwise = self.mapWidth_tilewise * self.tileWidth
    self.mapHeight_pixelwise = self.mapHeight_tilewise * self.tileHeight

    -- This table contains the tile mappings
    self.tiles = {}

    -- This variable contains the chopped-up quads
    self.tileSprites = generateQuads(self.spritesheet, self.tileWidth, self.tileHeight)

    -- Flagpole coordinates
    FLAGPOLE_x = self.mapWidth_tilewise - 3
    FLAGPOLE_BOTTOM_y = self.mapHeight_tilewise - 2 - 3

    self.flag_animation = Animation{
        sheet = self.spritesheet,
        quads = { self.tileSprites[13], self.tileSprites[14] },
        interval = 0.15
    }

    -- These variables are used in the camera auto-movement
    self.camX = 0
    self.camY = 0

    -- Populate top half of the map with empty tiles
    for y = 1, self.mapHeight_tilewise - 3 do
        for x = 1, self.mapWidth_tilewise do
            self:setTile(x, y, TILE_EMPTY)
        end
    end

    -- Populate bottom half of the map with bricks
    for y = self.mapHeight_tilewise - 2, self.mapHeight_tilewise do    
        for x = 1, self.mapWidth_tilewise do
            self:setTile(x, y, TILE_BRICK)
        end
    end

    -- Render flagpole just before the end
    self:setTile(FLAGPOLE_x, FLAGPOLE_BOTTOM_y + 2, FLAGPOLE_BOTTOM)
    self:setTile(FLAGPOLE_x, FLAGPOLE_BOTTOM_y + 1, FLAGPOLE_MIDDLE)
    self:setTile(FLAGPOLE_x, FLAGPOLE_BOTTOM_y, FLAGPOLE_TOP)

    -- Procedural Generation
    local x = 1
    while x < self.mapWidth_tilewise - 20 do

        -- 1/7 chance to render a cloud
        if math.random(7) == 1 then
            local cloudY = math.random(self.mapHeight_tilewise - 2 - 6)
            self:setTile(x, cloudY, CLOUD_LEFT)
            self:setTile(x + 1, cloudY, CLOUD_RIGHT)
        end
        
        -- 1/9 chance to render a small obstacle
        if math.random(9) == 1 and x > 8 and x < 500 then
            self:setTile(x, self.mapHeight_tilewise - 2 - 1, COLUMN_TOP)
            x = x + 7

        -- 1/9 chance to render a medium obstacle
        elseif math.random(9) == 1 and x > 500 and x < 1000 then
            self:setTile(x, self.mapHeight_tilewise - 2 - 1, COLUMN_TOP)
            self:setTile(x + 1, self.mapHeight_tilewise - 2 - 1, COLUMN_BOTTOM)
            self:setTile(x + 1, self.mapHeight_tilewise - 2 - 2, COLUMN_TOP)
            x = x + 9
        
        -- 1/8 chance to render a challenging obstacle
        elseif math.random(8) == 1 and x > 1000 and x < 1500 then
            self:setTile(x, self.mapHeight_tilewise - 2 - 1, COLUMN_BOTTOM)
            self:setTile(x, self.mapHeight_tilewise - 2 - 2, COLUMN_TOP)
            self:setTile(x + 1, self.mapHeight_tilewise - 2 - 1, COLUMN_BOTTOM)
            self:setTile(x + 1, self.mapHeight_tilewise - 2 - 2, COLUMN_TOP)
            self:setTile(x + 2, self.mapHeight_tilewise - 2 - 1, COLUMN_BOTTOM)
            self:setTile(x + 2, self.mapHeight_tilewise - 2 - 2, COLUMN_TOP)
            x = x + 11

        -- 1/8 chance to render a very challenging obstacle
        elseif math.random(8) == 1 and x > 1500 then
            self:setTile(x, self.mapHeight_tilewise - 2 - 1, COLUMN_BOTTOM)
            self:setTile(x, self.mapHeight_tilewise - 2 - 2, COLUMN_TOP)
            self:setTile(x + 1, self.mapHeight_tilewise - 2 - 1, COLUMN_BOTTOM)
            self:setTile(x + 1, self.mapHeight_tilewise - 2 - 2, COLUMN_TOP)
            self:setTile(x + 2, self.mapHeight_tilewise - 2 - 1, COLUMN_BOTTOM)
            self:setTile(x + 2, self.mapHeight_tilewise - 2 - 2, COLUMN_TOP)
            self:setTile(x + 3, self.mapHeight_tilewise - 2 - 1, COLUMN_BOTTOM)
            self:setTile(x + 3, self.mapHeight_tilewise - 2 - 2, COLUMN_TOP)
            x = x + 12
        end
        x = x + 2
    end    
end

function Map:update(dt)

    if cam_movement and not collision then

       -- Increment camX in order to move the camera
       self.camX = math.min(
           self.mapWidth_pixelwise - VIRTUAL_WIDTH,
           self.camX + SCROLL_SPEED * dt
       )
    end

    self.flag_animation:update(dt)

    -- Speed up the camera with time
    SCROLL_SPEED = SCROLL_SPEED + 2 * dt
end

function Map:render()

    -- Go through the whole map
    for y = 1, self.mapHeight_tilewise do
        for x = 1, self.mapWidth_tilewise do

            -- Draw the correct tile according to the tile mappings
            love.graphics.draw(
                self.spritesheet,
                self.tileSprites[self:getTile(x, y)],
                (x - 1) * self.tileWidth,
                (y - 1) * self.tileHeight
            )
        end
    end

    -- Render flag
    love.graphics.draw(
        self.spritesheet,
        self.flag_animation:getCurrentQuad(),
        math.floor((FLAGPOLE_x - 1) * map.tileWidth + 8),
        math.floor((FLAGPOLE_BOTTOM_y - 1) * map.tileHeight + 5)
    )

    displayFPS()
end

-- Set the mapping of the tile at x & y
function Map:setTile(x, y, tile)
    self.tiles[(y - 1) * self.mapWidth_tilewise + x] = tile
end

-- Return the mapping value of the tile at x & y
function Map:getTile(x, y)
    return self.tiles[(y - 1) * self.mapWidth_tilewise + x]
end

-- Return the specific tile info at x & y
function Map:tileAt(x, y)
    return {
        x = math.floor(x / self.tileWidth) + 1,
        y = math.floor(y / self.tileHeight) + 1,
        id = self:getTile(math.floor(x / self.tileWidth) + 1, math.floor(y / self.tileHeight) + 1)
    }
end

function displayFPS()

    love.graphics.setFont(small_font)

    -- Orange text color
    love.graphics.setColor(1, 50/255, 0, 1)
    
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), math.floor(map.camX + 10), 10)
end