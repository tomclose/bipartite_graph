require 'spec_helper'

describe "AlternatingTree" do
  let(:graph) { BipartiteGraph.new }
  let(:edge1) { graph.add_edge('Abe', 'Homer') }
  let(:edge2) { graph.add_edge('Homer', 'Bart') }
  let(:edge3) { graph.add_edge('Homer', 'Lisa') }
  let(:edge4) { graph.add_edge('Homer', 'Maggie') }

  let(:tree) { BipartiteGraph::AlternatingTree.new(graph, 'Abe') }
  describe "empty" do
    it "includes the root" do
      expect(tree.has_node?("Abe")).to be true
    end
  end

  describe "with edges" do
    before do
      tree.add_edge edge1
      tree.add_edge edge2
      tree.add_edge edge3
      tree.add_edge edge4
    end

    it "#nodes" do
      expect(tree.nodes).to match_array(%w(Abe Homer Bart Lisa Maggie))
    end

    it "#has_node?" do
      expect(tree.has_node?("Bart")).to  be true
      expect(tree.has_node?("Marge")).to be false
    end

    it "path_to" do
      expect(tree.path_to("Maggie")).to eq([edge1, edge4])
    end
  end
end
