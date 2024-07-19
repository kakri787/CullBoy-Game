local love = require "love"

function Bullet(x, y)
    local speed = 500
    return {
        x = x,
        y = y,

        draw = function(self)
            love.graphics.setColor(1, 1, 1)
            love.graphics.setPointSize(3)
            love.graphics.points(self.x, self.y)
        end
    }
end

return Bullet