class Teacher < ActiveRecord::Base
    has_many :students
    has_many :appointments, through: :students

    has_secure_password
    validates :name, presence: true
    validates :email, confirmation: true, presence: true, uniqueness: true
end