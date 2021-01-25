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

        user.reservations.where.not(id: existing_reservations).destroy_all
      end
    end
  end
end
