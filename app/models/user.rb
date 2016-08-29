class User < ApplicationRecord

  has_many :messages
  has_many :chat_rooms_users
  has_many :chat_rooms, through: :chat_rooms_users
  has_many :collaborators_links
  has_many :collaborators, through: :collaborators_links
  has_many :events

  scope :searchable, -> { where('searchable IS true') }
  scope :not, ->(user) { where.not(id: user.id) }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable, :zxcvbnable

  def send_devise_notification(notification, *args)
    if Rails.env.production?
      # No worker process in production to handle scheduled tasks
      devise_mailer.send(notification, self, *args).deliver_now
    else
      devise_mailer.send(notification, self, *args).deliver_later
    end
  end

end
