# get a spawn location for an enemy - currently defaults to a location outside the 64x64 canvas/screen
def enemy_spawn_location
  max_xy = 64 + 12 # 12 for some buffer for the enemy not spawning on screen
  min_xy = -12
  # currently we spawn either at the top or bottom of the screen
  if rand < 0.5
    x = max_xy
    y = rand * 64
  else
    x = min_xy
    y = rand * 64
  end
  {x: x, y: y}
end