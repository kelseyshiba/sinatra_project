class Appointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.string :name
      t.time  :time
      t.date   :date
      t.integer :week_number
      t.belongs_to :teacher
      t.belongs_to :student
    end
  end
end
