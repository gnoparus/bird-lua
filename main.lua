push = require 'push'
Class = require 'class'

require 'Bird'
require 'Pipe'
require 'PipePairs'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 70

local BACKGROUND_LOOPING_POING = 413

local bird = Bird()
local BIRD_JUMP_DY = -200

local pipes = {}
local pipeSpawnTimer = 0
local PIPE_SPAWN_TIME = 2

local lastY = VIRTUAL_HEIGHT / 2 + math.random(-20, 20)

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Bird Lua')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)

    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end

end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POING
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

    if love.keyboard.wasPressed('space') then
        bird.dy = BIRD_JUMP_DY
    end

    pipeSpawnTimer = pipeSpawnTimer + dt

    if pipeSpawnTimer > PIPE_SPAWN_TIME then
        pipeSpawnTimer = 0

        local y = lastY + math.random(-30, 30)
        y = math.min(y, VIRTUAL_HEIGHT - 48)
        y = math.max(y, PIPE_GAP_HEIGHT + 48)
        lastY = y
        table.insert(pipes, PipePairs(y))
    end

    bird:update(dt)

    for k, v in pairs(pipes) do
        v:update(dt)

        if v.x < -PIPE_WIDTH then
            table.remove(pipes, k)
        end
    end

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)

    for k, v in pairs(pipes) do
        v:render()
    end

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    bird:render()

    push:finish()
end
