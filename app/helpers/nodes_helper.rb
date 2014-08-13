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
          :bel_function => node.fx
          ##  :parent => 'nparent', // indicates the compound node parent id; not defined => no parent
        }
      }
    end.to_json.html_safe
  end

  ##
  ## Add here new json graph formats
  ##
  ## OBS: Remember to add its constant value to config/initializers/json_graph_constants.rb
end
