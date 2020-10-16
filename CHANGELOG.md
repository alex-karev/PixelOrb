# Changelog

---

## [0.2] - 2020-10-14

This update generally makes game run on mobile platforms, adds menus and changes GUI.

### Added
- Level menu
- About menu
- Shader for orbs
- **Mobile support**
- Adaptive icon for mobile

### Changed
- Orbs are made using MeshInstance and a custom shader instead of AnimatedSprite3D. AnimatedSprite3D has a very bad performance on mobile (GODOT Engine issue \# 20855)
- New GUI, mobile optimized
- PuzzleGenerator.gd and fake_perspective() in Puzzle.gd changed to work with new orbs improvement
- Sound volume decreased
- **Fixed** level now stars from 1

### Removed
- Level counter (replaced with menu button)
- Titles in the end (replaced with about menu). After beating all the levels, game starts from level 1

---

## [0.1] - 2020-10-6
### Added
- The first version
