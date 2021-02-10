PipePair = Class{}

-- sets value of gap (added) (specification) (gap)
local gapDistance = math.random(80, 120)

function PipePair:init(y)
    self.scored = false
    self.x = v_width + 32
    self.y = y
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + pipeHeight + gapDistance) -- gap isn't constant anymore (modified) (specification) (gap)
    }
    self.remove = false
end

function PipePair:update(dt)
    if self.x > -pipeWidth then
        self.x = self.x - pipeSpeed * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end

    -- randomizes gap size after first value (added) (specification)(gap)
    gapDistance = math.random(80, 120)
end

function PipePair:render()
    for l, pipe in pairs(self.pipes) do
        pipe:render()
    end
end