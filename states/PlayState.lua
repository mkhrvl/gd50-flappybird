PlayState = Class{__includes = BaseState}

pipeSpeed = 60
pipeWidth = 70
pipeHeight = 288

birdWidth = 38
birdHeight = 24

-- initial spawn interval of pipes (added) (specification) (spawn)
local interval = 2

-- checks if game is paused (added) (specification) (pause)
local pause = false

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.score = 0

    self.lastY = -pipeHeight + math.random(80) + 20
end

function PlayState:update(dt)
    if scrolling then -- (added) (specification) (pause)

        self.timer = self.timer + dt

        if self.timer > interval then -- spawns pipes depending on random interval value (modified) (specification) (spawn)
            local y = math.max(-pipeHeight + 10, math.min(self.lastY + math.random(-20,20), 
            v_height - 90 - pipeHeight))
            self.lastY = y
            table.insert(self.pipePairs, PipePair(y))
            self.timer = 0

            -- randomizes interval (added) (specification) (spawn)
            interval = math.random(2,3)
        end

        for k, pair in pairs(self.pipePairs) do
            if not pair.scored then
                if pair.x + pipeWidth < self.bird.x then
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
    
        for k, pair in pairs(self.pipePairs) do
            for l, pipe in pairs(pair.pipes) do
                if self.bird:collides(pipe) then
                    sounds['explosion']:play()
                    sounds['hurt']:play()

                    gStateMachine:change('score', {
                        score = self.score 
                    })
                end
            end
        end

        self.bird:update(dt)

        if self.bird.y > v_height - 15 then
            sounds['explosion']:play()
            sounds['hurt']:play()

            gStateMachine:change('score', {
                score = self.score
            })
        end
    end

    -- pause game when "p" is pressed (added) (specification) (pause)
    if love.keyboard.wasPressed('p') then
        if not pause then
            scrolling = false
            pause = true
            sounds['music']:pause()
            sounds['pause']:play()
        else
            pause = false
            scrolling = true
            sounds['music']:play()
            sounds['pause']:play()
        end
    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
    
    self.bird:render()

    if pause then -- draws pause text and image (added) (specification) (pause)
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Paused', 0, v_height / 16, v_width, 'center')
        love.graphics.draw(love.graphics.newImage('sprites/pause.png'), v_width / 2 - 120, v_height / 2 - 120)
    end
end

function PlayState:enter()
    scrolling = true
end

function PlayState:exit()
    scrolling = false
end