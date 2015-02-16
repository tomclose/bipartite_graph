require 'spec_helper'

describe BipartiteGraph do
  it 'has a version number' do
    expect(BipartiteGraph::VERSION).not_to be nil
  end

  it "has a new method" do
    expect(BipartiteGraph.new).not_to be nil

  end
end
