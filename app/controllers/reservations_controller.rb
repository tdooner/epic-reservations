class ReservationsController < ApplicationController
  def show
    @reservations = current_user.reservations
    @forecasts = WeatherForecast.from_reservations(@reservations).all
  end
end
