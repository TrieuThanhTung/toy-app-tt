class CreateProviders < ActiveRecord::Migration[7.2]
  def change
    create_table :providers do |t|
      t.references :user, null: false, foreign_key: true
      t.string :provider_name
      t.string :uid

      t.timestamps
    end

    add_index :providers, [ :provider_name, :uid ], unique: true
  end
end
