module EdgesHelper
  ##
  ## JSON Graph Plugin Adapter | Edges
  ##
  ## These functions translate nodes into their
  ## respective formats and configurations.
  ##
  ##

  ##  JSON Graph Specification
  ##
  ##  source: https://github.com/jsongraph/json-graph-specification
  def edges_as_json_graph_specification(edges)
    edges.collect do |edge|
      {
        :source => edge.source_id,
        :relation => edge.relation,
        :target => edge.target_id
      }
    end.to_json.html_safe
  end

  ## Cytoscape.js Graph Notation
  ##
  ## source: http://cytoscape.github.io/cytoscape.js/#notation
  def edges_as_json_graph_cytoscape(edges)
    edges.collect do |edge|
      {
        :group => 'edges',
        :data => {
          :id => 'e' + edge.id.to_s,
          :relation => edge.relation,
          :source => 'n' + edge.source_id.to_s, 
          :target => 'n' + edge.target_id.to_s
        }
      }
    end.to_json.html_safe
  end

  ##
  ## Add here new json graph formats
  ##
  ## OBS: Remember to add its constant value to config/initializers/json_graph_constants.rb
end
