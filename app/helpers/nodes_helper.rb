module NodesHelper
  def nodes_as_json(nodes)
    nodes.collect do |node|
      {
        :id => node.id,
        :label => node.label,
        :metadata => {
          :fx => node.fx
        }
      }
    end.to_json
  end
end
