module BipartiteGraph
  class HungarianAlgorithm
    attr_reader :labelling, :matching, :graph, :original_graph

    def initialize(graph)
      @original_graph = graph
      @graph = BipartiteGraph::CompleteGraph.new(graph)
      @labelling = Labelling.new(@graph)
      @matching = create_initial_matching
    end

    def solution
      while matching.weight != labelling.total
        root = (graph.sources - matching.sources).first
        add_to_matching(root)
      end

      restricted_matching(matching, original_graph)
    end

    def restricted_matching(matching, graph)
      m = Matching.new(graph)

      matching.edges.each do |edge|
        m.add_edge(edge) if edge.weight > 0  # will exclude fake nodes as they're
                                             # only reachable from 0 edges
      end
      m
    end

    def create_initial_matching
      eq_graph = labelling.equality_graph

      matching = Matching.new(graph)

      eq_graph.sources.each do |source|
        eq_graph.edges.from(source).each do |edge|
          included = matching.has_node?(edge.to)

          if !included
            matching.add_edge(edge)
            next
          end
        end
      end
      matching
    end

    class Labelling
      # subgraph of edges where weight = sum of end labels
      attr_reader :equality_graph, :graph, :labels

      def initialize(graph)
        @labels = {}
        @graph = graph
        @equality_graph = Subgraph.new(graph)

        graph.sources.each do |node|
          edges = graph.edges.from(node)
          max_weight = edges.map(&:weight).max
          @labels[node] = max_weight
        end

        graph.sinks.each do |node|
          @labels[node] = 0
        end

        recalculate_equality_graph
      end

      def label_for(node)
        @labels[node]
      end

      def total
        graph.nodes.inject(0) {|sum, node| sum + label_for(node) }
      end

      def recalculate_equality_graph
        equality_graph.clear

        graph.edges.select {|e| e.weight == labels[e.from] + labels[e.to]}.each do |edge|
          equality_graph.add_edge(edge)
        end
      end

      def update(nodes_to_increase, nodes_to_decrease, change)
        raise "Change must be positive" unless change > 0
        nodes_to_increase.each { |n| labels[n] += change }
        nodes_to_decrease.each { |n| labels[n] -= change }

        recalculate_equality_graph #could be cleverer about this ..
      end
    end

    class Matching
      attr_reader :edges, :graph

      def initialize(graph)
        @graph = graph
        @edges = EdgeSet.new
      end

      def edge_for(node)
        @edges.find {|edge| edge.to == node || edge.from == node }
      end

      def has_node?(node)
        !!edge_for(node)
      end

      def sources
        graph.sources.select {|node| has_node?(node) }
      end

      def perfect?
        2 * edges.length == graph.nodes.length
      end

      def weight
        edges.inject(0) {|sum, e| sum + e.weight }
      end

      def add_edge(edge)
        edges << edge
      end

      def delete_edge(edge)
        edges.delete(edge)
      end

      def apply_alternating_path(path)
        path.each_with_index do |edge, i|
          i.even? ? add_edge(edge) : delete_edge(edge)
        end
      end
    end

    def equality_graph
      labelling.equality_graph
    end

    def add_to_matching(root)
      tree = AlternatingTree.new(graph, root)
      matching_found = false

      while !matching_found
        new_edge = equality_graph.edges.from(tree.sources).not_to(tree.sinks).first

        if new_edge.nil?
          augment_labelling_using(tree)
        else
          tree.add_edge(new_edge)
          new_sink = new_edge.to

          existing_edge = matching.edge_for(new_sink)
          if existing_edge
            tree.add_edge(existing_edge)
          else
            matching.apply_alternating_path(tree.path_to(new_edge.to))
            matching_found = true
          end
        end
      end
    end

    def augment_labelling_using(tree)
      target_edges = graph.edges.from(tree.sources).not_to(tree.sinks)

      slack = target_edges.map do |edge|
        labelling.label_for(edge.from) + labelling.label_for(edge.to) - edge.weight
      end

      max_decrease = slack.min

      labelling.update(tree.sinks, tree.sources, max_decrease)
    end
  end
end
