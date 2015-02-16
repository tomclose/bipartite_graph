require 'spec_helper'

describe "hungarian algorithm" do

  let(:simple_example_edges) do
    #http://www.cse.ust.hk/~golin/COMP572/Notes/Matching.pdf
    [
      ['x1', 'y1', 1],
      ['x1', 'y2', 6],
      ['x2', 'y2', 8],
      ['x2', 'y3', 6],
      ['x3', 'y1', 4],
      ['x3', 'y3', 1]
    ]
  end

  let(:simple_example_solution) do
    [
      ['x1', 'y2'],
      ['x2', 'y3'],
      ['x3', 'y1']
    ]
  end

  let(:graph) { BipartiteGraph.new }
  before do
    simple_example_edges.each do |from, to, weight|
      graph.add_edge(from, to, weight)
    end
  end
  let(:alg) { BipartiteGraph::HungarianAlgorithm.new(graph) }

  describe "setup" do

    it "calculates an initial labelling" do
      expect(alg.labelling.labels).to eq({
        'x1' => 6, 'x2' => 8, 'x3' => 4, 'y1' => 0, 'y2' => 0, 'y3' => 0
      })
    end

    it "calculates the equality graph" do
      expect(alg.labelling.equality_graph.edges.map {|e| [e.from, e.to] }).to match_array([
        ['x1', 'y2'], ['x2', 'y2'], ['x3', 'y1']
      ])
    end

    it "calculates an initial matching" do
      matching = alg.matching.edges.map {|e| "#{e.from} -> #{e.to}" }.sort

      allowed_matching1 = ['x1 -> y2', 'x3 -> y1']
      allowed_matching2 = ['x2 -> y2', 'x3 -> y1']

      expect([allowed_matching1, allowed_matching2]).to include(matching)
    end
  end

  describe "full iteration" do
    before do
      # have to assume we started with matching1 for algorithm to progress like this
      matching = alg.matching.edges.map {|e| "#{e.from} -> #{e.to}" }.sort
      allowed_matching1 = ['x1 -> y2', 'x3 -> y1']
      expect(matching).to eq(allowed_matching1)

      alg.add_to_matching('x2')
    end

    it "updates the labelling" do
      expect(alg.labelling.labels).to eq({
        'x1' => 4, 'x2' => 6, 'x3' => 4, 'y1' => 0, 'y2' => 2, 'y3' => 0
      })
    end

    it "updates the equality graph" do
      expect(alg.labelling.equality_graph.edges.map {|e| [e.from, e.to] }).to match_array([
        ['x1', 'y2'], ['x2', 'y2'], ['x2', 'y3'], ['x3', 'y1']
      ])
    end

    it "updates the matching" do
      matching = alg.matching.edges.map {|e| "#{e.from} -> #{e.to}" }.sort

      expect(matching).to eq(['x1 -> y2', 'x2 -> y3', 'x3 -> y1'])
    end



  end

end
