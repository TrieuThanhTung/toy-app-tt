class ChangeMessages < ActiveRecord::Migration[7.2]
  def change
    # remove_column :messages, :recipient_id
    add_reference :messages, :room, null: false, foreign_key: true
    add_column  :messages,:message_type, :string, null: false, default: "text"
  end
end
