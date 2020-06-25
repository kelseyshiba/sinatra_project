class RemoveBelongstoFromStudent < ActiveRecord::Migration
  def change
    remove_column :students, :teacher_id
    Student.reset_column_information
  end
end
