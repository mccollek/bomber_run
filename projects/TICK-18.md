# TICK-18: GitHub Repo Setup & README

**Status:** TODO
**Priority:** Medium
**Depends on:** All other tickets

## Description
Initialize git repo, push to GitHub under mccollek profile, and create a project README.

## Tasks
- [ ] Initialize git repo in `bomber_run/`
- [ ] Create `.gitignore`:
  ```
  .godot/
  *.import
  export_presets.cfg
  ```
- [ ] Create `README.md`:
  - Game title and description
  - Screenshot/GIF placeholder
  - Controls reference
  - How to run (requires Godot 4.6)
  - Credits
  - License (MIT)
- [ ] Create `LICENSE` file (MIT)
- [ ] Initial commit with full project
- [ ] Create GitHub repo: `mccollek/bomber_run`
- [ ] Push to remote

## Acceptance Criteria
- Repository is public on GitHub at `mccollek/bomber_run`
- README clearly explains what the project is and how to run it
- `.gitignore` prevents Godot cache files from being committed
- Clean commit history
