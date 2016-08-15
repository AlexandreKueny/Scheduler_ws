class CollaboratorsLink < ApplicationRecord
  belongs_to :user
  belongs_to :collaborator, class_name: User

  scope :accepted, -> { where(accepted: true)}
  scope :unaccepted, -> { where(accepted: false) }
  scope :requested_to, ->(user) { where(collaborator_id: user.id) }

end
