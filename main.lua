push = require 'push'
Class = require 'class'

require 'Bird'
require 'Pipe'
require 'PipePair'

require 'StateMachine'
require 'states.BaseState'
require 'states.PlayState'
require 'states.TitleScreenState'
require 'states.ScoreState'
require 'states.CountdownState'

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

local pipePairs = {}
local pipeSpawnTimer = 0
local PIPE_SPAWN_TIME = 2

local lastY = VIRTUAL_HEIGHT / 2 + math.random(-20, 20)

local scrolling = true

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    love.window.setTitle('Bird Lua')

    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    sounds = {
        -- Sound Effect
        ['jump'] = love.audio.newSource('jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),
        -- Music
        ['music'] = love.audio.newSource('marios_way.mp3', 'static')
    }
    sounds['music']:setLooping(true)
    sounds['music']:play()

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gStateMachine = StateMachine {
        ['title'] = function()
            return TitleScreenState()
        end,
        ['countdown'] = function()
            return CountdownState()
        end,
        ['play'] = function()
            return PlayState()
        end,
        ['score'] = function()
            return ScoreState()
        end
    }
    gStateMachine:change('title')

    love.keyboard.keysPressed = {}
    love.mouse.buttonPressed = {}
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

function love.mousepressed(x, y, button)
    love.mouse.bottonsPressed[button] = true
end

function love.mouse.wasPressed(button)
    return love.mouse.bottonsPressed[button]
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

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
    love.mouse.bottonsPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)
    gStateMachine:render()
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end
