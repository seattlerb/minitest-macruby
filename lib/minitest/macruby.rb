require 'minitest/test'

class MiniTest::Unit
  def self.run_macruby_tests
    dir_path = NSBundle.mainBundle.resourcePath.fileSystemRepresentation
    Dir.chdir dir_path do
      Dir["**/test_*.rb"].each do |path|
        require path
      end
    end

    result = MiniTest::Unit.new.run(ARGV)

    exit!(result && result > 0 ? 1 : 0)
  end
end

module MiniTest::Assertions
  def find_ui_menu(*path)
    app  = NSApplication.sharedApplication
    menu = path.inject(app.mainMenu) { |m, n| m.itemWithTitle(n).submenu }
  end

  def find_ui_menu_items menu
    menu = find_ui_menu menu

    menu.itemArray
  end

  def assert_ui_menu menu, *items
    item_titles = find_ui_menu_items(menu).map { |item| item.title }

    assert_equal items, item_titles
  end

  def find_ui_menu_item(*path)
    item_name = path.pop
    find_ui_menu(path).itemWithTitle item_name
  end

  def assert_ui_action obj, target, action, key = nil
    refute_nil obj, action
    assert_equal target,        obj.target
    assert_equal action.to_sym, obj.action
    assert_equal key,           obj.keyEquivalent if key
  end

  def assert_ui_binding item, binding_name, target, path
    refute_nil item
    refute_nil target
    binding = item.infoForBinding binding_name.to_s
    refute_nil binding
    assert_equal path, binding["NSObservedKeyPath"]
    assert_equal target, binding["NSObservedObject"]
  end
end

if $0 != __FILE__ then
  MiniTest::Unit.run_macruby_tests
end
