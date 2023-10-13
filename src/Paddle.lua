--[[
    Represents a paddle that can move left and right. Used in the main
    program to deflect the ball toward the bricks; if the ball passes
    the paddle, the player loses one heart. The Paddle can have a skin,
    which the player gets to choose upon starting the game.
]]

Paddle = class{}

--[[
    The `init` function on our class is called just once, when the object is first created. Used to set up all variables in the class and get it ready for use.
    It will always start at the same spot, in the middle of the screen at the bottom.
]]

function Paddle:init()
    self.x = VIRTUAL_WIDTH / 2 - 32
    self.y = VIRTUAL_HEIGHT - 32
    self.dx = 0
    self.width = 64
    self.height = 16
    self.skin = 1
    self.size = 2
end

function Paddle:update(dt)
    if love.keyboard.isDown("left") then
        self.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown("right") then
        self.dx = PADDLE_SPEED
    else
        self.dx = 0
    end

    -- math.max here ensures that we're the greater of 0 or the player's current calculated Y position when pressing up so we don't go into the negatives;
    -- the movement calculation is simply our previously-defined paddle speed scaled by dt
    if self.x < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    -- the following line is changed to account for the paddle's width    
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    end
end

function Paddle:render()
    love.graphics.draw(gTextures["main"], gSprites["paddles"][self.size + 4 * (self.skin - 1)], self.x, self.y)
end