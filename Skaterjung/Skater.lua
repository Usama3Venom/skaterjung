-- This file contains skater-related code

-- Create a Skater class
Skater = Class{}

-- Import Animation class
require 'Animation'

local SLOW_MOVEMENT_SPEED = 200
local AVERAGE_MOVEMENT_SPEED = 230
local FAST_MOVEMENT_SPEED = 260
local JUMPING_VELOCITY = 565
local GRAVITY = 40

function Skater:init()
    
    -- These represent the size of the quads, not the actual width and height of the skater
    self.width = 50
    self.height = 50

    -- y value to give the skater in order to be atop the bricks
    local ATOP_THE_BRICKS = map.tileHeight * (map.mapHeight_tilewise - 3) - self.height + 4

    -- Original position of skater
    self.x = map.tileWidth * 1.5
    self.y = ATOP_THE_BRICKS

    -- Velocity
    self.dx = 0
    self.dy = 0

    -- Load skaterboy spritesheets
    self.idleSheet = love.graphics.newImage('graphics/idle.png')
    self.rollSheet = love.graphics.newImage('graphics/roll.png')
    self.ollieSheet = love.graphics.newImage('graphics/ollie.png')
    
    -- Chop up quads of every animation
    self.idleQuads = generateQuads(self.idleSheet, self.width, self.height)
    self.rollQuads = generateQuads(self.rollSheet, self.width, self.height)
    self.ollieQuads = generateQuads(self.ollieSheet, self.width, self.height)

    -- The state at game's beginning is idle
    self.state = 'idle'

    -- There are 3 distinct animations
    self.animations = {
        ['idle'] = Animation{ 
            sheet = self.idleSheet,
            quads = self.idleQuads,
            interval = 0.05
        },
        ['roll'] = Animation{
            sheet = self.rollSheet,
            quads = self.rollQuads,
            interval = 0.05
        },
        ['ollie'] = Animation{
            sheet = self.ollieSheet,
            quads = self.ollieQuads,
            interval = 0.045
        }
    }

    self.behaviors = {
        ['idle'] = function(dt)

            self.animation = self.animations['idle']
            self.dx = 0

            if love.keyboard.isDown('d') then
                self.state = 'roll'

            elseif love.keyboard.wasPressed('space') then
                self.dy = -JUMPING_VELOCITY

                audio.jump:play()

                -- Reset current animation before getting to the next
                self.animation:restart()

                self.state = 'ollie'
            end
        end,
        ['roll'] = function(dt)

            if not collision then
                self.animation = self.animations['roll']

                if love.keyboard.isDown('d') and not love.keyboard.isDown('a') then
                    self.dx = FAST_MOVEMENT_SPEED
                elseif love.keyboard.isDown('a') and not love.keyboard.isDown('d') then
                    self.dx = SLOW_MOVEMENT_SPEED
                else
                    self.dx = AVERAGE_MOVEMENT_SPEED
                end

                if love.keyboard.wasPressed('space') then
                    self.dy = -JUMPING_VELOCITY

                    audio.jump:play()

                    -- Reset current animation before getting to the next
                    self.animation:restart()

                    self.state = 'ollie'
                end
            end
        end,
        ['ollie'] = function(dt)

            if not collision then
                self.animation = self.animations['ollie']
                
                -- Start gradually decreasing the y velocity
                self.dy = self.dy + GRAVITY

                -- Stop when the ground is reached
                if self.y >= ATOP_THE_BRICKS then

                    self.y = ATOP_THE_BRICKS
                    self.dy = 0

                    -- Reset current animation before getting to the next
                    self.animation:restart()

                    self.state = 'roll'                
                end
                
                -- Move left or right while airborne
                if love.keyboard.isDown('d') and not love.keyboard.isDown('a') then
                    self.dx = FAST_MOVEMENT_SPEED
                elseif love.keyboard.isDown('a') and not love.keyboard.isDown('d') then
                    self.dx = SLOW_MOVEMENT_SPEED
                else
                    self.dx = AVERAGE_MOVEMENT_SPEED
                end
            end
        end
    }

    -- No collision at the beginning
    collision = false
end

function Skater:update(dt)

    if collision then
        
        -- Original position of skater
        self.x = map.tileWidth * 1.5
        self.y = ATOP_THE_BRICKS

        -- Velocity
        self.dx = 0
        self.dy = 0
    else

        -- Update depending on current state
        self.behaviors[self.state](dt)
        self.animation:update(dt)

        self.x = self.x + self.dx * dt
        self.y = self.y + self.dy * dt

        -- Speed up with time
        SLOW_MOVEMENT_SPEED = SLOW_MOVEMENT_SPEED + 2 * dt
        AVERAGE_MOVEMENT_SPEED = AVERAGE_MOVEMENT_SPEED + 2 * dt
        FAST_MOVEMENT_SPEED = FAST_MOVEMENT_SPEED + 2 * dt

        -- The actual tips of the skater
        back_skater_tip_x = self.x + 12
        front_skater_tip_x = self.x + 30
        top_skater_tip_y = self.y + 4
        bottom_skater_tip_y = self.y + 45

        -- Tiles that represent numbers greater than 7 should all block the skater
        -- Check for collision
        if not collision then
            if map:tileAt(front_skater_tip_x, bottom_skater_tip_y).id > 7 or
               map:tileAt(front_skater_tip_x, top_skater_tip_y).id > 7 or
               map:tileAt(back_skater_tip_x + 12, bottom_skater_tip_y).id > 7 or
               map:tileAt(back_skater_tip_x, bottom_skater_tip_y).id > 7 then

                collision = true
                audio.crash:play()
                game_state = 'game_over'
                love.timer.sleep(2)
            end
        end

        -- In case the player's passed the flagpole successfully, they've won
        if self.x > FLAGPOLE_x * map.tileWidth + 50 then
            audio.victory:play()
            game_state = 'victory'
        end
    end

end

function Skater:render()

    -- Reset color to white, so that the skater doesn't look orange
    love.graphics.setColor(1, 1, 1, 1)
    
    -- Draw the skater after shifting the origin point of love.draw to the center
    love.graphics.draw(
        self.animation.sheet, self.animation:getCurrentQuad(),
        math.floor(self.x + self.width / 2), math.floor(self.y + self.height / 2),
        0, 1, 1, self.width / 2, self.height / 2
    )

    -- Orange text color
    love.graphics.setColor(1, 50/255, 0, 1)
    
    -- Render score
    love.graphics.print('Score: ' .. math.floor(self.x), math.floor(map.camX + 370), 10)
end