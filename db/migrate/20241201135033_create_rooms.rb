class CreateRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :is_private, :default => false

      t.timestamps
    end
  end
end
