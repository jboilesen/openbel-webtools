class Node < ActiveRecord::Base
  belongs_to :graph
  has_many :edge_source, :class_name => 'Edge', :foreign_key => 'source_node_id', dependent: :destroy
  has_many :edge_target, :class_name => 'Edge', :foreign_key => 'target_node_id', dependent: :destroy
end
