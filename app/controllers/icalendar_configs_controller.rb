class ICalendarConfigsController < ApplicationController
  def show
    @config = current_user.icalendar_config || current_user.build_icalendar_config
  end
  
  def update
  end

  private

  def icalendar_config_params
  end
end
