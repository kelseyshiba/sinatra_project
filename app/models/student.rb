class Student < ActiveRecord::Base
    belongs_to :teacher
    has_many :appointments
    
    has_secure_password
    validates :name, presence: true
    validates :email, confirmation: true
end