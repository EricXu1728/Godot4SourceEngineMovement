My attempt at putting [OakleyCyclop's ](https://github.com/OakleyCyclops/GodotSourceEngineMovement) Godot3 source movement into godot4.

Did my best to try to clean everything up.

This branch is not entirely to source movement. The goal of this branch is to continue work on the project that has been mostly abandoned, as well as add some modern features to make gameplay smoother. I want to use this as a starting point for my own game and will make a sperate branch/fork for something like that

# Qol added not part of original source
- Automatically jump as soon as possible with space held (Auto bunny hop)
- Coyote time 

# To-Do List
- [x] Airstrafing
- [x] Bunnyhopping
- [x] Wallstrafing
- [x] Zig-Zagging
- [x] Surfing (broke in transition to Godot 4)
- [x] Crouching
- [x] Collision modifying when crouching
- [x] Crouch-Jumping
- [x] Gravity
- [x] Ground Friction
- [x] Sticks to ground on shallow slopes
- [ ] Accelerated Back Hop
- [ ] Swimming

# How it works
- Player is controlled by two state machines:
	- activtyMachine controls if the player is on the ground or in the air. (And if it is swimming in the future)
	- standingMachine controls the crouching, keeping track of if it is standing, mid-crouching, and crouched
