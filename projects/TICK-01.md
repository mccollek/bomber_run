# TICK-01: Project Scaffold & Settings

**Status:** TODO
**Priority:** Critical
**Blocks:** All other tickets

## Description
Create the Godot project with correct settings for a 480x720 pixel-art vertical scroller.

## Tasks
- [ ] Create `project.godot` with:
  - Viewport: 480x720
  - Stretch mode: `canvas_items`
  - Stretch aspect: `keep`
  - Texture filter: `Nearest`
  - Window title: "Bomber Run"
- [ ] Create folder structure:
  ```
  bomber_run/
  ├── assets/
  │   ├── sprites/
  │   ├── audio/
  │   └── fonts/
  ├── scenes/
  │   ├── player/
  │   ├── enemies/
  │   ├── world/
  │   ├── effects/
  │   └── ui/
  ├── scripts/
  │   ├── autoload/
  │   └── resources/
  └── projects/
  ```
- [ ] Create `main.tscn` as root scene (empty Node2D with basic structure)
- [ ] Create `game_manager.gd` autoload script (skeleton with signal definitions)
- [ ] Set up collision layer names in project settings
- [ ] Create `.gitignore` for Godot project (ignore `.godot/` directory)

## Acceptance Criteria
- Project opens cleanly in Godot 4.6 editor
- Running the project shows a blank 480x720 window with correct title
- Folder structure is in place
- Collision layers are named
