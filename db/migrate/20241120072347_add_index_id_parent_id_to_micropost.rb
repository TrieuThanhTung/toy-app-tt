class AddIndexIdParentIdToMicropost < ActiveRecord::Migration[7.2]
  def change
    add_index :microposts, [:id, :parent_id], unique: true
  end
end
