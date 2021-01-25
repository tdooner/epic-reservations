class WeatherForecast < ApplicationRecord
  def self.from_reservations(reservations)
    reservations.reduce(WeatherForecast.none) do |scope, i|
      scope.or(WeatherForecast.where(
        date: i.reservation_date,
        resort_name: i.resort_name
      ))
    end
  end
end
