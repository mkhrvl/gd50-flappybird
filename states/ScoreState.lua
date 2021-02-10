ScoreState = Class{__includes = BaseState}

 -- (added) (specification) (score)
local BRONZE_TROPHY = love.graphics.newImage('sprites/trophy_03_bronze.png')
local SILVER_TROPHY = love.graphics.newImage('sprites/trophy_03_silver.png')
local GOLD_TROPHY = love.graphics.newImage('sprites/trophy_03_gold.png')

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, v_width, 'center')
    
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, v_width, 'center')
    
    -- draws different trophies according to score (added) (specification) (score)
    if self.score > 0 and self.score < 2 then
        love.graphics.draw(BRONZE_TROPHY, v_width/2 - 23, 120)
    elseif self.score > 1 and self.score < 3 then
        love.graphics.draw(SILVER_TROPHY, v_width/2 - 23, 120)
    else
        love.graphics.draw(GOLD_TROPHY, v_width/2 - 23, 120)
    end

    love.graphics.printf('Press Enter to Play Again!', 0, 160, v_width, 'center')
end