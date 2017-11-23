class CreateStartOutOfOffices < ActiveRecord::Migration[5.1]
  def change
    create_table :start_out_of_offices do |t|
      t.integer :attendance_id, null: false, default: 0
      t.time :time
      t.timestamps

      t.index :attendance_id, unique: false
    end
  end
end
