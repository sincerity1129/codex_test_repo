# Simple Tetris (LÖVE2D)

A lightweight Tetris implementation built with **LÖVE2D (Lua)**, a game-focused framework. The game includes **100 progression levels**, each defined in its own file for easy tuning and refactoring.

## Features

- Classic 10x20 Tetris board
- 7 standard tetrominoes
- 1–100 level progression (each level in a separate file)
- Scoring and line goals per level
- Keyboard controls + hard drop

## Requirements

- [LÖVE2D](https://love2d.org/) 11.x

## Run

```bash
love .
```

## Controls

- **Left/Right**: move
- **Up**: rotate
- **Down**: soft drop
- **Space**: hard drop
- **R**: restart

## Level Files

Each level is a separate file under `levels/`.

Example: `levels/level01.lua`

```lua
return {
  level = 1,
  drop_interval = 0.900,
  target_lines = 6,
  score_multiplier = 1.00
}
```

You can tweak any level independently without touching the main game logic.

## Project Structure

```
.
├── conf.lua
├── main.lua
├── game/
│   ├── board.lua
│   ├── game.lua
│   ├── level_loader.lua
│   ├── piece.lua
│   └── pieces.lua
└── levels/
    ├── level01.lua
    ├── ...
    └── level100.lua
```
