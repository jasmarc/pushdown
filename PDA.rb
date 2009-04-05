Configuration = Struct.new(:state, :input, :stack)
Move = Struct.new(:rule_number, :state, :stack)
Rule = Struct.new(:number, :config, :moves)

class PDA
  def initialize(rules)
    @rules = rules.map! do |r|
      Rule.new(r[0], Configuration.new(r[1], r[2], r[3]), r[4].map! { |m| Move.new(r[0], m[0], m[1]) })
    end
  end
  
  def print_rules
    @rules.each do |r|
      print "#{r.number}:\t(#{r.config.state}, #{r.config.input}, #{r.config.stack}) -> "
      r.moves.each { |m| print "(#{m.state}, #{m.stack})" }
      print "\n"
    end
  end
  
  def accept?(config)
    @accept = false
    derivation_tree(config)
    @accept
  end
  
  def count_leaf_nodes(config)
    @leaf_nodes = 0
    derivation_tree(config)
    @leaf_nodes
  end

  def derivation_tree(config, verbose=false, whitespace="")
    print "(#{config.state}, #{config.input}, #{config.stack})\n" if verbose
    moves = get_moves(config)
    
    if config.state == :q2 && config.input.empty? && config.stack == "Z"
      accept "Accept\n", verbose
    elsif moves.nil? || moves.empty?
      crash "Crash! I couldn't find a rule for: state #{config.state}, input #{config.input}, stack #{config.stack}\n", verbose
    else
      moves.each do |m|
        print "rule %2s #{whitespace}|-" % m.rule_number if verbose
        rule = find_rule_by_number(m.rule_number)
        if(!rule.nil? && rule.config.input.empty?)
          unread = config.input
        else
          unread = top(config.input)[1]
        end
        derivation_tree(Configuration.new(m.state, unread, m.stack + top(config.stack)[1]), verbose, whitespace + " ")
      end
    end
  end
  
private
  def top(str)
    [str.slice(0, 1), str.size > 1 ? str.slice(1, str.size) : ""]
  end

  def get_moves(config)
    rules = @rules.find_all do |r| 
      r.config.state == config.state \
      && (r.config.input == top(config.input)[0] || r.config.input.empty?) \
      && r.config.stack == top(config.stack)[0]
    end
    moves = rules.map { |r| r.moves }.flatten
  end

  def find_rule_by_number(number)
    @rules.find { |r| r.number == number }
  end

  def accept(msg, verbose)
    print msg if verbose
    @leaf_nodes += 1 unless @leaf_nodes.nil?
    @accept = true
  end

  def crash(msg, verbose)
    print msg if verbose
    @leaf_nodes += 1 unless @leaf_nodes.nil?
  end
end