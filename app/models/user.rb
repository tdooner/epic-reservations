class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :trackable,
    :recoverable, :rememberable, :validatable
  attr_encrypted :epic_password, key: ENV['DATABASE_ENCRYPTION_KEY']

  has_many :reservations
end
