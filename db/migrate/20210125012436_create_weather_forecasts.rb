class CreateWeatherForecasts < ActiveRecord::Migration[6.0]
  def change
    create_table :weather_forecasts do |t|
      t.date :date
      t.string :resort_name
      t.integer :temperature_high
      t.integer :temperature_low
      t.string :snow_day
      t.string :snow_overnight
      t.string :remarks

      t.timestamps
    end
  end
end
