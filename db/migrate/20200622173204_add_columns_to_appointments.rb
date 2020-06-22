class AddColumnsToAppointments < ActiveRecord::Migration
  def change
    remove_column :appointments, :time
    remove_column :appointments, :date
    add_column :appointments, :start, :datetime
    add_column :appointments, :end, :datetime
    Appointment.reset_column_information
  end
end
