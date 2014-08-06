class Belfile < ActiveRecord::Base
  has_one :graph, dependent: :destroy
end
