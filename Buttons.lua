local love = require "love"

function Button(image, func, func_param, x, y)
    return {
        func = func or function() print("This button has no function attached") end,
        func_param = func_param,
        width = image:getWidth(),
        height = image:getHeight(),
        button_x = x,
        button_y = y,

        checkPressed = function (self, mouse_x, mouse_y)
            if (mouse_x >= self.button_x and mouse_x <= self.button_x + self.width) and (mouse_y >= self.button_y and mouse_y <= self.button_y + self.height) then
                if self.func_param then
                    self.func(self.func_param)
                else
                    self.func()
                end
            end
        end,

        draw = function(self)
            love.graphics.draw(image, self.button_x, self.button_y)
        end
    }
end

return Button