push = require 'push'
Class = require 'class'
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/CountdownState'
require 'states/TitleScreenState'
require 'Bird'
require 'Pipe'
require 'PipePair'

w_width = 1280
w_height = 720
v_width = 512
v_height = 288

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0
local ground = love.graphics.newImage('ground.png')
local groundScroll = 0
local backgroundSpeed = 30
local groundSpeed = 60
local bgLoopingPoint = 413

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Fifty Bird')

    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    love.graphics.setFont(flappyFont)

    sounds = {
        ['jump'] = love.audio.newSource('jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),
        ['pause'] = love.audio.newSource('pause.wav', 'static'), -- (added) (specification) (pause)
        ['music'] = love.audio.newSource('marios_way.mp3', 'static')
    }
        
    sounds['music']:setLooping(true)
    sounds['music']:play()
    
    sounds['jump']:setVolume(0.2)
    sounds['explosion']:setVolume(0.2)
    sounds['hurt']:setVolume(0.2)
    sounds['score']:setVolume(0.2)
    sounds['pause']:setVolume(0.2)
    sounds['music']:setVolume(0.1)
    

    push:setupScreen(v_width, v_height, w_width, w_height, {
        vsync = true, 
        fullscreen = false, 
        resizable =  true
    })

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title')
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true    
    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    if scrolling then -- stops scrolling when entering pause state (added) (specification) (pause)
        backgroundScroll = (backgroundScroll + backgroundSpeed * dt) % bgLoopingPoint
        groundScroll = (groundScroll + groundSpeed * dt) % v_width
    end

    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    push:start()
    love.graphics.draw(background, -backgroundScroll, 0)
    gStateMachine:render()
    love.graphics.draw(ground, -groundScroll, v_height - 16)
    push:finish()
end 
