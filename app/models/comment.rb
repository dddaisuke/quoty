class Comment < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: :user, recipient: proc {|c, m| m.quote.user }, only: [:create], params: {
    summary: proc { |c, m| c && c.truncate(m.content, length: 30) }
  }

  belongs_to :quote, counter_cache: true
  belongs_to :user

  validates_presence_of :content, :quote

  scope :recent, -> { order("created_at DESC") }
end
