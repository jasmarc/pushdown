# These are some simple data structures used by the PDA.
# A Configuration is a combination of the state, the unread input, and the stack
Configuration = Struct.new(:state, :input, :stack)
# A rule tells us how, given a particular configuration, we are allowed to move
# moves is a collection of "Move" objects
Rule = Struct.new(:number, :config, :moves)
# A move tells us what state to move to and what to do with the stack
Move = Struct.new(:rule_number, :state, :stack)

class PDA
  def initialize(accepting_state, rules)
    @accepting_state = accepting_state
    @rules = rules.map! do |r|
      Rule.new(r[0], Configuration.new(r[1], r[2], r[3]), r[4].map! { |m| Move.new(r[0], m[0], m[1]) })
    end
    @max = 0 # This keeps track of the length of the initial input string during computation
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
    computation_tree(config)
    @accept
  end
  
  def count_leaf_nodes(config)
    @leaf_nodes = 0
    computation_tree(config)
    @leaf_nodes
  end

  # This is the meat of the PDA. This is a recursive method that traverses the computation graph.
  # We terminate on acceptance or crash.
  def computation_tree(config, verbose=false, whitespace="")
    @max = @max > config.input.size ? @max : config.input.size # this is how we know the length of the *initial* input string
    print "(#{config.state}, #{config.input}, #{config.stack})\n" if verbose
    moves = get_moves(config) # Let's go get some moves based on our current configuration
    
    # But let's handle the terminal cases of our recursion first
    if config.state == @accepting_state && config.input.empty? && config.stack == "Z"
      accept "Accept\n", verbose
    elsif moves.nil? || moves.empty? || whitespace.size > 2 * @max
      # We normally only crash when we don't have any moves
      # *But* Note: kind of a hack, but I crash early if you've reached 2*@max computations 
      # because some computations can go on forever
      crash "Crash! I couldn't find a rule for: state #{config.state}, input #{config.input}, stack #{config.stack}\n", verbose
    else
      # OK, we're not in a terminal condition. I guess we need those moves we found.
      moves.each do |m|
        print "rule %2s #{whitespace}|-" % m.rule_number if verbose
        rule = find_rule_by_number(m.rule_number)
        if(!rule.nil? && rule.config.input.empty?)
          unread = config.input         # If this is a lambda transition, we don't read input
        else
          unread = top(config.input)[1] # Otherwise, we read a character off the top
        end
        # Recurse. Our new configuration uses: the state given by the move, our new unread input, stack with top symbol replaced
        computation_tree(Configuration.new(m.state, unread, m.stack + top(config.stack)[1]), verbose, whitespace + " ")
      end
    end
  rescue NoMethodError => e
    print "whitespace was [%s] and its length was [%d] and its class is %s\n" % [whitespace, whitespace.size, whitespace.class]
    print "@max's class is %s\n" % [@max.class]
    raise
  end
  
private
  # This method slices the first character off the top of a given string.
  # We then return the results as a two element array.
  # e.g. "Hello" would become ["H", "ello"]
  # thus, top("Hello")[0] == "H" and top("Hello")[1] == "ello"
  def top(str)
    [str.slice(0, 1), str.size > 1 ? str.slice(1, str.size) : ""]
  end

  # Based upon the given configuration, we go find all rules that match the configuration
  # Ultimately, we want the *moves* that those rules map to, so we flatten the list out
  def get_moves(config)
    rules = @rules.find_all do |r| 
      r.config.state == config.state \
      && (r.config.input == top(config.input)[0] || r.config.input.empty?) \
      && r.config.stack == top(config.stack)[0]
    end
    # We flatten this list because we want a list of moves, not rules
    moves = rules.map { |r| r.moves }.flatten
  end

  # given a rule number, go find the rule
  def find_rule_by_number(number)
    @rules.find { |r| r.number == number }
  end

  # this method simply prints a message (if verbose) and keeps track of leaf nodes
  # and whether the string accepts or not
  def accept(msg, verbose)
    print msg if verbose
    @leaf_nodes += 1 unless @leaf_nodes.nil?
    @accept = true
  end

  # this method simply prints a message (if verbose) and keeps track of leaf nodes
  def crash(msg, verbose)
    print msg if verbose
    @leaf_nodes += 1 unless @leaf_nodes.nil?
  end
end