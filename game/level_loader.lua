local LevelLoader = {}

function LevelLoader.load(level)
  local filename = string.format("levels/level%02d", level)
  local ok, data = pcall(require, filename)
  if ok then
    return data
  end
  return {
    level = level,
    drop_interval = 0.8,
    target_lines = 10,
    score_multiplier = 1.0
  }
end

return LevelLoader
