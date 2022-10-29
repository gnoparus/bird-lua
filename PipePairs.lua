PipePairs = Class {}

PIPE_GAP_HEIGHT = 90

function PipePairs:init(y)

    self.x = VIRTUAL_WIDTH + 32
    self.y = y

    self.pipes = {
        ['upper'] = Pipe('top', self.y - PIPE_GAP_HEIGHT),
        ['lower'] = Pipe('bottom', self.y)
    }

    self.remove = false
end

function PipePairs:update(dt)

    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SCROLL_DX * dt
        for k, v in pairs(self.pipes) do
            v.x = self.x
        end
    else
        self.remove = true
    end
end

function PipePairs:render()
    for k, v in pairs(self.pipes) do
        v:render()
    end
end

