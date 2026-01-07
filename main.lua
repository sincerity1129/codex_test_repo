local Game = require("game.game")

local game

function love.load()
  love.graphics.setBackgroundColor(0.08, 0.08, 0.1)
  game = Game.new()
end

function love.update(dt)
  game:update(dt)
end

function love.draw()
  game:draw()
end

function love.keypressed(key)
  game:keypressed(key)
end
