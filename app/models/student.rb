class Student < ActiveRecord::Base
    belongs_to :teacher
    has_many :appointments
end