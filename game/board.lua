local Board = {}
Board.__index = Board

function Board.new(cols, rows)
  local self = setmetatable({}, Board)
  self.cols = cols
  self.rows = rows
  self.grid = {}
  for y = 1, rows do
    self.grid[y] = {}
    for x = 1, cols do
      self.grid[y][x] = nil
    end
  end
  return self
end

function Board:inside(x, y)
  return x >= 1 and x <= self.cols and y >= 1 and y <= self.rows
end

function Board:is_empty(x, y)
  return self:inside(x, y) and self.grid[y][x] == nil
end

function Board:lock_piece(piece)
  for _, cell in ipairs(piece:cells()) do
    local x = cell.x
    local y = cell.y
    if self:inside(x, y) then
      self.grid[y][x] = piece.color
    end
  end
end

function Board:clear_lines()
  local cleared = 0
  for y = self.rows, 1, -1 do
    local full = true
    for x = 1, self.cols do
      if self.grid[y][x] == nil then
        full = false
        break
      end
    end
    if full then
      table.remove(self.grid, y)
      local new_row = {}
      for x = 1, self.cols do
        new_row[x] = nil
      end
      table.insert(self.grid, 1, new_row)
      cleared = cleared + 1
      y = y + 1
    end
  end
  return cleared
end

function Board:draw(cell_size, offset_x, offset_y)
  love.graphics.setColor(0.2, 0.2, 0.25)
  love.graphics.rectangle("line", offset_x, offset_y, self.cols * cell_size, self.rows * cell_size)
  for y = 1, self.rows do
    for x = 1, self.cols do
      local color = self.grid[y][x]
      if color then
        love.graphics.setColor(color)
        love.graphics.rectangle("fill", offset_x + (x - 1) * cell_size, offset_y + (y - 1) * cell_size, cell_size - 1, cell_size - 1)
      end
    end
  end
end

return Board
