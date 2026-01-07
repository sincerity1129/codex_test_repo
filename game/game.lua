local Board = require("game.board")
local Piece = require("game.piece")
local LevelLoader = require("game.level_loader")

local Game = {}
Game.__index = Game

function Game.new()
  local self = setmetatable({}, Game)
  self.cols = 10
  self.rows = 20
  self.cell_size = 24
  self.offset_x = 40
  self.offset_y = 40
  self.board = Board.new(self.cols, self.rows)
  self.level = 1
  self.score = 0
  self.lines = 0
  self.state = "playing"
  self.drop_timer = 0
  self.current = Piece.random()
  self.next = Piece.random()
  self:load_level()
  return self
end

function Game:load_level()
  self.level_data = LevelLoader.load(self.level)
  self.drop_interval = self.level_data.drop_interval
  self.target_lines = self.level_data.target_lines
  self.score_multiplier = self.level_data.score_multiplier
end

function Game:valid_position(piece, offset_x, offset_y, rotation)
  for _, cell in ipairs(piece:cells(offset_x, offset_y, rotation)) do
    if not self.board:inside(cell.x, cell.y) or not self.board:is_empty(cell.x, cell.y) then
      return false
    end
  end
  return true
end

function Game:lock_piece()
  self.board:lock_piece(self.current)
  local cleared = self.board:clear_lines()
  if cleared > 0 then
    self.lines = self.lines + cleared
    self.score = self.score + math.floor(100 * cleared * self.score_multiplier)
  end
  if self.lines >= self.target_lines then
    self:advance_level()
  end
  self.current = self.next
  self.current.x = 4
  self.current.y = 1
  self.next = Piece.random()
  if not self:valid_position(self.current) then
    self.state = "game_over"
  end
end

function Game:advance_level()
  if self.level < 100 then
    self.level = self.level + 1
    self.lines = 0
    self:load_level()
  end
end

function Game:hard_drop()
  while self:valid_position(self.current, self.current.x, self.current.y + 1, self.current.rotation) do
    self.current.y = self.current.y + 1
  end
  self:lock_piece()
end

function Game:update(dt)
  if self.state ~= "playing" then
    return
  end
  self.drop_timer = self.drop_timer + dt
  if self.drop_timer >= self.drop_interval then
    self.drop_timer = self.drop_timer - self.drop_interval
    if self:valid_position(self.current, self.current.x, self.current.y + 1, self.current.rotation) then
      self.current.y = self.current.y + 1
    else
      self:lock_piece()
    end
  end
end

function Game:keypressed(key)
  if key == "r" then
    return self:reset()
  end
  if self.state ~= "playing" then
    return
  end
  if key == "left" then
    if self:valid_position(self.current, self.current.x - 1, self.current.y, self.current.rotation) then
      self.current.x = self.current.x - 1
    end
  elseif key == "right" then
    if self:valid_position(self.current, self.current.x + 1, self.current.y, self.current.rotation) then
      self.current.x = self.current.x + 1
    end
  elseif key == "down" then
    if self:valid_position(self.current, self.current.x, self.current.y + 1, self.current.rotation) then
      self.current.y = self.current.y + 1
    end
  elseif key == "up" then
    local next_rot = self.current:rotate(1)
    if self:valid_position(self.current, self.current.x, self.current.y, next_rot) then
      self.current.rotation = next_rot
    end
  elseif key == "space" then
    self:hard_drop()
  end
end

function Game:reset()
  self.board = Board.new(self.cols, self.rows)
  self.level = 1
  self.score = 0
  self.lines = 0
  self.state = "playing"
  self.drop_timer = 0
  self.current = Piece.random()
  self.next = Piece.random()
  self:load_level()
end

function Game:draw_panel()
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(string.format("Level: %d", self.level), 320, 60)
  love.graphics.print(string.format("Score: %d", self.score), 320, 90)
  love.graphics.print(string.format("Lines: %d/%d", self.lines, self.target_lines), 320, 120)
  love.graphics.print("Next:", 320, 160)
  for _, cell in ipairs(self.next:cells(0, 0, self.next.rotation)) do
    love.graphics.setColor(self.next.color)
    love.graphics.rectangle("fill", 320 + cell.x * 16, 190 + cell.y * 16, 14, 14)
  end
  love.graphics.setColor(1, 1, 1)
  love.graphics.print("Controls:", 320, 280)
  love.graphics.print("Arrows: move/rotate", 320, 300)
  love.graphics.print("Space: hard drop", 320, 320)
  love.graphics.print("R: restart", 320, 340)
end

function Game:draw()
  self.board:draw(self.cell_size, self.offset_x, self.offset_y)
  if self.state == "playing" then
    for _, cell in ipairs(self.current:cells()) do
      love.graphics.setColor(self.current.color)
      love.graphics.rectangle("fill", self.offset_x + (cell.x - 1) * self.cell_size, self.offset_y + (cell.y - 1) * self.cell_size, self.cell_size - 1, self.cell_size - 1)
    end
  end
  self:draw_panel()
  if self.state == "game_over" then
    love.graphics.setColor(1, 0.3, 0.3)
    love.graphics.print("Game Over", 140, 320, 0, 2, 2)
  end
end

return Game
