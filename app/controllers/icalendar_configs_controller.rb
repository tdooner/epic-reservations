class ICalendarConfigsController < ApplicationController
  before_action :set_config

  def show
  end
  
  def update
    if @config.update(icalendar_config_params)
      flash[:info] = 'Success!'
    end
    redirect_to icalendar_configs_path
  end

  private

  def set_config
    @config = current_user.icalendar_config || current_user.build_icalendar_config
  end

  def icalendar_config_params
    params.fetch(:icalendar_config, {}).permit(:public_share_code, :display_name)
  end
end
