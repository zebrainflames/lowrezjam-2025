# @param args [GTK::Args]
# @return [void]

require_relative 'director'

PlayerMoveDelta = 0.3
PlayerHeight = 7
PlayerWidth = 8

GoblinMoveDelta = 0.124

MaxEnemiesPerRoom = 10

# @param args [GTK::Args]
# @return [void]
def update_player args
  dir = args.inputs.keyboard.directional_vector
  unless dir.nil?
    args.state.player.x += dir.x * PlayerMoveDelta
    args.state.player.y += dir.y * PlayerMoveDelta

    args.state.player.flip_horizontally = dir.x < 0
  end
  # clamp player to screen
  args.state.player.x = [0, args.state.player.x].max
  args.state.player.y = [0, args.state.player.y].max
  args.state.player.x = [64 - PlayerWidth, args.state.player.x].min
  args.state.player.y = [64 - PlayerHeight, args.state.player.y].min
end

# @param args [GTK::Args]
# @return [void]
def update_enemies args
  # TODO: generate a Director class that manages room difficulty, enemy spawn counts, enemy stats
  # buffs, etc.
  # @type [Integer]
  args.state.ticks_since_spawn ||= 0
  args.state.ticks_since_spawn += 1
  if args.state.enemies.count < MaxEnemiesPerRoom && args.state.ticks_since_spawn > 60
    spawn_loc = enemy_spawn_location
    args.state.enemies << { x: spawn_loc.x, y: spawn_loc.y, w: 4, h: 4, health: 10 } # goblin...
    args.state.ticks_since_spawn = 0

  end

  args.state.enemies.each do |goblin|
    # get direction to player
    dx, dy = args.state.player.x - goblin.x, args.state.player.y - goblin.y
    norm = Geometry.vec2_normalize({ x:dx, y: dy})
    # move towards player
    goblin.x += norm.x * GoblinMoveDelta
    goblin.y += norm.y * GoblinMoveDelta

  end
end

# @param args [GTK::Args]
# @return [void]
def update_weapons args
  args.state.weapons ||= []
  args.state.weapons.each do |weapon|
    weapon[:ticks_since_attack] ||= 0
    weapon[:ticks_since_attack] += 1
    if weapon[:ticks_since_attack] >= weapon[:cooldown]
      weapon[:attack].call args, weapon
      weapon[:ticks_since_attack] = 0
    end
  end
end

# @param args [GTK::Args]
# @return [void]
def update_effects args
  args.state.attack_fx ||= []
  # Decrement ttl and purge expired effects (pure state update; rendering is done in render.rb)
  args.state.attack_fx.each do |fx|
    fx[:ttl] = (fx[:ttl] || 0) - 1
  end
  args.state.attack_fx.reject! { |fx| fx[:ttl] <= 0 }
end

# @param args [GTK::Args]
# @return [void]
def update_ui args
end

# Add this function to create an axe weapon
def create_axe_weapon
  {
    id:                 :axe,
    name:               "Blunt Axe",
    cooldown:           60,  # Attack every 1 second (60 ticks)
    ticks_since_attack: 0,
    damage:             15,
    range:              12,  # Attack range in pixels
    attack:             proc do |args, weapon|
      # Get player position and facing direction
      player = args.state.player
      attack_direction = player.flip_horizontally ? -1 : 1

      # Calculate attack area in front of player using weapon's range
      range = weapon[:range]
      attack_x = player.x + (attack_direction > 0 ? player.w : -range)
      attack_y = player.y
      attack_w = range
      attack_h = player.h

      attack_area = { x: attack_x, y: attack_y, w: attack_w, h: attack_h }

      # Damage enemies that intersect with the attack area
      args.state.enemies.each do |enemy|
        if enemy.intersect_rect?(attack_area)
          enemy.health -= weapon[:damage]
        end
      end

      # Remove dead enemies
      # TODO: move this to end of frame for proper handling of damage ana effects and events
      args.state.enemies.reject! { |enemy| enemy.health <= 0 }

      # Visualize the attack area with a semi-transparent blue rectangle for a few frames
      args.state.attack_fx ||= []
      args.state.attack_fx << attack_area.merge(r: 0, g: 128, b: 255, a: 96, ttl: 6)
    end
  }
end

# Add this to your initialization code (in main.rb's tick method)
# Add this line after initializing other game state:
# args.state.weapons << create_axe_weapon unless args.state.weapons.any? { |w| w[:name] == "Simple Axe" }
