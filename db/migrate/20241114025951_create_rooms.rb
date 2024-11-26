class CreateRooms < ActiveRecord::Migration[7.2]
  def change
    create_table :rooms do |t|
      t.string :title, null: false, index: true, default: ""
      t.string :room_type, null: false, default: "private"

      t.timestamps
    end
  end
end
