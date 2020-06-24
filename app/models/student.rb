class Student < ActiveRecord::Base
    has_many :appointments
    
    has_secure_password
    validates :name, presence: true
    validates :email, confirmation: true, presence: true, uniqueness: true

    def sorted_appointments
        
    end
end