--[[
                                         Oct 22, 2020

                                    Final project of CS50
                                        
                                          SKATERJUNG
                                        
                                      A Computer Game by

                                Usama Abdur-Rahman (Artour Tiger)


ALl rights (hopefully) reserved.
                                              
                                           
                                           Disclaimer

Please plug in your device for optimum results, as laptops on battery mode might suffer from frame drops
I've found out that this problem goes away more or less when I decrease the length of the map;
however, I couldn't bring myself to solving it that way
]]

-- Actual window size
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Size we get by using the push lib
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Importing files
local push = require 'push'
Class = require 'class'
require 'main_menu'
require 'style'
require 'instructions'
require 'util'
require 'Map'
require 'Skater'
require 'game_over'
require 'danke'

function love.load()

    love.window.setTitle("Skaterjung")

    -- Hide cursor
    love.mouse.setVisible(false)

    -- This image is the main menu title
    title = love.graphics.newImage('graphics/title.png')

    -- First state is menu
    game_state = 'menu'

    -- Default background is light
    game_background = 'light'

    -- The camera shouldn't move at the start
    cam_movement = false

    -- Importing the audio files
    audio = {
        music = love.audio.newSource('sounds/music.wav', 'static'),
        click = love.audio.newSource('sounds/click.wav', 'static'),
        jump = love.audio.newSource('sounds/jump.wav', 'static'),
        crash = love.audio.newSource('sounds/crash.wav', 'static'),
        victory = love.audio.newSource('sounds/victory.wav', 'static')
    }
    
    -- Set up audio
    audio.music:setLooping(true)
    audio.music:setVolume(0.25)
    audio.jump:setVolume(0.5)
    audio.victory:setVolume(0.5)
    audio.music:play()

    -- Change the random seed so the map changes every time the game runs
    math.randomseed(os.time())

    -- Instantiate map and skater
    map = Map{}
    skater = Skater{}

    -- Create the retro vibe
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Create 2 sizes of the same font
    small_font = love.graphics.newFont('fonts/font.ttf', 8)
    large_font = love.graphics.newFont('fonts/font.ttf', 20)

    -- Set up push
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = true,
        vsync = true,
        resizable = false
    })

    -- This table's used to enable love.keyboard.wasPressed
    love.keyboard.keysPressed = {}

    -- These variables help with the button pressing on the game window
    menu_pointer = 'play'
    style_pointer = 'back'
end

-- When certain keys are pressed, do something
function love.keypressed(key)
    
    if key == 'escape' then
        audio.click:play()
        love.timer.sleep(0.5)
        love.event.quit()

    elseif key == 'return' and
           game_state == 'menu' and
           menu_pointer == 'play' then

        audio.click:play()
        game_state = 'play'

    elseif key == 'return' and
           game_state == 'menu' and
           menu_pointer == 'style' then

        audio.click:play()
        game_state = 'style'

    elseif key == 'return' and
           game_state == 'menu' and
           menu_pointer == 'instructions' then

        audio.click:play()
        game_state = 'instructions'

    elseif key == 'return' and
           game_state == 'menu' and
           menu_pointer == 'exit' then

        audio.click:play()
        love.timer.sleep(0.5)
        love.event.quit()
    
    --
    elseif key == 'return' and
           game_state == 'style' and
           style_pointer == 'dark' then
        
        audio.click:play()
        game_background = 'dark'

    elseif key == 'return' and
           game_state == 'style' and
           style_pointer == 'light' then
        
        audio.click:play()
        game_background = 'light'

    elseif key == 'return' and
           game_state == 'style' and
           style_pointer == 'normal' then
        
        audio.click:play()
        map.spritesheet = love.graphics.newImage('graphics/spritesheet normal.png')

    elseif key == 'return' and
           game_state == 'style' and
           style_pointer == 'trippy' then
        
        audio.click:play()
        map.spritesheet = love.graphics.newImage('graphics/spritesheet trippy.png')

    elseif key == 'return' and
           game_state == 'style' and
           style_pointer == 'back' then

        audio.click:play()
        game_state = 'menu'

    -- Change the highlighted button according to user input
    elseif game_state == 'menu' and
           menu_pointer == 'play' and
           key == 'down' then

        audio.click:play()
        menu_pointer = 'style'

    elseif game_state == 'menu' and
           menu_pointer == 'style' and
           key == 'down' then

        audio.click:play()
        menu_pointer = 'instructions'

    elseif game_state == 'menu' and
           menu_pointer == 'instructions' and
           key == 'down' then
        
        audio.click:play()
        menu_pointer = 'exit'

    elseif game_state == 'menu' and
           menu_pointer == 'exit' and
           key == 'up' then
        
        audio.click:play()
        menu_pointer = 'instructions'

    elseif game_state == 'menu' and
           menu_pointer == 'instructions' and
           key == 'up' then
        
        audio.click:play()
        menu_pointer = 'style'

    elseif game_state == 'menu' and
           menu_pointer == 'style' and
           key == 'up' then
        
        audio.click:play()
        menu_pointer = 'play'

    elseif game_state == 'style' and
           style_pointer == 'back' and
           key == 'up' then
 
        audio.click:play()
        style_pointer = 'normal'

    elseif game_state == 'style' and
           style_pointer == 'normal' and
           key == 'up' then

        audio.click:play()
        style_pointer = 'dark'

    elseif game_state == 'style' and
           style_pointer == 'dark' and
           key == 'right' then

        audio.click:play()
        style_pointer = 'light'

    elseif game_state == 'style' and
           style_pointer == 'light' and
           key == 'down' then

        audio.click:play()
        style_pointer = 'trippy'

    elseif game_state == 'style' and
           style_pointer == 'trippy' and
           key == 'left' then

        audio.click:play()
        style_pointer = 'normal'

    elseif game_state == 'style' and
           style_pointer == 'light' and
           key == 'left' then

        audio.click:play()
        style_pointer = 'dark'

    elseif game_state == 'style' and
           style_pointer == 'trippy' and
           key == 'down' then

        audio.click:play()
        style_pointer = 'back'

    elseif game_state == 'style' and
           style_pointer == 'normal' and
           key == 'down' then

        audio.click:play()
        style_pointer = 'back'

    elseif game_state == 'style' and
           style_pointer == 'dark' and
           key == 'down' then

        audio.click:play()
        style_pointer = 'normal'

    elseif game_state == 'style' and
           style_pointer == 'normal' and
           key == 'right' then

        audio.click:play()
        style_pointer = 'trippy'

    elseif game_state == 'style' and
           style_pointer == 'trippy' and
           key == 'up' then

        audio.click:play()
        style_pointer = 'light'

    -- Move the skater
    elseif (key == 'd' or key == 'space') and game_state == 'play' then

        -- Start moving the camera
        cam_movement = true

    -- Display instructions
    elseif game_state == 'instructions' and key == 'return' then
        
        audio.click:play()
        game_state = 'menu'
    end

    -- Enable love.keyboard.wasPressed at key
    love.keyboard.keysPressed[key] = true
end

-- When certain keys are pressed, do something, but only for a moment
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)

    if game_state == 'play' then
        skater:update(dt)
        map:update(dt)

        -- Reset table so that the effect of pressing the key goes away
        love.keyboard.keysPressed = {}
    end
end

function love.draw()

    push:apply('start')

    if cam_movement then
        love.graphics.translate(math.floor(-map.camX), math.floor(-map.camY))
    end

    if game_state == 'menu' then
        main_menu()

    elseif game_state == 'style' then
        style()

    elseif game_state == 'instructions' then
        instructions()
        
    elseif game_state == 'play' then

        -- Color the background according to the chosen theme
        if game_background == 'light' then
            love.graphics.clear(0, 201/255, 251/255, 1)
        elseif game_background == 'dark' then
            love.graphics.clear(0, 0, 0, 1)
        end

        if not collision then
            
            map:render()
            skater:render()
        end

    elseif game_state == 'game_over' then
        game_over()

    elseif game_state == 'victory' then
        danke()
    end

    push:apply('end')
end

-- Enables fullscreen
function love.resize(width, height)
    push:resize(width, height)
end