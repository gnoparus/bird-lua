Pipe = Class {}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')
PIPE_SCROLL_DX = 60

PIPE_HEIGHT = PIPE_IMAGE:getHeight()
PIPE_WIDTH = PIPE_IMAGE:getWidth()

function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH
    self.y = y
    self.orientation = orientation

    self.width = PIPE_WIDTH
    self.height = PIPE_HEIGHT
end

function Pipe:update(dt)

end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, self.y, 0, 1, self.orientation == 'top' and -1 or 1)
end

