class Reservation < ApplicationRecord
  belongs_to :user

  after_create :notify_user_on_create
  after_destroy :notify_user_on_destroy

  def notify_user_on_create
    UserMailer
      .reservation_created(user, self)
      .deliver_now
  end

  def notify_user_on_destroy
    UserMailer
      .reservation_destroyed(user, resort_name, reservation_date)
      .deliver_now
  end
end
