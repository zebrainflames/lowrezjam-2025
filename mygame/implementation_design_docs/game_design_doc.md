# Goblin Warboss Halls
## Arcade Dungeon Crawler - Game Design Document

NOTE: name of the game should still be iterated on.

### Game Overview

**Genre:** Arcade Dungeon Crawler with Survivorslike Elements  
**Theme:** "The Floor Is..."  
**Resolution:** 64x64 pixels  
**Target:** Game Jam Prototype

You are a lone adventurer infiltrating the treacherous halls of **Graksul the Vicious**, a notorious goblin warboss. Navigate through interconnected rooms filled with goblin hordes while adapting to constantly shifting floor hazards. Survive as long as possible, growing stronger with each cleared room, until you face the Warboss himself.

---

### Core Mechanics

#### Real-Time Arcade Combat
- **Movement:** WASD/Arrow keys for 8-directional movement
- **Auto-Attack:** Character automatically attacks nearest enemy in range
- **Special Abilities:** Cooldown-based powers (dash, area blast, shield)
- **Health System:** Traditional health bar with healing items/abilities

#### Room-Based Exploration
- **8x8 Grid Rooms:** Each room is a contained encounter space
- **Room Connections:** Doors on North/South/East/West walls lead to new rooms
- **Room Types:**
    - **Combat Rooms:** Standard goblin encounters
    - **Treasure Rooms:** Loot chests with guaranteed upgrades (rare)
    - **Shop Rooms:** Spend collected gold on items
    - **Boss Chambers:** Elite enemies with unique mechanics
    - **Rest Rooms:** Safe spaces to heal and plan

#### Survivorslike Progression
- **Experience Points:** Gained by defeating enemies
- **Level Up Rewards:** Choose 1 of 3 upgrade cards
- **Upgrade Categories:**
    - **Combat:** Increased damage, attack speed, crit chance
    - **Defense:** More health, armor, damage reduction
    - **Utility:** Movement speed, dash cooldown, gold find
- **Persistent Run:** Stats carry between rooms until death

---

### Theme Integration: "The Floor Is..."

Every room announces a dynamic floor hazard that affects both player and enemies:

#### Floor Hazard Types
- **"The Floor Is Trapped!"**
    - Pressure plates trigger dart volleys across rows/columns
    - Visual: Darker tiles with small crosshair symbols
    - Strategy: Time movement to avoid triggered areas

- **"The Floor Is Collapsing!"**
    - Random tiles crumble into pits after 3-5 seconds
    - Visual: Cracked tile animations before collapse
    - Strategy: Keep moving, use pits to trap enemies

- **"The Floor Is Poisonous!"**
    - Green-tinted tiles deal damage over time
    - Visual: Sickly green overlay with bubble effects
    - Strategy: Plan safe paths, use antidotes

- **"The Floor Is Slippery!"**
    - Oil spills cause sliding movement
    - Visual: Dark, reflective patches
    - Strategy: Use momentum, watch enemy sliding patterns

- **"The Floor Is On Fire!"**
    - Spreading flame tiles that grow over time
    - Visual: Red/orange animated fire sprites
    - Strategy: Control the spread, use fire against enemies

- **"The Floor Is Electrified!"**
    - Lightning arcs between metal objects and units
    - Visual: Blue sparks and chain lightning effects
    - Strategy: Avoid clustering, remove metal equipment

#### Hazard Mechanics
- **Announcement Phase:** 2-second warning with text display ("The Floor Is ...!")
- **Activation:** Hazards begin affecting the battlefield
- **Duration:** Lasts entire room encounter
- **Enemy AI:** Goblins also affected by hazards (they're not immune)

---

### Visual Design

#### Technical Constraints
- **Resolution:** 64x64 pixels total
- **Tile System:** 4x4 pixel tiles (16x16 tiles per room)
- **Room Size:** 16x16 tiles (64x64 pixels of playable space consisting of 4x4 tiles)
- **UI Space:** Super simple health bar and room counter overlaid on top

#### Art Style
- **Pixel Art:** Retro 8-bit aesthetic with limited color palette
- **Goblin Theme:** Earthy greens, browns, with splashes of red for danger
- **Dungeon Atmosphere:** Dark stone corridors with torchlight effects

#### Sprite Design
- **Player Character:** 8x8 pixels, simple humanoid silhouette
- **Goblins:** 6x6 - 8x8 pixels, distinct from player (green tint, different shape)
- **Environmental Objects:** Doors, chests, traps use 4x4 tile space
- **Effects:** Minimal particle systems (1-2 pixels for sparks, blood, etc.)

---

### Enemy Design

TODO: Enemy types should be interpreted again after asset selection is clearer.

#### Goblin Types
- **Goblin Scout:** Basic melee enemy, moves directly toward player
- **Goblin Archer:** Ranged attacks, tries to maintain distance
- **Goblin Brute:** Tanky, slow-moving, high damage
- **Goblin Shaman:** Casts spells, summons other goblins
- **Warboss Ghargut:** Final boss with multiple phases, if time allows

#### Spawn Patterns
- **Wave-Based:** Enemies spawn in groups from room entrances
- **Escalation:** Each room deeper spawns more/stronger enemies
- **Environmental:** Some hazards affect spawn locations (fire blocks entrances)

---

### Development Process

#### Phase 1: Core Systems 
**Minimum Viable Product:**
- [ ] 8x8 room grid with player movement
- [ ] Basic goblin AI and collision
- [ ] Simple combat system (auto-attack)
- [ ] Room transitions (single door type)
- [ ] Basic UI (health bar, room counter)

**Success Criteria:** Player can move, fight goblins, and progress between rooms

#### Phase 2: Floor Hazards
**Floor System Implementation:**
- [ ] Hazard announcement system
- [ ] "The Floor Is Fire!" hazard (spreading damage tiles)
- [ ] "The Floor Is Trapped!" hazard (pressure plate darts)
- [ ] Visual feedback for hazard states
- [ ] Enemy AI adaptation to hazards

**Success Criteria:** Floor hazards meaningfully change gameplay tactics

#### Phase 3: Progression System
**Survivorslike Elements:**
- [ ] Experience points and leveling
- [ ] Three-card upgrade choice system
- [ ] Basic upgrade categories (damage, health, speed)
- [ ] Loot drops and collection
- [ ] Score/depth tracking

**Success Criteria:** Player feels meaningful progression between rooms

#### Phase 4: Content & Polish
**Game Juice & Variety:**
- [ ] Additional goblin enemy types
- [ ] More floor hazard varieties
- [ ] Room type variations (treasure, shop, boss)
- [ ] Particle effects and screen shake
- [ ] Sound effects and music
- [ ] Death/game over screen with final score

**Success Criteria:** Game feels complete and engaging for multiple runs

#### Phase 5: Balance & Testing
**Final Tuning:**
- [ ] Difficulty curve adjustment
- [ ] Upgrade balance testing
- [ ] Bug fixes and edge case handling
- [ ] Performance optimization for 64x64 rendering
- [ ] Final art polish and animations

**Success Criteria:** Game is stable, balanced, and ready for submission

---

### Technical Architecture

#### Core Systems
- **Game State Manager:** Menu → Playing → Game Over states
- **Room Manager:** Handle room generation, transitions, enemy spawning
- **Floor Hazard System:** Modular hazard types with timing/effects
- **Combat System:** Collision detection, damage calculation, status effects
- **Progression System:** XP tracking, upgrade cards, stat modifications

#### Performance Considerations
- **Efficient Rendering:** 64x64 canvas with minimal overdraw
- **Object Pooling:** Reuse enemy/projectile objects to avoid garbage collection
- **State-Based Updates:** Only update active room entities
- **Compressed Assets:** Minimal sprite sizes and optimized tile data

---

### Success Metrics

**Core Experience Goals:**
- **"Just One More Room"** - Compelling progression loop
- **Tactical Adaptation** - Floor hazards create meaningful decision-making
- **Survivorslike Flow** - Satisfying power growth and escalating challenge
- **Theme Integration** - "The Floor Is..." feels central to gameplay, not gimmicky

**Technical Goals:**
- Stable 60fps in HTML5 builds
- Intuitive controls with minimal tutorial needed
- Complete game loop from start to game over
- Replayable with varied experiences each run

**Game Jam Goals:**
- Finished, playable build within 7 days
- Clear demonstration of theme interpretation
- A nice take on survivorslike genre constraints
- Memorable gameplay moment around floor hazard adaptation