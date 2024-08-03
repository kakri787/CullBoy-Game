local love = require "love"

function Enemy(level, type, width, height, hp)
    local dice = math.random(1, 4)
    local _x, _y
    local _radius = width/8

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
        level = level,
        x = _x,
        y = _y,
        hp = hp,
        sprite_width = width,
        sprite_height = height,
        quad_width = width/8,
        quad_height = height,
        sprite = type,
        animation = {
            direction = "left",
            max_frames = 8,
            frame = 1,
            timer = 0.1
        },

        -- Note that collision detection arithmetic varies for different sprite models
        checkTouched = function (self, player_x, player_y)
            return math.sqrt((self.x - player_x)^2) <= (self.quad_width/2) and math.sqrt((self.y - player_y)^2) <= (self.quad_height/2 + 20)
            -- Collision detection arithmetic between player model and cactus enemy
        end,

        checkHit = function(self, bullet_x, bullet_y)
            return math.sqrt((self.x - bullet_x)^2) <= (self.quad_width/3 - self.quad_width/10) and math.sqrt((self.y - bullet_y)^2) <= (self.quad_height/2 - self.quad_height/10)
            -- Collision detection arithmetic between bullet and cactus enemy
        end,

        move = function (self, player_x, player_y, dt)
            if player_x - self.x > 0 then
                self.x = self.x + self.level
                self.animation.direction = "right"
            elseif player_x - self.x < 0 then
                self.x = self.x - self.level
                self.animation.direction = "left"
            end

            if player_y - self.y > 0 then
                self.y = self.y + self.level
            elseif player_y -self.y < 0 then
                self.y = self.y - self.level
            end


            self.animation.timer = self.animation.timer + dt
            if self.animation.timer > 0.1 + dt then
                self.animation.timer = 0.1
                self.animation.frame = self.animation.frame + 1
                if self.animation.frame > self.animation.max_frames then
                    self.animation.frame = 1
                end
            end
        end,
        -- Enemy's default movement is to move towards player location


        draw = function(self)
            local quads = {}
            for i = 1, self.animation.max_frames do
                quads[i] = love.graphics.newQuad(self.quad_width * (i-1), 0,  self.quad_width, self.quad_height, self.sprite_width, self.sprite_height)
            end
            -- The loop segments spritesheet of 8 quads into individual quads into quads{} table

            if self.animation.direction == "left" then
                love.graphics.draw(self.sprite, quads[self.animation.frame], self.x, self.y, 0, 1, 1, self.quad_width/2, self.quad_height/2)
            elseif self.animation.direction == "right" then
                love.graphics.draw(self.sprite, quads[self.animation.frame], self.x, self.y, 0, -1, 1, self.quad_width/2, self.quad_height/2)
            end
        end
    }
end

return Enemy