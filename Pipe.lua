Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')

function Pipe:init(orientation, y)
    self.x = v_width + 64
    self.y = y

    self.width = pipeWidth
    self.height = pipeHeight

    self.orientation = orientation
end

function Pipe:update(dt)
    
end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, 
        (self.orientation == 'top' and self.y + pipeHeight or self.y), 
        0, 1, self.orientation == 'top' and -1 or 1)
end