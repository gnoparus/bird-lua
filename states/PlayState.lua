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
    self.score = 0

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

        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                sounds['score']:play()

            end
        end
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
                gStateMachine:change('score', {
                    score = self.score
                })
                sounds['explosion']:play()
                sounds['hurt']:play()
            end
        end

    end

    if self.bird.y > VIRTUAL_HEIGHT then
        gStateMachine:change('score', {
            score = self.score
        })
        sounds['explosion']:play()
        sounds['hurt']:play()
    end

end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. self.score, 8, 8)

    self.bird:render()

end
