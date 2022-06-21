push = require('push')

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

V_WIDTH = 512
V_HEIGHT = 288

local background = love.graphics.newImage('background.png')

local ground = love.graphics.newImage('ground.png')

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Flappy Bird')

    push:setupScreen(V_WIDTH, V_HEIGHT, WINDOW_WIDTH, WINDOW_WIDTH, {
        vsync = true;
        fullscreen = false;
        resizable = true
    })
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    push:start()
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(ground, 0, V_HEIGHT - 16)
    push:finish()
end
