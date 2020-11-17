-- This file contains animation-related code

Animation = Class{}

function Animation:init(parameters)
    self.sheet = parameters.sheet
    self.quads = parameters.quads
    self.interval = parameters.interval
    self.currentFrame = 1
    self.timer = 0
end

function Animation:update(dt)

    -- Increment the timer by delta time
    self.timer = self.timer + dt

    -- Increment self.currentFrame each time the interval passes
    while self.timer > self.interval do
        self.timer = self.timer - self.interval

        -- The modulo operator is used to loop back after reaching the last frame
        -- But in the ollie animation (which has 12 quads), we don't want looping
        if #self.quads ~= 12 then
            self.currentFrame = (self.currentFrame + 1) % (#self.quads + 1)
        elseif self.currentFrame < 12 then
            self.currentFrame = self.currentFrame + 1
        else
            self.currentFrame = 12
        end
    end

    -- Using the modulo operator (%) above will cause self.currentFrame to reach 0; we don't want that
    if self.currentFrame == 0 then
        self.currentFrame = 1
    end
end

function Animation:getCurrentQuad()
    return self.quads[self.currentFrame]
end

function Animation:restart()

    -- Reset the animation, so that it doesn't start from the middle when we get back to it
    self.timer = 0
    self.currentFrame = 1
end