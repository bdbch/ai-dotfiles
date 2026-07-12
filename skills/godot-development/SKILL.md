---
name: "godot-development"
description: "Build Godot 2D games — GDScript, scene composition, signals, physics, animation, and performance."
---

# Godot Development

> Build Godot 2D games — GDScript, scene composition, signals, physics, animation, and performance.

## When to use

Use this skill when working with Godot 2D projects: game logic, scenes, nodes, autoloads, resources, or GDScript.

## Core principles

### GDScript mastery
- Write clean, statically typed GDScript with type hints everywhere
- Use `@export` for designer-facing properties — typed, with defaults
- Use `@onready var` for cached node references — prefer `%UniqueName` or `$NodePath`
- Use `match` over `if-elif` chains
- Use `class_name` for reusable types, not one-off scripts
- Use `@tool` scripts only when necessary

### Node hierarchy and composition
- Compose behavior through node composition, not deep inheritance
- `CharacterBody2D` for player/NPC movement with `move_and_slide()`
- `Area2D` for triggers, pickups, hitboxes — prefer signals over polling
- `RigidBody2D` for physics-driven objects — let the engine simulate
- `TileMapLayer` for level geometry with navigation and data layers

### Signal-driven architecture
- Children signal up, parents react
- Siblings communicate through shared ancestor or autoload event bus
- Autoloads emit global events (`GameEvents.player_died.emit()`)
- Disconnect signals in `_exit_tree()` when connecting outside subtree
- Never connect signals in `_process`

### Physics and movement
- Collision layers and masks — declare what body IS and what it SCANS
- `move_and_slide()` for kinematics, `move_and_collide()` for step-by-step
- Delta timing: multiply by `delta` in `_process`; physics applies it automatically in `_physics_process`

### Input handling
- Use `InputMap` for action definitions — never poll keycodes directly
- `Input.is_action_pressed()` in `_physics_process` for continuous input
- `Input.is_action_just_pressed()` in `_process` for discrete actions
- `_unhandled_input(event)` for UI-layer-bypassable inputs

### Animation and tweening
- `AnimationPlayer` for complex keyframeable sequences
- `Tween` (`create_tween()`) for procedural one-shot animations
- Use `ease()` and `trans` types for the right feel
- Never start tweens in `_process` without guards

### Performance
- Profile first with Godot debugger
- Use `VisibleOnScreenNotifier2D` to disable off-screen processing
- Object pooling for frequently spawned/destroyed objects
- Flatten deep node trees — nested nodes add transform overhead

### Shaders for 2D
- `canvas_item` shaders for visual effects
- Use `hint_color` uniforms for designer-friendly parameters
- Know when a shader is overkill — tweens or particles may be simpler

### Audio
- `AudioStreamPlayer2D` for spatial 2D audio
- `AudioBus` layout for mixing (Master, SFX, Music, UI)
- Fade-in/fade-out via `Tween` on bus volume

## What to do before coding

1. Read existing `.gd` and `.tscn` files to understand patterns
2. Check `project.godot` for existing plugin config
3. Understand node hierarchy before making changes
