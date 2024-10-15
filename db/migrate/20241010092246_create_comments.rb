class CreateComments < ActiveRecord::Migration[7.2]
  def change
    create_table :comments do |t|
      t.integer :commenter
      t.text :content
      t.references :micropost, null: false, foreign_key: true

      t.timestamps
    end
  end
end
