require "transmogrify_test"

class TestCoffeeEngine < Transmogrify::TestCase
  test "makes post" do
    Transmogrify.install_coffeescript!
    register_compile(:body => '{"output" : "yay"}')
    cs = ::CoffeeScript.compile('asdf = "jklm"')
    assert_equal 'yay', cs
  end
end
