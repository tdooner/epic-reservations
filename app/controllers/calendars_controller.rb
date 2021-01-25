class CalendarsController < ApplicationController
  before_action :set_config

  def show
    @date_range = Date.today..Date.today+7.days
    @reservations =
      Reservation
        .joins(user: :icalendar_config)
        .includes(user: :icalendar_config)
        .where(icalendar_configs: { public_share_code: @config.public_share_code })
        .where(reservation_date: @date_range)
    @forecasts = WeatherForecast.where(date: @date_range, resort_name: 'Heavenly')
  end
  
  def update
    if @config.update(icalendar_config_params)
      flash[:info] = 'Success!'
    end
    redirect_to calendar_path
  end

  private

  def set_config
    @config = current_user.icalendar_config || current_user.build_icalendar_config
  end

  def icalendar_config_params
    params.fetch(:icalendar_config, {}).permit(:public_share_code, :display_name)
  end
end
