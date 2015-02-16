require 'spec_helper'

describe 'EdgeSet' do
  let(:edge_set) { BipartiteGraph::EdgeSet.new }

  let(:edge1) { BipartiteGraph::Edge.new('0C0', '1C0') }
  let(:edge2) { BipartiteGraph::Edge.new('0C0', '1C1') }
  let(:edge3) { BipartiteGraph::Edge.new('1C0', '2C0') }
  let(:edge4) { BipartiteGraph::Edge.new('1C0', '2C1') }
  let(:edge5) { BipartiteGraph::Edge.new('1C1', '2C1') }
  let(:edge6) { BipartiteGraph::Edge.new('1C1', '2C2') }

  before do
    edge_set << edge1
    edge_set << edge2
    edge_set << edge3
    edge_set << edge4
    edge_set << edge5
    edge_set << edge6
  end

  describe "enumerablility" do
    it "(for example) can be converted to an array" do
      expect(edge_set.to_a).to match_array([edge1, edge2, edge3, edge4, edge5, edge6])
    end

    it "(for example) can be mapped" do
      expect(edge_set.map(&:from)).to match_array(%w(0C0 0C0 1C0 1C0 1C1 1C1))
    end

    it "(for example) can do an any?" do
      expect(edge_set.any? {|e| e.to == '2C2'}).to be true
    end
  end

  describe "length" do
    it "will give its length" do
      expect(edge_set.length).to eq(6)
    end
  end

  describe "filtering" do
    let(:filtered_edge_set) { edge_set.from('1C1').not_to('2C1') }

    it "returns an edge set" do
      expect(filtered_edge_set).to be_a BipartiteGraph::EdgeSet
    end

    it "filters appropriately" do
      expect(filtered_edge_set.to_a).to match_array([edge6])
    end
  end

end
