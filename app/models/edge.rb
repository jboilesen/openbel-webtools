class Edge < ActiveRecord::Base
  belongs_to :graph
  belongs_to :source, :class_name => 'Node', :foreign_key => 'source_id'
  belongs_to :target, :class_name => 'Node', :foreign_key => 'target_id'
end
