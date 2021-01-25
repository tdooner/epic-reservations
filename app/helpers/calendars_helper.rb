module CalendarsHelper
  def print_reservations(reservations)
    safe_join(reservations.map do |reservation|
      "#{reservation.resort_name} (#{reservation.user.icalendar_config.display_name})"
    end, '<br>'.html_safe)
  end

  def print_forecast(forecast)
    has_snow_forecast = forecast.snow_day != '0' || forecast.snow_overnight != '0'

    safe_join([
      "Temp: #{forecast.temperature_high}/#{forecast.temperature_low}",
      ("Snow: #{forecast.snow_day} (day) / #{forecast.snow_overnight} (overnight)" if has_snow_forecast),
      (forecast.remarks if forecast.remarks.present?), 
    ].compact, ' | ')
  end
end
