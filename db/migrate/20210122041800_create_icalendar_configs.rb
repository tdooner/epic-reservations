class CreateICalendarConfigs < ActiveRecord::Migration[6.0]
  def change
    create_table :icalendar_configs do |t|
      t.references :user
      t.string :public_share_code
      t.string :display_name

      t.timestamps
    end
  end
end
