class UserMailer < ApplicationMailer
  def reservation_created(user, reservation)
    @user = user
    @reservation = reservation

    mail(
      to: @user.email,
      subject: "New EpicMix Reservation: #{@reservation.resort_name} #{@reservation.reservation_date}"
    )
  end

  def reservation_destroyed(user, resort, date)
    @user = user
    @resort = resort
    @date = date

    mail(
      to: @user.email,
      subject: "EpicMix Reservation Deleted: #{@resort} #{@date}"
    )
  end
end
