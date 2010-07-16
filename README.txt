= minitest-macruby

* http://rubyforge.org/projects/bfts

== DESCRIPTION:

minitest-macruby provides extensions to minitest for macruby UI
testing. It provides a framework to test GUI apps in a live instance.
Documentation and examples are light at the moment as I've just thrown
this together. Suggestions for extensions are very welcome!

Currently it provides the following methods in minitest's assertions:

* self.run_macruby_tests
* find_ui_menu(*path)
* find_ui_menu_items menu
* assert_ui_menu menu, *items
* find_ui_menu_item(*path)
* assert_ui_action obj, target, action, key = nil
* assert_ui_binding item, binding_name, target, path

== My Current UI Testing Setup

Here is my current macruby UI testing setup:

=== Rakefile:

* Has an isolate setup to pull down all my testing gems.
* task build - runs xcodebuild to build a debug app
* task link  - runs a build and then hard links source files to build files

=== ~/.emacs.el:

* sets 'backup-by-copying-when-linked to t - allowing work on
  hardlinked files to go unimpeded.

=== .autotest:

* Sets ENV['RUBY'] to macruby.
* Sets ENV['MACRUBY_TESTING'] to 1.
* Sets ENV['GEM_HOME'] and ENV['GEM_PATH'] with expanded paths to pick
  up isolated gems during test runs.
* initialize hook sets the test framework to minitest and runs the
  link rake task.
* Overrides Autotest#make_test_cmd to execute the binary directly.

=== lib/app_controller.rb:

* sets $TESTING = ENV['MACRUBY_TESTING']
* applicationDidFinishLaunching requires minitest/macruby if $TESTING

=== rb_main.rb:

* needed to be tweaked to skip loading test files.

=== Walkthrough:

So, when I fire up autotest it will build the application and then
hardlink all the original source files into the build. This allows
autotest to scan the lib and test dirs but invoking the application
will pick up all my changes without having to rebuild. This greatly
speeds up development.

When autotest runs the application directly, it does so with
MACRUBY_TESTING set in the environment. The application sees this and
sets $TESTING to true and once the app is done launching, it loads
minitest/macruby. That in turn loads up all the test files in the
build dir and then runs the tests. Once the tests are run, it exits
with the appropriate exit code depending on test results.

== FEATURES/PROBLEMS:

* Provides extensions to your test cases to help test OSX GUI apps.
* Still needs spit and polish.

== SYNOPSIS:

    new, open, _, close, save = find_ui_menu_items "File"
    
    assert_ui_action  new,   delegate, "new_document:", "n"
    assert_ui_action  open,  delegate, "open_document:", "o"
    assert_ui_action  close, delegate, "close_document:", "w"
    
    assert_ui_binding close, :enabled, delegate, has_window

== REQUIREMENTS:

* minitest
* macruby

== INSTALL:

* sudo gem install minitest-macruby

== LICENSE:

(The MIT License)

Copyright (c) Ryan Davis, seattle.rb

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
