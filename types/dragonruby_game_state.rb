# types/dragonruby_types.rb

# @!group GTK Module
module GTK
  # DragonRuby Args container
  class Args
    # @return [GameState] the game state
    def state; end
    
    # @return [LowrezOutputs] low resolution output interface
    def lowrez; end
    
    # @return [Inputs] input handling interface
    def inputs; end
  end
end

# @!group Game State Classes
class GameState
  # @!attribute player
  #   @return [Player] the player object
  attr_accessor :player
  
  # @!attribute enemies
  #   @return [Array<Enemy>] array of enemy objects
  attr_accessor :enemies
  
  # @!attribute ticks_since_spawn
  #   @return [Integer] number of ticks since last enemy spawn
  attr_accessor :ticks_since_spawn

  # @!attribute weapons
  #   @return [Array<Weapon>] array of weapon objects. Max 4 weapons can be equipped at a time.
  attr_accessor :enemies

  # @!attribute initialized
  #   @return [Boolean] whether the game state has been initialized
  attr_accessor :initialized
end

class Player
  # @!attribute [rw] x
  #   @return [Numeric] x position
  attr_accessor :x, :y, :w, :h
  
  # @!attribute [rw] flip_horizontally
  #   @return [Boolean] whether sprite is horizontally flipped
  attr_accessor :flip_horizontally
end

class Enemy
  # @!attribute [rw] x
  #   @return [Numeric] position and size
  attr_accessor :x, :y, :w, :h
  
  # @!attribute [rw] health
  #   @return [Integer] enemy health points
  attr_accessor :health
end
