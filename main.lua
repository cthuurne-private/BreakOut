--[[
    Breakout Remake
    Original by Atari in 1976

    Version which resembles the NES version on a modern widescreen (16:9) for modern systems.

    Credit for graphics:
    https://opengameart.org/users/buch

    Credit for music:
    http://freesound.org/people/joshuaempyre/sounds/251461/
    http://www.soundcloud.com/empyreanma
]]

-- Dependencies
push = require "lib/push"
class = require "lib/class"
require "src/constants"
require 'src/Utilities'
require "src/StateMachine"
require "src/states/BaseState"
require "src/states/StartState"

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setTitle("BreakOut")

    math.randomseed(os.time())

    -- Initialize fonts
    gFonts = {
        ["small"] = love.graphics.newFont("fonts/font.ttf", 8),
        ["medium"] = love.graphics.newFont("fonts/font.ttf", 16),
        ["large"] = love.graphics.newFont("fonts/font.ttf", 32)
    }
    love.graphics.setFont(gFonts["small"])

    -- Initialize textures
    gTextures = {
        ["arrows"] = love.graphics.newImage("textures/arrows.png"),
        ["background"] = love.graphics.newImage("textures/background.png"),
        ["breakout"] = love.graphics.newImage("textures/breakout.png"),
        ["hearts"] = love.graphics.newImage("textures/hearts.png"),
        ["particle"] = love.graphics.newImage("textures/particle.png"),
    }

    -- Initialize sprites
    -- Quads are used to separate sprites from sprite sheets
    gSprites = {
        ["paddles"] = GenerateQuadsPaddles(gTextures["breakout"])
    }

    gSounds = {
        ["brick-hit-1"] = love.audio.newSource("sounds/brick-hit-1.wav", "static"),
        ["brick-hit-2"] = love.audio.newSource("sounds/brick-hit-2.wav", "static"),
        ["confirm"] = love.audio.newSource("sounds/confirm.wav", "static"),
        ["high-score"] = love.audio.newSource("sounds/high_score.wav", "static"),
        ["hurt"] = love.audio.newSource("sounds/hurt.wav", "static"),
        ["music"] = love.audio.newSource("sounds/music.wav", "static"),
        ["no-select"] = love.audio.newSource("sounds/no-select.wav", "static"),
        ["paddle-hit"] = love.audio.newSource("sounds/paddle_hit.wav", "static"),
        ["pause"] = love.audio.newSource("sounds/pause.wav", "static"),
        ["recover"] = love.audio.newSource("sounds/recover.wav", "static"),
        ["score"] = love.audio.newSource("sounds/score.wav", "static"),
        ["select"] = love.audio.newSource("sounds/select.wav", "static"),
        ["victory"] = love.audio.newSource("sounds/victory.wav", "static"),
        ["wall-hit"] = love.audio.newSource("sounds/wall_hit.wav", "static")
    }

    -- initialize our virtual resolution, which will be rendered within our actual window
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- initialize current game states: 
    -- 1. start state
    gStateMachine = StateMachine {       
        ["start"] = function() return StartState() end,
        ['play'] = function() return PlayState() end
    }
    gStateMachine:change("start")

    -- initialize input table
    love.keyboard.keysPressed = {}
end

function love.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

--[[
    Called whenever we change the dimensions of our window, as by dragging
    out its bottom corner, for example. In this case, we only need to worry
    about calling out to `push` to handle the resizing. Takes in a `w` and
    `h` variable representing width and height, respectively.
]]
function love.resize(w, h)
    push:resize(w, h)
end

--[[
    Called each frame after update; is responsible simply for
    drawing all of our game objects and more to the screen.
]]
function love.draw()
    push:apply("start")

    local backgroundWidth = gTextures["background"]:getWidth()
    local backgroundHeight = gTextures["background"]:getHeight()

    love.graphics.draw(gTextures["background"], 0, 0, 0,
        VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))

    gStateMachine:render()
    
    push:apply("end")
end

--[[
    A callback that processes key strokes as they happen, just the once.
    Does not account for keys that are held down, which is handled by a
    separate function (`love.keyboard.isDown`). Useful for when we want
    things to happen right away, just once, like when we want to quit.
]]
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

--[[
    A custom function that will let us test for individual keystrokes outside
    of the default `love.keypressed` callback, since we can"t call that logic
    elsewhere by default.
]]
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function displayFPS()
    love.graphics.setFont(gFonts["small"])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 5, 5)
end