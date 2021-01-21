class CreateReservations < ActiveRecord::Migration[6.0]
  def change
    create_table :reservations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :resort_name
      t.date :reservation_date
      t.timestamp :fetched_at
    end
  end
end
