class ChangeProviderNameColumn < ActiveRecord::Migration[7.2]
  def change
    rename_column :providers, :provider_name, :name
  end
end
