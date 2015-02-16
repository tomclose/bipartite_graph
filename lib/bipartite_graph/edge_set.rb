module BipartiteGraph
  class EdgeSet
    include Enumerable
    attr_reader :edges, :filter

    def initialize(edges = Set.new, filter = {})
      @edges = edges
      @filter = filter
    end

    def <<(edge)
      add(edge)
    end

    def add(edge)
      edges.add(edge)
    end

    def delete(edge)
      edges.delete(edge)
    end

    def length
      to_a.length
    end
    def empty?
      to_a.empty?
    end

    def from(node_or_nodes)
      from_set = Set.new(Array(node_or_nodes))
      self.class.new(edges, filter.merge({ from: from_set }))
    end

    def not_to(node_or_nodes)
      not_to_set = Set.new(Array(node_or_nodes))
      self.class.new(edges, filter.merge({ not_to: not_to_set }))
    end

    def each
      from_set   = filter[:from]
      not_to_set = filter[:not_to]
      edges.each do |edge|
        from_cond   = !from_set   || from_set.include?(edge.from)
        not_to_cond = !not_to_set || !not_to_set.include?(edge.to)

        yield edge if from_cond && not_to_cond
      end
    end
  end
end
