class Students < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :password_digest
      t.belongs_to :teacher
    end
  end
end
