# Microvania — Development Context

## Project Overview

Microvania is a 2D metroidvania made in Godot using GDScript.

The target is a **fast-paced game with easy-to-understand, tight controls**. Movement should feel responsive without becoming unnecessarily complicated.

### Core design direction

- 2D metroidvania.
- Fast-paced movement.
- Tight, responsive controls.
- No super dash.
- There should not be a selectable difficulty setting; the game has one intended difficulty.
- The player should learn the mechanics through the game rather than through a difficulty menu.

---

## Current Development Status

This project is still under active development.

Important distinction:

- **Implemented** means the feature is currently in the project.
- **Planned** means it has been discussed/designed but may not exist in the code yet.
- Do not assume a planned feature has already been implemented.

The orb system is being developed and has not necessarily reached its final implementation.

---

## Player Movement

The player is a `CharacterBody2D`.

The current movement code has used values approximately like:

```gdscript
const MAX_SPEED = 70.0
const ACCELERATION = 14.5
const FRICTION = 20.5
const JUMP_HEIGHT = -250.0
const GRAVITY = 16.5
```

Horizontal movement uses smoothed acceleration/friction rather than instantly setting the horizontal velocity.

The project uses input actions such as:

```text
Move_left
Move_right
```

The movement system is intended to feel responsive and controlled.

### Dash

A dash is planned as part of the movement/orb system.

Important decisions:

- There is **no super dash**.
- The intended dash duration is currently **0.25 seconds**.
- `dash_unlocked` has been used/planned so that the dash can remain locked until it is obtained.
- The dash should not feel endlessly spammable.

Previous experimental values should not automatically be treated as final.

---

# Orb System

The orb system is one of Microvania's main mechanics.

The player has floating companion orbs that can eventually provide movement and other abilities.

The intended structure is:

```text
Player
└── OrbManager (Node2D)
    └── Orb
        ├── Sprite2D
        └── CollisionShape2D / relevant collision nodes
```

The exact scene structure may change as implementation develops, but the separation of responsibilities is important.

## OrbManager

`OrbManager` is responsible for managing the player's collection of orbs and coordinating their overall behaviour.

It should handle things that concern the **collection of orbs as a whole**, rather than becoming a giant script containing every individual orb's behaviour.

## Orb

`Orb` is responsible for the behaviour of an individual orb.

Individual movement states/behaviours belong conceptually with the orb unless they specifically need to be coordinated by `OrbManager`.

Possible state ideas discussed include:

```gdscript
ORBITING
FLYING
RETURNING
```

These are design ideas and should not be assumed to be implemented exactly as written.

---

## Orb Positioning

The orbs are **not intended to make a complete circular orbit around the player**.

The intended visual behaviour is:

- Above and/or beside the player.
- Floating and hovering.
- Wispy/ghostlike.
- Able to react naturally to player movement.
- They should generally avoid being directly underneath the player.
- They do not need to physically touch the player to communicate that they are following the player.

An early target position considered was roughly:

```gdscript
Vector2(2, -14)
```

but this is a tunable visual value, not a permanent design requirement.

The orbs may use smooth interpolation and subtle floating motion.

Physics reaction has also been considered so that the orb visually responds when the player jumps, falls, accelerates, etc.

---

# Orb Abilities

Several possible abilities have been discussed.

### Core abilities

Three core abilities currently considered are:

1. Dash
2. Wall jump
3. Double jump

### Other possible/equippable abilities

The project may eventually support up to six orbs:

- 3 core orbs
- 3 additional/equippable orbs

Other ideas that have been discussed include:

- Respawn
- A high-damage attack with a cooldown
- An orb that moves to a position the player can step on
- Phase/slow-fall behaviour
- Wall crawling
- Afterimage generation

These are **ideas, not commitments**. Do not implement them unless they are explicitly chosen.

---

# Visual Direction

The orbs should feel like floating wisps/ghostlike companions rather than rigid mechanical objects.

The visual inspiration discussed includes:

- Floating energy/orbs.
- Wispy movement.
- A companion-like presence.
- Dynamic movement similar to the feel of floating visual effects in platformers.

Avoid making them a simple rigid circular orbit unless the design is explicitly changed.

---

# Map and Level Design

Microvania is intended to be a metroidvania rather than a collection of completely disconnected platforming levels.

Map planning is still being developed.

The workflow being considered includes:

1. Rough map planning.
2. Macro room/layout planning.
3. Identifying important movement gates and ability requirements.
4. Building rooms in Godot.
5. Testing movement through the rooms.
6. Iterating based on actual gameplay.

Paper/pencil planning is acceptable for early map design.

Do not build a large amount of detailed level art before the movement and room layouts have been tested.

---

# Development Workflow

The project is being developed alongside school, so the workflow should remain manageable.

Priorities should generally be:

1. Make the core movement feel good.
2. Build the orb system in small, understandable steps.
3. Test each mechanic before adding another.
4. Build a small amount of level content.
5. Playtest.
6. Iterate.
7. Expand only when the underlying systems are stable.

Avoid creating unnecessarily complicated systems simply because they are technically interesting.

---

# Coding Guidelines

## General

- Use GDScript.
- Prefer clear, readable code over clever code.
- Keep responsibilities separated between nodes/scripts.
- Use typed variables where they improve clarity.
- Avoid unnecessary abstractions.
- Do not rewrite working systems without a reason.
- Preserve existing design decisions unless explicitly asked to change them.

## When modifying existing code

Before making a substantial change:

1. Read the relevant existing script.
2. Understand how it currently works.
3. Check how other scripts interact with it.
4. Explain the intended change.
5. Make the smallest sensible change.
6. Test it in Godot.

Do not replace an entire system when a small change will solve the problem.

---

# AI Coding Agent Instructions

This file exists partly so AI coding tools such as Codex can understand the project's established context.

**Before modifying Microvania, read this file.**

When working on the project:

- Respect the design decisions documented here.
- Treat planned features as planned, not implemented.
- Do not invent new mechanics without discussing them.
- Do not introduce a super dash.
- Do not add a difficulty-selection system.
- Do not turn `OrbManager` into a monolithic script.
- Keep individual orb behaviour in `Orb` where appropriate.
- Preserve existing movement feel unless the task specifically asks to change it.
- Prefer incremental changes that can be tested.
- If a proposed change would significantly alter the architecture, explain the change before implementing it.
- If the current code conflicts with this document, inspect the actual code and determine whether the document or code reflects the newer decision rather than blindly overwriting either one.

## Important

The actual project files are the source of truth for what is currently implemented.

This document is the source of truth for the **intended design decisions and project context**, unless it has been explicitly updated.

Update this document when an important design decision changes.
