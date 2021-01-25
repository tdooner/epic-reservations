namespace :epic do
  desc 'scrape reservations for users from epicmix'
  task scrape_reservations: :environment do
    User.find_each do |user|
      reservations = Scrapers::ReservationScraper.new(user.epic_username, user.epic_password).reservations

      Reservation.transaction do
        existing_reservations = reservations.map do |res|
          Reservation
            .find_or_create_by(user: user, resort_name: res[:resort], reservation_date: res[:date])
            .tap { |r| r.touch(:fetched_at) }
        end

        user.reservations.upcoming.where.not(id: existing_reservations).destroy_all
      end
    end
  end

  desc 'scrape weather from epic'
  task scrape_weather: :environment do
    needed_resorts = Reservation.upcoming.pluck(:resort_name).uniq | ['Heavenly']

    puts "Fetching weather for resorts: #{needed_resorts}"
    needed_resorts.each do |resort_name|
      Scrapers::WeatherScraper
        .new(resort_name)
        .fetch_weather_forecast
    end
  end
end
