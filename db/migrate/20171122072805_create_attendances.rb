class CreateAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :attendances do |t|
      t.date :date
      t.time :arrival_time
      t.time :leaving_time
      t.integer :user_id, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.timestamps

      t.index :user_id, unique: false

    end
  end
end
