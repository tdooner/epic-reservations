class AddEpicUsernameAndPasswordToUser < ActiveRecord::Migration[6.0]
  def change
    change_table :users do |t|
      t.string :epic_username
      t.string :encrypted_epic_password
      t.string :encrypted_epic_password_iv
    end
  end
end
