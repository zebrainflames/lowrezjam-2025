# DragonRuby test runner
# Any top-level method beginning with `test_` is discovered by the engine as a test case.
# Use: rake test (or dragonruby.exe mygame --test test/test_runner.rb --quit-after-test)

require 'app/gameplay'

# Verifies that update_player clamps player position within the 64x64 lowrez bounds.
# Signature must be (args, assert). At least one assert.*! call is required.
def test_player_position_is_clamped args, assert
  # Arrange: an out-of-bounds player. Use gameplay constants for width/height.
  args.state.player = { x: -10, y: 100, w: PlayerWidth, h: PlayerHeight }

  # Act
  update_player args

  # Assert
  assert.equal! args.state.player.x, 0, 'x should clamp to the left edge (0).'
  assert.equal! args.state.player.y, 64 - PlayerHeight, 'y should clamp to the top edge.'
end

# Verifies that the axe weapon autoattacks and damages an enemy in front of the player.
def test_axe_autoattack_damages_enemy args, assert
  # Arrange: player at (10,0) facing right by default
  args.state.player = { x: 10, y: 0, w: 8, h: 8 }
  args.state.enemies = [ { x: 20, y: 0, w: 4, h: 4, health: 20 } ]
  args.state.weapons = [ create_axe_weapon ]

  # Put weapon on the verge of attacking this tick
  axe = args.state.weapons.first
  axe[:cooldown] = 1
  axe[:ticks_since_attack] = 0

  # Act: update weapons should trigger an immediate attack
  update_weapons args

  # Assert: enemy health should be reduced by axe damage (15)
  assert.equal! args.state.enemies.first[:health], 5, 'enemy should take 15 damage from axe swing.'
  # Assert: ticks_since_attack should have reset to 0 after attacking
  assert.equal! axe[:ticks_since_attack], 0, 'weapon attack timer should reset after attack.'
end

# Enemies should not move into each other: update_enemies limits movement to avoid overlap.
def test_enemies_do_not_overlap_after_update args, assert
  # Arrange: player at center; two enemies on a collision course.
  args.state.player = { x: 32.0, y: 32.0, w: 8, h: 7 }
  args.state.enemies = [
    { x: 20.0, y: 20.0, w: 4, h: 4, health: 10 },
    { x: 26.5, y: 26.5, w: 4, h: 4, health: 10 }
  ]
  # Ensure no spawn during test
  args.state.ticks_since_spawn = 0

  # Act
  update_enemies args

  # Assert: no overlaps among enemies
  e1, e2 = args.state.enemies
  assert.false! e1.intersect_rect?(e2), 'enemies should not overlap after movement.'
  # And at least one enemy should have moved (not both fully blocked)
  moved_any = (e1.x != 20.0 || e1.y != 20.0) || (e2.x != 26.5 || e2.y != 26.5)
  assert.true! moved_any, 'at least one enemy should be able to move when space permits.'
end
