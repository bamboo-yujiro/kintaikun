class CreateStartInBreaks < ActiveRecord::Migration[5.1]
  def change
    create_table :start_in_breaks do |t|
      t.integer :attendance_id, null: false, default: 0
      t.time :time
      t.timestamps

      t.index :attendance_id, unique: false
    end
  end
end
