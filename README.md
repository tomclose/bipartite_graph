# BipartiteGraph

Finds maximum matchings in weighted bipartite graphs, using the
[Hungarian algorithm](http://en.wikipedia.org/wiki/Hungarian_algorithm).


## Installation

Add this line to your application's Gemfile:

    gem 'bipartite_graph'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bipartite_graph

## Usage

```ruby
graph = BipartiteGraph.new

graph.add_edge('x1', 'y1', 1)
graph.add_edge('x1', 'y2', 6)
graph.add_edge('x2', 'y2', 8)
graph.add_edge('x2', 'y3', 6)
graph.add_edge('x3', 'y1', 4)
graph.add_edge('x3', 'y3', 1)

matching = graph.max_weight_matching

matching.edges.map { |e| [e.from, e.to] } #=> ['x1', 'y2'], ['x2', 'y3'], ['x3', 'y1']

matching.edges.sum(&:weight) #=> 16

```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/bipartite_graph/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
