PlayState = Class {
    __includes = BaseState
}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

local PIPE_SPAWN_TIME = 2

function PlayState:init()

    self.bird = Bird()
    self.pipePairs = {}
    self.pipeSpawnTimer = 0

    self.lastY = VIRTUAL_HEIGHT / 2 + math.random(-30, 30)
end

function PlayState:update(dt)
    self.pipeSpawnTimer = self.pipeSpawnTimer + dt

    if self.pipeSpawnTimer > PIPE_SPAWN_TIME then
        self.pipeSpawnTimer = 0

        local y = self.lastY + math.random(-30, 30)
        y = math.min(y, VIRTUAL_HEIGHT - 48)
        y = math.max(y, PIPE_GAP_HEIGHT + 48)
        self.lastY = y

        table.insert(self.pipePairs, PipePair(y))
    end

    for k, pair in pairs(self.pipePairs) do
        pair:update(dt)
    end

    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    self.bird:update(dt)

    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                gStateMachine:change('title')
            end
        end

    end

    if self.bird.y > VIRTUAL_HEIGHT then
        gStateMachine:change('title')
    end

end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    self.bird:render()
end
