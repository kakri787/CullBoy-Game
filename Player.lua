local love = require "love"
local bullet = require "Bullet"

function Player()
    _G.SPRITE_WIDTH, _G.SPRITE_HEIGHT = 800, 100
    _G.QUAD_WIDTH, _G.QUAD_HEIGHT = 100, SPRITE_HEIGHT
    local _x, _y = (love.graphics.getWidth() - QUAD_WIDTH)/2, (love.graphics.getHeight() - QUAD_HEIGHT)/2
    local MAX_BULLET_DISTANCE = 650

    return {
        x = _x,
        y = _y,
        sprite = love.graphics.newImage("entities/player.png"),
        sprite_up = love.graphics.newImage("entities/player2.png"),
        sprite_down = love.graphics.newImage("entities/player3.png"),
        animation = {
            direction = "right",
            idle = true,
            shooting = false,
            fireRate = 0.2,
            bullets = {},
            frame = 1,
            max_frames = 8,
            speed = 3,
            timer = 0.1,
        },

        move = function(self, dt)
            if self.x < 0 + QUAD_WIDTH/2 then
                self.x = QUAD_WIDTH/2
            elseif self.x > love.graphics.getWidth() - QUAD_WIDTH/2 then
                self.x = love.graphics.getWidth() - QUAD_WIDTH/2
            end
            if self.y < 0 then
                self.y = 0
            elseif self.y > love.graphics.getHeight() - QUAD_HEIGHT then
                self.y = love.graphics.getHeight() - QUAD_HEIGHT
            end
            -- This prevents player from moving outside of screen

            -- Below are the controls for player movement
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

            if not self.animation.idle then
                self.animation.timer = self.animation.timer + dt
                if self.animation.timer > 0.1 + 5 * dt then
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

            -- Below are the controls for shooting
            if love.keyboard.isDown("up") then
                self.animation.direction = "up"
                self.animation.shooting = true
            end
            if love.keyboard.isDown("right") then
                self.animation.direction = "right"
                self.animation.shooting = true
            end
            if love.keyboard.isDown("left") then
                self.animation.direction = "left"
                self.animation.shooting = true
            end
            if love.keyboard.isDown("down") then
                self.animation.direction = "down"
                self.animation.shooting = true
            end

            if not love.keyboard.isDown('w', 'a', 's', 'd') then
                self.animation.idle = true
                self.animation.frame = 1
            end

            if not love.keyboard.isDown('up', 'down', 'left', 'right') then
                self.animation.shooting = false
                self.animation.fireRate = 0.22
                -- Sets idle fireRate value to 0.22 to allow tapping arrow keys to fire a bullet
            end

            if self.animation.shooting then
                if self.animation.fireRate == 0.22 then
                    table.insert(self.animation.bullets, bullet(self.x, self.y, self.animation.direction))
                end
                -- When idle default the fireRate value is 0.22 therefore a bullet will be fired immediately when tapping or holding down arrow key

                self.animation.fireRate = self.animation.fireRate + dt
                if self.animation.fireRate > 0.2 + 12 * dt then
                    table.insert(self.animation.bullets, bullet(self.x, self.y, self.animation.direction))
                    self.animation.fireRate = 0.2
                end
                -- When arrow keys are held down bullets will fire every 0.2 seconds which is equivalent to 12 times of dt
                -- Every frame dt is added to fireRate and once its exceeds the above threshold then the next bullet will be fired
                -- fireRate is resetted to 0.2 after bullet is fired
            end

            for index, newBullet in pairs(self.animation.bullets) do
                newBullet:move()
                if newBullet.distance > MAX_BULLET_DISTANCE or newBullet.hitTarget == true or newBullet.x < 0 or newBullet.x > love.graphics.getWidth() or newBullet.y < 0 or newBullet.y > love.graphics.getHeight() then
                    table.remove(self.animation.bullets, index)
                end
            end
        end,

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

            for _, newBullet in pairs(self.animation.bullets) do
                newBullet:draw()
            end
        end
    }
end

return Player