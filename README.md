# PixelOrb

> An open source Godot puzzle game

![PixelOrb GIF](https://raw.githubusercontent.com/alex-karev/PixelOrb/main/PixelOrb.gif)
---

## Play
-- You can play it on Itch.io!<br/>
https://sandebru.itch.io/pixelorb

Or download it for Android<br/>
https://play.google.com/store/apps/details?id=org.godotengine.pixelorbitch

---

## About
PixelOrb is a free and open-source cross-platform puzzle game build with Godot Engine.

---

## Changelog
https://github.com/alex-karev/PixelOrb/blob/main/CHANGELOG.md

---

## Installation
Open Godot Engine (standard version 3.x), press import button, navigate to this project's folder and select project.godot.

---

## Features
- Randomly generated puzzles from pixel art spritesheet.
- Pixel art with any resolution, any amount of sprites, each sprite is a level.
- 100% GDscript.
- Two scenes, one for the app itself and one for the puzzle. Puzzle scene is placed inside viewport node on the App scene, which allows using shader-based post-processing and custom backgrounds.
- Relatively small codebase. Commented.
- GUI/Audio/Spritesheet managers, Puzzle Controller, Puzzle generator and singleton for handling global events.
- Mobile support

---

## FAQ
- **How do I replace the spritesheet?**
    - App.tscn -> Spritesheet node -> replace texture -> Done! **Remember to change "cellSize" and "items" variables as well!** Cell size is the size of one sprite, items is the overall amount of items on the spritesheet
- **Can it be used for creating non-pixelart puzzles?**
    - Don't think so. It's not using particle system, so performance is going to be awful. Also, gameplay with 64x64 puzzles already seems to be much less challenging. But you are always welcome to try!

---

## Credits
- Sprites/spritesheet1.png - **Alex's Assets / alexs-assets.itch.io**
    https://alexs-assets.itch.io/16x16-rpg-item-pack
    https://alexs-assets.itch.io/16x16-rpg-item-pack

- Audio/* - **Irina Kareva**
   https://youtu.be/tlTqCDG8DvQ
---

## Contributing

You are free to fork this repo and to create pull requests.

---

## Donations

To support the project you can donate money on the game's itch.io page:
https://sandebru.itch.io/pixelorb
