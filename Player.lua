local love = require "love"

function Player()
    _G.SPRITE_WIDTH, _G.SPRITE_HEIGHT = 800, 100
    _G.QUAD_WIDTH, _G.QUAD_HEIGHT = 100, SPRITE_HEIGHT
    local _x, _y = (love.graphics.getWidth() - QUAD_WIDTH)/2, (love.graphics.getHeight() - QUAD_HEIGHT)/2

    return {
        x = _x,
        y = _y,
        sprite = love.graphics.newImage("entities/player.png"),
        sprite_up = love.graphics.newImage("entities/player2.png"),
        sprite_down = love.graphics.newImage("entities/player3.png"),
        animation = {
            direction = "right",
            idle = true,
            frame = 1,
            max_frames = 8,
            speed = 3,
            timer = 0.1,
        },

        draw = function(self)

            local quads = {}
            for i = 1, self.animation.max_frames do
                quads[i] = love.graphics.newQuad(QUAD_WIDTH * (i-1), 0,  QUAD_WIDTH, QUAD_HEIGHT, SPRITE_WIDTH, SPRITE_HEIGHT)
            end
            -- The loop segments spritesheet of 8 quads into individual quads into quads{} table

            if self.animation.direction == "left" then
                love.graphics.draw(self.sprite, quads[self.animation.frame], self.x, self.y, 0, -1, 1, QUAD_WIDTH/2)
            end
            if self.animation.direction == "right" then
                love.graphics.draw(self.sprite, quads[self.animation.frame], self.x, self.y, 0, 1, 1, QUAD_WIDTH/2)
            end
            if self.animation.direction == "up" then
                love.graphics.draw(self.sprite_up, quads[self.animation.frame], self.x, self.y, 0, 1, 1, QUAD_WIDTH/2)
            end
            if self.animation.direction == "down" then
                love.graphics.draw(self.sprite_down, quads[self.animation.frame], self.x, self.y, 0, 1, 1, QUAD_WIDTH/2)
            end
        end,


        move = function(self, dt)
            if love.keyboard.isDown("w") then
                self.animation.idle = false
                self.y = self.y - self.animation.speed
            end
            if love.keyboard.isDown("a") then
                self.animation.idle = false
                self.animation.direction = "left"
                self.x = self.x - self.animation.speed
            end
            if love.keyboard.isDown("s") then
                self.animation.idle = false
                self.y = self.y + self.animation.speed
            end
            if love.keyboard.isDown("d") then
                self.animation.idle = false
                self.animation.direction = "right"
                self.x = self.x + self.animation.speed
            end

            if love.keyboard.isDown("up") then
                self.animation.direction = "up"
            end
            if love.keyboard.isDown("right") then
                self.animation.direction = "right"
            end
            if love.keyboard.isDown("left") then
                self.animation.direction = "left"
            end
            if love.keyboard.isDown("down") then
                self.animation.direction = "down"
            end

            if not love.keyboard.isDown('w', 'a', 's', 'd') then
                self.animation.idle = true
                self.animation.frame = 1
            end
            -- The default quad to use is the first frame when player is not moving

             if not self.animation.idle then
                self.animation.timer = self.animation.timer + dt
                if self.animation.timer > 0.1 + dt then
                    self.animation.timer = 0.1
                    self.animation.frame = self.animation.frame + 1
                    if self.animation.frame > self.animation.max_frames then
                        self.animation.frame = 1
                    end
                end
            end
            -- When sprite is moving the timer increments by 1/60 of a frame
            -- When timer exceeds the time difference between frames set the sprite to be its next frame
            -- When all frames are exhausted reset sprite to its first frame and loop the animation set
        end

    }

end

return Player