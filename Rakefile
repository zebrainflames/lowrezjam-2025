### This is a simple Rakefile setup for DragonRuby development
### Contains basic tasks for run, package, deploy, and code formatting
###
### Available tasks:
### - run: Run the DragonRuby game
### - test: Run all tests

task default: :run

task :run do
  dragon_exec = lambda do
    plat = RUBY_PLATFORM
    puts "Ruby platform is #{plat}"
    if /mswin|mingw|cygwin/.match?(plat)
      'dragonruby.exe'
    else
      'dragonruby'
    end
  end

  sh dragon_exec.call.to_s
end

namespace :test do
  # This task runs all tests and checks the results by parsing the output
  # It will report success or failure with clear visual indicators and set appropriate exit codes
  desc 'Run all DragonRuby integration tests'
  task :ruby do
    puts 'Running all DragonRuby tests'
    # NOTE: dragonruby does not currently support providing a full list of individual test files, so we need to use a
    # separate test runner script for orchestration.
    test_command = 'dragonruby.exe mygame --test test/test_runner.rb --quit-after-test'
    puts "Executing: #{test_command}"

    # We use backticks to capture output and then `puts` it for viewing.
    output = `#{test_command}`
    puts output

    # Previously caught output is parsed for test results.
    passed_tests_match = output.match(/(\d+) test\(s\) passed/)
    failed_tests_match = output.match(/(\d+) test\(s\) failed/)
    inconclusive_tests_match = output.match(/(\d+) test\(s\) inconclusive/)

    passed_count = passed_tests_match ? passed_tests_match[1].to_i : 0
    failed_count = failed_tests_match ? failed_tests_match[1].to_i : 0
    inconclusive_count = inconclusive_tests_match ? inconclusive_tests_match[1].to_i : 0
    total_count = passed_count + failed_count + inconclusive_count

    if failed_count.zero?
      puts "\n✅ DragonRuby tests PASSED successfully! (#{passed_count}/#{total_count} tests passed, #{inconclusive_count} inconclusive)"
    else
      abort "\n❌ DragonRuby tests FAILED: #{failed_count} of #{total_count} test(s) failed, #{inconclusive_count} inconclusive!"
    end
  end

end

## Top-level aliases for convenience

desc 'Run all DragonRuby Ruby-side unit tests and integration tests (alias for test:ruby)'
task test: 'test:ruby'

