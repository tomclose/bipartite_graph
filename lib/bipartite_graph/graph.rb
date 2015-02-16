module BipartiteGraph
  class Graph
    attr_reader :sources, :sinks, :edges, :nodes
    def initialize
      clear
    end

    def clear
      @nodes   = Set.new
      @sources = Set.new
      @sinks   = Set.new
      @edges   = EdgeSet.new
    end

    def add_edge(from, to, weight=1)
      @sources << from
      @sinks << to
      @nodes = @sources + @sinks

      edge = Edge.new(from, to, weight)
      @edges << edge
      edge
    end

    def node_for(key)
      @nodes[key]
    end


    def max_weight_matching
      HungarianAlgorithm.new(self).solution
    end
  end
end
