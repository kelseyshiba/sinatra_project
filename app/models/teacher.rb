class Teacher < ActiveRecord::Base
    has_many :appointments
    has_many :students, through: :appointments

    has_secure_password
    validates :name, presence: true
    validates :email, confirmation: true, presence: true, uniqueness: true
end