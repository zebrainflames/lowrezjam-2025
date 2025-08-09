DragonRuby LowRez Jam 2025 — Project Guidelines (Advanced)

This document captures project-specific knowledge to speed up development, testing, and debugging for this codebase. It assumes familiarity with DragonRuby Game Toolkit.

1. Build / Configuration
- Engine entry-point & run task
  - Entry is mygame/app/main.rb with tick(args).
  - Running the game locally is standardized via Rake:
    - rake run — launches DragonRuby (Windows-safe; picks dragonruby.exe automatically via RUBY_PLATFORM). Working dir is the repo root; the game folder is mygame.
  - The LowRez compositor is implemented in mygame/app/lowrez.rb. Do not change unless intentional; it hooks into GTK::Runtime#tick_core to:
    - Initialize args.lowrez (a 64×64 render target).
    - Render lowrez output zoomed to 640×640 at the center of the 1280×720 window.
    - Provide convenience APIs: args.lowrez.solids/borders/sprites/labels/lines/primitives and default_label.
    - Constants of note:
      - LOWREZ_SIZE=64, LOWREZ_ZOOM=10, LOWREZ_ZOOMED_SIZE=640, LOWREZ_X_OFFSET/LOWREZ_Y_OFFSET for mouse coordinate downscaling.
      - Font constants (LOWREZ_FONT_SM/MD/LG/XL) and LOWREZ_FONT_PATH.

- Resolution & coordinate system
  - All gameplay logic and rendering should operate within a 64×64 coordinate space (lowrez canvas). The lowrez system upscales to the window; do not use args.outputs.* directly for game rendering unless you are intentionally bypassing the lowrez renderer.
  - Mouse helpers: args.lowrez.mouse returns [x, y] already normalized to lowrez coordinates.

- Asset paths
  - Use lowrez-friendly assets located under mygame/sprites, mygame/fonts, etc. Sprite example: render_player uses sprites/characters.png with 8×8 source rects.

2. Testing
DragonRuby’s built-in test harness is enabled via the --test switch. The project’s Rakefile wraps a Windows-friendly test command and parses engine output for pass/fail.

- How tests are discovered
  - Any top-level method starting with test_ is considered a test by the engine.
  - Test method signature: def test_something args, assert; ... end
    - args is the standard GTK::Args.
    - assert is GTK::Assert (docs/oss/dragon/assert.rb) with methods: true!, false!, equal!, not_equal!, nil!, ok!.
    - Ensure at least one assert.*! call per test; otherwise the test is marked “inconclusive.”

- Running the test suite
  - rake test (alias for test:ruby) executes:
    - dragonruby.exe mygame --test test/test_runner.rb --quit-after-test
  - The --quit-after-test switch is critical for CI/non-interactive runs. The rake task parses engine output and sets exit codes accordingly.

- Where to place tests
  - The Rakefile expects the test entry point at mygame/test/test_runner.rb. That file can either:
    - Contain your test methods directly, or
    - Require additional test files under mygame/test/** and serve as an orchestrator.
  - You can also bypass rake and invoke the engine directly to point at any test file inside mygame: dragonruby.exe mygame --test test/your_file.rb --quit-after-test

- Creating a new test (example that we verified locally)
  - Create mygame/test/test_runner.rb with a clamp test leveraging current gameplay code:

    # DragonRuby test runner for mygame
    require 'app/gameplay'

    def test_player_position_is_clamped args, assert
      # Arrange: an out-of-bounds player (game constants define the clamp limits)
      args.state.player = { x: -10, y: 100, w: PlayerWidth, h: PlayerHeight }

      # Act
      update_player args

      # Assert
      assert.equal! args.state.player.x, 0, 'x should clamp to left edge (0).'
      assert.equal! args.state.player.y, 64 - PlayerHeight, 'y should clamp to top edge.'
    end

  - Run: rake test. Expected output (abridged):
    - [Game] ** Running: test_player_position_is_clamped
    - [Game] Passed.
    - 1 test(s) passed. 0 failed. 0 inconclusive.

  Notes:
  - update_player uses args.inputs.keyboard.directional_vector when present; the clamp logic runs regardless, making it easy to unit test without simulating input.
  - Prefer tests that avoid real-time tick coupling; isolate logic into functions that accept args/state and return deterministic results.

- Adding more tests
  - Keep tests deterministic and independent. Avoid reliance on Kernel.tick_count for assertions.
  - If you need to assert custom conditions without failing, call assert.ok! so the test isn’t counted as inconclusive.
  - Consider organizing tests per domain in mygame/test/, and require them from test_runner.rb.

3. Development Patterns & Tips (Project-specific)
- Update/Render split
  - app/gameplay.rb contains update_* functions (update_player, update_enemies, etc.). Keep game state mutations here.
  - app/render.rb contains render helper(s) (render_player, blit_label). Keep it side-effect free outside of enqueuing lowrez primitives.
  - app/main.rb wires the loop (init → update → render) and contains many lowrez usage examples that double as living docs.

- Player movement & constraints
  - Constants: PlayerMoveDelta=0.3, PlayerWidth=8, PlayerHeight=7.
  - Movement is driven by args.inputs.keyboard.directional_vector; horizontal flip via flip_horizontally when moving left.
  - Clamping bounds are 0..(64-PlayerWidth/Height). Tests above exercise this behavior.

- LowRez rendering helpers
  - blit_label wraps lowrez.labels with a consistent font and size (LOWREZ_FONT_SM). Prefer this for UI text in lowrez space.
  - args.lowrez.background_color writes both the window background and a full-canvas solid to the lowrez render target. Use once per frame.

- Input handling at lowrez scale
  - Use args.lowrez.mouse (or mouse_click/mouse_down/mouse_up) to obtain coordinates already mapped to 64×64. Avoid direct args.inputs.mouse unless you manually downscale using LOWREZ_X/Y_OFFSET and LOWREZ_ZOOM.

- Hot reload & quick iteration
  - Saving any Ruby file triggers hot reload. Saving a test file while running with --test will re-run tests immediately.
  - Logs print to the console; prefer concise puts and leverage the Rake test parser in CI.

- Code style (pragmatic for this codebase)
  - Favor small, pure functions with (args) or (args, assert) signatures.
  - Keep constants at the top of gameplay/render files for easy tuning during the jam.
  - Avoid hidden cross-file globals; pass through args.state. Keep rendering code free of gameplay mutations.

- Debug rendering
  - app/main.rb: render_debug(args) shows a pattern for labeling performance/state. Use args.lowrez.default_label to keep text concise and readable in 64×64.

- When adjusting tests or CI
  - Update Rakefile’s test_command if you organize tests differently (e.g., a suite loader):
    test_command = 'dragonruby.exe mygame --test test/all.rb --quit-after-test'
  - The Rake task matches “X test(s) passed/failed/inconclusive” from engine output to compute exit codes.

Appendix: Commands
- Run game: rake run
- Run tests: rake test
- Run a specific test file directly (bypassing rake):
  - dragonruby.exe mygame --test test/your_test.rb --quit-after-test

Consistency with DragonRuby Docs
- Assert API and discovery are per docs/oss/dragon/assert.rb.
- Test methods are discovered by name (test_*), take (args, assert), and must perform at least one assertion.
- Use --quit-after-test for automated runs.
- Keep gameplay logic deterministic for reliable tests; avoid tick/time coupling inside assertions.
