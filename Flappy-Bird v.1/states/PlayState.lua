--[[
    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
]]

PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0

    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    self.timer = self.timer + dt

    if self.timer > 2 then
        -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
        -- no higher than 10 pixels below the top edge of the screen,
        -- and no lower than a gap length (90 pixels) from the bottom
        local y = math.max(-PIPE_HEIGHT + 10, 
        math.min(self.lastY + math.random(-20, 20),V_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y
        

        table.insert(self.pipePairs, PipePairs(y))
        self.timer = 0
    end 

    -- update bird based on gravity and input
    self.bird:update(dt)
    
    -- for every pair of pipess..
    for k, pair in pairs(self.pipePairs) do
        -- update position of pair
        pair:update(dt)

        -- check to see if bird collided with pipe
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                -- pause the game to show collision
                gStateMachine:change('title')
            end
        end
        -- remove the pipe if it's no longer visible past left edge
        if pair.x < -PIPE_WIDTH then
            pair.remove = true
        end
    end
    
    -- remove any flagged pipes
    -- we need this second loop, rather than deleting in the previous loop, because
    -- modifying the table in-place without explicit keys will result in skipping the
    -- next pipe, since all implicit keys (numerical indices) are automatically shifted
    -- down after a table removal
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end
    
    -- reset if we get to the ground
    if self.bird.y > V_HEIGHT - 15 then
        gStateMachine:change('title')
    end
end


function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end
    self.bird:render()
end
