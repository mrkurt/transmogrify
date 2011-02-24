require "transmogrify_test"

class TestWrapper < Transmogrify::TestCase
  test "handle good response" do
    register_compile(:body => '{"output" : "yay"}')
    res = Transmogrify.post('asdf = "jk"')
    assert_equal 'yay', res['output']
  end

  test "handle failure response" do
    register_compile(:body => '{"message" : "fire!", "processor" : "coffee"}', :status => [500, 'bad'])
    ex = assert_raise Transmogrify::TransmogrifyError do
      res = Transmogrify.post('gibberish')
    end

    assert_equal 'fire!', ex.message
    assert_not_nil ex.processor
  end

  test "handle unparsable response" do
    register_compile(:body => 'bazinga!', :status => [500, 'bad'])
    ex = assert_raise Transmogrify::TransmogrifyError do
      res = Transmogrify.post('gibberish')
    end
    assert_equal "Could not decode Transmogrify response", ex.message
    assert_not_nil ex.inner
  end
end
