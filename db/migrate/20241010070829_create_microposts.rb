class CreateMicroposts < ActiveRecord::Migration[7.2]
  def change
    create_table :microposts do |t|
      t.string :title
      t.text :content
      t.integer :user_id

      t.timestamps
    end
  end
end
