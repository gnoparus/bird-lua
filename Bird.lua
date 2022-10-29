Bird = Class {}

local GRAVITY = 400
local BIRD_JUMP_DY = -200

function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = (VIRTUAL_WIDTH / 2) - (self.width / 2)
    self.y = (VIRTUAL_HEIGHT / 2) - (self.height / 2)

    self.dy = -50
end

function isCollided(ax, ay, awidth, aheight, bx, by, bwidth, bheight)
    if ax + awidth >= bx and ax <= bx + bwidth then
        if ay + aheight >= by and ay <= by + bheight then
            return true
        end
    end
    return false
end

function Bird:collides(pipe)
    return isCollided(self.x + 2, self.y + 2, self.width - 4, self.height - 4, pipe.x,
        pipe.orientation == 'top' and pipe.y - pipe.height or pipe.y, pipe.width, pipe.height)
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') then
        self.dy = BIRD_JUMP_DY
        sounds['jump']:play()
    end

    self.y = self.y + self.dy * dt
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end
