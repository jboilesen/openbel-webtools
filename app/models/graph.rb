class Graph < ActiveRecord::Base
  belongs_to :belfile
  has_many :nodes, dependent: :destroy
  has_many :edges, dependent: :destroy
end
