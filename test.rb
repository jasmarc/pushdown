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

  def test_print_rules
    @foo.print_rules
  end

  def test_accept
    ["a", "ab", "bb", "bbb", "", "bbaabb"].each do |s|
      puts "%-20s %s" % [s, @foo.accept?(Configuration.new(:q0, s, "Z"))]
    end
  end

  def test_count_leaf_nodes
    ["a", "ab", "bb", "bbb", "", "bbaabb"].each do |s|
      puts "%-20s %s" % [s, @foo.count_leaf_nodes(Configuration.new(:q0, s, "Z"))]
    end
  end
end
