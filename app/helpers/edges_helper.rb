module EdgesHelper
  def edges_as_json(edges)
    edges.collect do |edge|
      {
        :source => edge.source_id,
        :relation => edge.label,
        :target => edge.target_id
      }
    end.to_json
  end
end
