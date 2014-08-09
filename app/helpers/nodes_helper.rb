module NodesHelper
  ##
  ## JSON Graph Plugin Adapter | Nodes
  ##
  ## These functions translate nodes into their
  ## respective formats and configurations.
  ##
  ##

  ##  JSON Graph Specification
  ##
  ##  source: https://github.com/jsongraph/json-graph-specification
  def nodes_as_json_graph_specification(nodes)
    nodes.collect do |node|
      {
        :id => node.id,
        :label => node.label,
        :metadata => {
          :fx => node.fx
        }
      }
    end.to_json.html_safe
  end
  
  ## Cytoscape.js Graph Notation
  ##
  ## source: http://cytoscape.github.io/cytoscape.js/#notation
  ##
  ## OBS: Commented lines are styling optional parameters.
  ## Uncomment to use them.
  def nodes_as_json_graph_cytoscape(nodes)
    nodes.collect do |node|
      {
        :group => 'nodes',
        :data => {
          :id => 'n' + node.id.to_s,
          :name => node.label,
          :metadata => {
            :fx => node.fx
          }
          ##  :parent => 'nparent', // indicates the compound node parent id; not defined => no parent
        }
      }

      ## position: { // the model position of the node (optional on init, mandatory after)
      ##  x: 100,
      ##  y: 100
      ## },
      ## selected: false, // whether the element is selected (default false)
      ## selectable: true, // whether the selection state is mutable (default true)
      ## locked: false, // when locked a node's position is immutable (default false)
      ## grabbable: true, // whether the node can be grabbed and moved by the user
      ## classes: 'foo bar', // a space separated list of class names that the element has
      ## // NB: you should only use `css` for very special cases; use classes instead
      ## css: { 'background-color': 'red' } // overriden style properties
    end.to_json.html_safe
  end

  ##
  ## Add here new json graph formats
  ##
  ## OBS: Remember to add its constant value to config/initializers/json_graph_constants.rb
end
