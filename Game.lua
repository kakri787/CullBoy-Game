function Game()
    return {
        state = {
            menu = true,
            paused = false,
            running = false,
            ended = false
        },

        changeGameState = function (self, state)
            self.state.menu = state == "menu"
            self.state.paused = state == "paused"
            self.state.running = state == "running"
            self.state.ended = state == "ended"
        end
    }
end

return Game