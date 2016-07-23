class User < ApplicationRecord

  has_many :messages
  has_and_belongs_to_many :chat_rooms

  scope :searchable, -> { where('searchable IS true') }

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
