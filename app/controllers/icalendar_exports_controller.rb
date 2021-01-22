require 'icalendar'

class ICalendarExportsController < ApplicationController
  before_action :set_configs

  def show
    cal = Icalendar::Calendar.new
    cal.x_wr_calname = 'Ski Reservations (Automatic)'

    @configs.flat_map do |config|
      config.user.reservations.map do |reservation|
        cal.event do |e|
          e.dtstart = Icalendar::Values::Date.new(reservation.reservation_date)
          e.dtend = Icalendar::Values::Date.new(reservation.reservation_date)
          e.summary = "#{reservation.resort_name} (#{config.display_name})"
          e.description = "Last fetched: #{reservation.fetched_at}"
        end
      end
    end

    respond_to do |format|
      format.ics { render plain: cal.to_ical }
      format.html { render plain: "<pre>#{cal.to_ical}</pre>" }
    end
  end

  private

  def set_configs
    @configs =
      ICalendarConfig
        .where(public_share_code: params[:public_share_code])
        .includes(user: :reservations)

    if @configs.none?
      raise ActiveResource::ResourceNotFound
    end
  end
end
