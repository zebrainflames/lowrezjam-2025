# frozen_string_literal: true

def render_player args
  return unless args.state.player

  args.lowrez.sprites << args.state.player.merge(
    path:     'sprites/characters.png',
    source_w: 8,
    source_h: 8,
    source_x: 64,
    source_y: 16,
    a:        255
  )
end

def render_goblin args, goblin
  return unless goblin

  args.lowrez.sprites << goblin.merge(
    path:     'sprites/characters.png',
    source_w: 4,
    source_h: 4,
    source_x: 2,
    source_y: 0,
    a:        255)
end

def blit_label args:, x:, y:, text:, alignment_enum: 1, r: 0, g: 0, b: 0, a: 255
  args.lowrez.labels  << {
    x:              x,
    y:              y,
    text:           text,
    size_enum:      LOWREZ_FONT_SM,
    alignment_enum: alignment_enum,
    r:              r,
    g:              g,
    b:              b,
    a:              a,
    font:           LOWREZ_FONT_PATH
  }
end


# Renders transient attack effects as blue see-through rectangles using solids.
# Pure rendering: does not mutate state; lifecycle managed by update_effects.
def render_attack_fx args
  return unless args.state.attack_fx && !args.state.attack_fx.empty?

  args.state.attack_fx.each do |fx|
    # Enqueue a solid using current fx rect and color/alpha
    args.lowrez.solids << { x: fx[:x], y: fx[:y], w: fx[:w], h: fx[:h], r: fx[:r] || 0, g: fx[:g] || 128, b: fx[:b] || 255, a: fx[:a] || 96 }
  end
end
