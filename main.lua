_G.love = require "love"
local Player = require "Player"
local Enemy = require"Enemy"
local Game = require "Game"
local Button = require "Buttons"

math.randomseed(os.time())
-- Ensures that every instance of the game is different

local player = Player()
local enemies = {}
local spawn_timer = 0.1
local game = Game()
local buttons = {
    menu_state = {},
    ended_state = {},
    paused_state = {}
}

local buttonIcons = {
    play = love.graphics.newImage("buttons/playbutton.png"),
    exit = love.graphics.newImage("buttons/exitbutton.png"),
    resume = love.graphics.newImage("buttons/resumebutton.png"),
    menu = love.graphics.newImage("buttons/menubutton.png"),
    restart = love.graphics.newImage("buttons/restartbutton.png")
}

local function center(type, length)
    if type == "width" then
        return (love.graphics.getWidth() - length) / 2
    elseif type == "height" then
        return (love.graphics.getHeight()- length) / 2
    end
end

local function startNewGame()
    game:changeGameState("running")
    player.x, player.y = (love.graphics.getWidth() - QUAD_WIDTH)/2 + QUAD_WIDTH/2, (love.graphics.getHeight() - QUAD_HEIGHT)/2
    player.animation.direction = "right"
    enemies = {}
    player.animation.bullets = {}
    -- Reset the player's position and direction, and also remove every enemy and bullet on the screen
end

local function changeGameState(state)
    game:changeGameState(state)
end

function love.keypressed(key)
    if key == "escape" then
        if game.state.running then
            game:changeGameState("paused")
        elseif game.state.paused then
            game:changeGameState("running")
        end
    end
end

function love.mousepressed(x, y, button, presses)
    if not game.state.running then
            if game.state.menu then
                for index in pairs(buttons.menu_state) do
                    buttons.menu_state[index]:checkPressed(x, y)
                end
            elseif game.state.paused then
                for index in pairs(buttons.paused_state) do
                    buttons.paused_state[index]:checkPressed(x, y)
                end
            else
                for index in pairs(buttons.ended_state) do
                    buttons.ended_state[index]:checkPressed(x, y)
                end
            end
    end
end

function love.load()
    buttons.menu_state.play = Button(buttonIcons.play, startNewGame, nil, center("width", buttonIcons.play:getWidth()), 300)
    buttons.menu_state.exit = Button(buttonIcons.exit, love.event.quit, nil, center("width", buttonIcons.exit:getWidth()), 450)

    buttons.paused_state.resume = Button(buttonIcons.resume, changeGameState, "running", center("width", buttonIcons.resume:getWidth()), 200)
    buttons.paused_state.restart = Button(buttonIcons.restart, startNewGame, nil, center("width", buttonIcons.restart:getWidth()), 350)
    buttons.paused_state.menu = Button(buttonIcons.menu, changeGameState, "menu", center("width", buttonIcons.menu:getWidth()), 500)

    buttons.ended_state.restart = Button(buttonIcons.restart, startNewGame, nil, center("width", buttonIcons.restart:getWidth()), 300)
    buttons.ended_state.exit = Button(buttonIcons.exit, love.event.quit, nil, center("width", buttonIcons.exit:getWidth()), 450)
end

function love.update(dt)
    if game.state.running then
        love.mouse.setVisible(false)
        player:move(dt)

        spawn_timer = spawn_timer + dt

        if spawn_timer > 2 then
            table.insert(enemies, Enemy(1))
            spawn_timer = 0.1
        end
        -- An enemy will spawn every 2 seconds

        for index, enemy in pairs(enemies) do
            if not enemy:checkTouched(player.x, player.y+QUAD_HEIGHT/2) then
                enemy:move(player.x, player.y+QUAD_HEIGHT/2)

                for _, bullet in pairs(player.animation.bullets) do
                    if enemy:checkHit(bullet.x, bullet.y) then
                        bullet.hitTarget = true
                        table.remove(enemies, index)
                    end
                end
            else
                changeGameState("ended")
            end
        end
    else
        love.mouse.setVisible(true)
    end
end

function love.draw()
    if game.state.menu then
        for index in pairs(buttons.menu_state) do
            buttons.menu_state[index]:draw()
        end
    elseif not game.state.menu and not game.state.ended then
        player:draw()

        for i = 1, #enemies do
            enemies[i]:draw()
        end

        if game.state.paused then
            for index in pairs(buttons.paused_state) do
                buttons.paused_state[index]:draw()
            end
        end
    elseif game.state.ended then
        for index in pairs(buttons.ended_state) do
            buttons.ended_state[index]:draw()
        end
    end
end

