class ChangeMicroposts < ActiveRecord::Migration[7.2]
  def change
    remove_column :microposts, :title
    add_reference :microposts, :parent, null: true, foreign_key: { to_table: :microposts }
  end
end
