require 'spec_helper'

describe "weighted matchings" do
  let(:graph) { BipartiteGraph.new }
  describe "simple example 1" do
    #http://www.cse.ust.hk/~golin/COMP572/Notes/Matching.pdf
    before do
      [
        ['x1', 'y1', 1],
        ['x1', 'y2', 6],
        ['x2', 'y2', 8],
        ['x2', 'y3', 6],
        ['x3', 'y1', 4],
        ['x3', 'y3', 1]
      ].each { |from, to, weight| graph.add_edge(from, to, weight) }
    end

    it "finds the solution" do
      matching = graph.max_weight_matching.edges.map {|e| [e.from, e.to] }

      expect(matching).to match_array([
        ['x1', 'y2'], ['x2', 'y3'], ['x3', 'y1']
      ])
    end
  end

  describe "simple example 2" do

    before do
      [
        ['x1', 'y1', 3],
        ['x1', 'y2', 1],
        ['x2', 'y1', 11],
        ['x2', 'y2', 8],
        ['x2', 'y3', 6],
        ['x3', 'y1', 10],
        ['x3', 'y2', 9],
        ['x3', 'y3', 8],
        ['x3', 'y4', 7],
        ['x4', 'y3', 6],
        ['x4', 'y4', 4]
      ].each { |from, to, weight| graph.add_edge(from, to, weight) }
    end

    it "finds the solution" do
      matching = graph.max_weight_matching.edges.map {|e| [e.from, e.to] }

      expect(matching).to match_array([
        ['x1', 'y2'], ['x2', 'y1'], ['x3', 'y4'], ['x4', 'y3']
      ])
    end
  end

  describe "unbalanced example" do
    before do
      [
        ['x1', 'y1', 3],
        ['x1', 'y2', 1],
        ['x1', 'y3', 11]
      ].each { |from, to, weight| graph.add_edge(from, to, weight) }
    end

    it "finds the solution" do
      matching = graph.max_weight_matching.edges.map {|e| [e.from, e.to] }

      expect(matching).to match_array([
        ['x1', 'y3']
      ])
    end
  end
end
