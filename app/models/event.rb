class Event < ApplicationRecord

  belongs_to :user

  scope :not_overlap, -> { where(overlap: false) }

end
