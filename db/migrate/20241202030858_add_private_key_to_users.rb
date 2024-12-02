class AddPrivateKeyToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :private_key, :integer
  end
end
