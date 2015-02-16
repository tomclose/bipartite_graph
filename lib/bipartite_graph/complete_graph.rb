require 'delegate'

module BipartiteGraph
  class CompleteGraph < SimpleDelegator
    class FakeNode; end

    def initialize(graph)
      @original_graph = graph
      @complete_graph = Graph.new

      sinks   = graph.sinks.dup
      sink_count = sinks.length
      sources = graph.sources.dup
      source_count = sources.length

      if sink_count > source_count
        (sink_count - source_count).times { sources << FakeNode.new }
      elsif source_count > sink_count
        (source_count - sink_count).times { sinks << FakeNode.new }
      end

      sources.each do |source|
        sinks.each do |sink|
          edge = graph.edge_between(source, sink)
          weight = edge ? edge.weight : 0
          @complete_graph.add_edge(source, sink, weight)
        end
      end

      super(@complete_graph)
    end

  end
end
