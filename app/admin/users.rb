ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  show do
    attributes_table do
      row :email
      row :last_sign_in_at
      row :created_at
    end

    panel 'Reservations' do
      table_for user.reservations.order(:reservation_date) do
        column :reservation_date
        column :resort_name
        column :fetched_at
      end
    end

    panel 'ICalendar Config' do
      table_for user.icalendar_config do
        column :public_share_code
        column :display_name
      end
    end
  end
end
