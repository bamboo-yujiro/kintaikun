class CreateEndInBreaks < ActiveRecord::Migration[5.1]
  def change
    create_table :end_in_breaks do |t|
      t.integer :attendance_id, null: false, default: 0
      t.time :time
      t.timestamps

      t.index :attendance_id, unique: false
    end
  end
end
