class Wiki < ActiveRecord::Base
  has_ancestry

  attr_accessible :description, :title, :parent_id
  belongs_to :user

  validates :title, presence: true
end
