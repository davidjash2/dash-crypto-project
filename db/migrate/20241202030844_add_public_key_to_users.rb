class AddPublicKeyToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :public_key, :integer
  end
end
