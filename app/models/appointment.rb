class Appointment < ActiveRecord::Base
    belongs_to :teacher
    belongs_to :student

    def self.sort_appointments
        self.all.sort do |a, b|
            a.week_number <=> b.week_number
        end
    end
end