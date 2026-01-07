local Pieces = require("game.pieces")

local Piece = {}
Piece.__index = Piece

function Piece.new(def)
  local self = setmetatable({}, Piece)
  self.def = def
  self.rotation = 1
  self.x = 4
  self.y = 1
  self.color = def.color
  return self
end

function Piece:cells(offset_x, offset_y, rotation)
  local cells = {}
  local rot = rotation or self.rotation
  local shape = self.def.rotations[rot]
  local base_x = (offset_x or self.x)
  local base_y = (offset_y or self.y)
  for _, point in ipairs(shape) do
    table.insert(cells, { x = base_x + point[1], y = base_y + point[2] })
  end
  return cells
end

function Piece:rotate(direction)
  local next_rot = self.rotation + direction
  if next_rot < 1 then
    next_rot = 4
  elseif next_rot > 4 then
    next_rot = 1
  end
  return next_rot
end

function Piece.random()
  local def = Pieces.definitions[love.math.random(#Pieces.definitions)]
  return Piece.new(def)
end

return Piece
