require "test/unit"

require "PDA.rb"

class PDATests < Test::Unit::TestCase
  def setup
    rules = [
             [1,  :q0, "a", "Z", [[:q0, "aZ"], [:q1, "Z"]]],
             [2,  :q0, "b", "Z", [[:q0, "bZ"], [:q1, "Z"]]],
             [3,  :q0, "a", "a", [[:q0, "aa"], [:q1, "a"]]],
             [4,  :q0, "b", "a", [[:q0, "ba"], [:q1, "a"]]],
             [5,  :q0, "a", "b", [[:q0, "ab"], [:q1, "b"]]],
             [6,  :q0, "b", "b", [[:q0, "bb"], [:q1, "b"]]],
             [7,  :q0, "", "Z", [[:q1, "Z"]]],
             [8,  :q0, "", "a", [[:q1, "a"]]],
             [9,  :q0, "", "b", [[:q1, "b"]]],
             [10, :q1, "a", "a", [[:q1, ""]]],
             [11, :q1, "b", "b", [[:q1, ""]]],
             [12, :q1, "", "Z", [[:q2, "Z"]]],
            ]
    @foo = PDA.new(rules)
  end
  
  # def test_top
  #   assert_equal(@foo.top("a"), ["a", ""])
  #   assert_equal(@foo.top("ab"), ["a", "b"])
  #   assert_equal(@foo.top("abb"), ["a", "bb"])
  #   assert_equal(@foo.top(""), ["", ""])
  # end
  # 
  # def test_print_rules
  #   @foo.print_rules
  # end
  # 
  # def test_get_moves
  #   moves = @foo.get_moves(Configuration.new(:q0, "a", "Z"))
  #   assert_equal(moves.size, 3)
  #   puts moves
  #   assert_equal(moves[0].state, :q0)
  #   assert_equal(moves[0].stack, "aZ")
  #   assert_equal(moves[1].state, :q1)
  #   assert_equal(moves[1].stack, "Z")
  #   assert_equal(moves[2].state, :q1)
  #   assert_equal(moves[2].stack, "Z")
  #   baz = (rand * (moves.size - 1)).round
  #   puts baz
  #   move = moves[baz]
  #   puts move 
  # end
  
  def test_accept
    @foo.accept? Configuration.new(:q0, "a", "Z"), ""
    puts
    @foo.accept? Configuration.new(:q0, "ab", "Z"), ""
    puts
    @foo.accept? Configuration.new(:q0, "bb", "Z"), ""
    puts
    @foo.accept? Configuration.new(:q0, "bbb", "Z"), ""
    puts
    @foo.accept? Configuration.new(:q0, "", "Z"), ""
  end
end
