# frozen_string_literal: true

require "test_helper"

class HachiwariTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Hachiwari::VERSION
  end

  def test_it_does_something_useful
    assert true
  end

  def setup
    @hachiwari = Hachiwari::CLI.new
  end

  def test_winning_percentage
    assert_equal 80.0000, @hachiwari.send(:winning_percentage, 40, 10)
    assert_equal 79.7106, @hachiwari.send(:winning_percentage, 7162, 1823)
  end

  def test_reach_wins
    assert_equal   1, @hachiwari.send(:reach_wins, 79, 20)
    assert_equal 130, @hachiwari.send(:reach_wins, 7162, 1823)
  end
end
