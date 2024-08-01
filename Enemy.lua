local love = require "love"

function Enemy(level)
    local dice = math.random(1, 4)
    local _x, _y
    local _radius = 20

    if dice == 1 then
        _x = math.random(_radius, love.graphics.getWidth())
        _y = -_radius * 2
    elseif dice == 2 then
        _x = -_radius * 2
        _y = math.random(_radius, love.graphics.getHeight())
    elseif dice == 3 then
        _x = math.random(_radius, love.graphics.getWidth())
        _y = love.graphics.getHeight()+ _radius * 2
    else 
        _x = love.graphics.getWidth() + _radius * 2
        _y = math.random(_radius, love.graphics.getHeight())
    end
    -- Randomizing direction that enemy will spawn from offscreen

    return {
        level = level or 1,
        radius = _radius,
        x = _x,
        y = _y,

        checkTouched = function (self, player_x, player_y)
            return math.sqrt((self.x - player_x)^2) <= QUAD_WIDTH/3 and math.sqrt((self.y - player_y) ^2) <= QUAD_HEIGHT/2
        end,

        checkHit = function(self, bullet_x, bullet_y)
            return math.sqrt((self.x - bullet_x)^2) <= self.radius and math.sqrt((self.y - bullet_y)^2) <= self.radius
        end,

        move = function (self, player_x, player_y)
            if player_x - self.x > 0 then
                self.x = self.x + self.level
            elseif player_x - self.x < 0 then
                self.x = self.x - self.level
            end

            if player_y - self.y > 0 then
                self.y = self.y + self.level
            elseif player_y - self.y < 0 then
                self.y = self.y - self.level
            end
        end,
        -- Enemy's default movement is to move towards player location


        draw = function (self)
            love.graphics.setColor(1, 1, 1)
            love.graphics.circle("fill", self.x, self.y, self.radius)
        end
    }
end

return Enemy