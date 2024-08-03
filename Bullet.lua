local love = require "love"

function Bullet(x, y, direction)
    local speed = 8
    local x_right, x_left, x_vertical = 41, -41, 53
    local y_up, y_down, y_lateral = 23, 79, 13
    local explosion = love.graphics.newImage("entities/bulletexplosion.png")

    if direction == "right" then
        x = x + x_right
        y = y + x_vertical
    elseif direction == "left" then
        x = x + x_left
        y = y + x_vertical
    elseif direction == "up" then
        x = x + y_lateral
        y = y + y_up
    elseif direction == "down" then
        x = x + y_lateral
        y = y + y_down
    end

    return {
        x = x,
        y = y,
        direction = direction,
        distance = 0,
        hitTarget = false,

        draw = function(self)
            love.graphics.setColor(1, 1, 1)
            love.graphics.setPointSize(3)
            love.graphics.points(self.x, self.y)

            if self.hitTarget == true then
                love.graphics.draw(explosion, self.x, self.y, 0, 2, 2, 5, 5)
            end

        end,

        move = function(self)
            if self.direction == "right" then
                self.x = self.x + speed
            elseif self.direction == "left" then
                self.x = self.x - speed
            elseif self.direction == "up" then
                self.y = self.y - speed
            elseif self.direction == "down" then
                self.y = self.y + speed
            end
            self.distance = self.distance + speed
        end
    }
end

return Bullet