module BipartiteGraph
  class Subgraph
    attr_reader :sources, :sinks, :edges, :graph, :nodes
    def initialize(graph)
      @graph = graph
      clear
    end

    def clear
      @sources = Set.new
      @sinks   = Set.new
      @nodes   = Set.new
      @edges   = EdgeSet.new
    end

    def add_edge(edge)
      @edges << edge
      @sources << edge.from
      @sinks   << edge.to
      @nodes = @sources + @sinks
    end

    def has_node?(node)
      nodes.include?(node)
    end

    def sources
      graph.sources.select {|node| has_node?(node) }
    end
    def sinks
      graph.sinks.select {|node| has_node?(node) }
    end
  end
end
