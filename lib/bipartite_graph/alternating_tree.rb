module BipartiteGraph
  # an alternating tree isn't a graph in its own right
  # it's a subgraph - you can't add things that aren't in the main graph
  class AlternatingTree
    attr_accessor :root, :graph
    def initialize(graph, root)
      raise "Root can't be nil" if root.nil?
      @root = root
      @graph = graph

      @node_map = {}
      @node_map[root] = [nil, nil]
    end

    def has_node?(node)
      @node_map.has_key?(node)
    end

    def nodes
      @node_map.keys
    end

    def sources
      graph.sources.select {|node| has_node?(node) }
    end
    def sinks
      graph.sinks.select {|node| has_node?(node) }
    end

    def add_edge(edge)
      #raise "Tree has no existing node #{edge.from}" unless has_node?(edge.from)
      #raise "Tree already contains node #{edge.to}" if has_node?(edge.to)
      if has_node?(edge.from)
        @node_map[edge.to] = [edge.from, edge]
      elsif has_node?(edge.to)
        @node_map[edge.from] = [edge.to, edge]
      else
        raise "Nodes not in tree: #{edge.from} or #{edge.to}"
      end
    end

    def path_to(leaf)
      path = []
      next_node, edge = @node_map[leaf]
      while edge
        path << edge
        next_node, edge = @node_map[next_node]
      end
      path.reverse
    end
  end

end
