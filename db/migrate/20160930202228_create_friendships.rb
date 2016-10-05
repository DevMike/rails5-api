class CreateFriendships < ActiveRecord::Migration[5.1]
  def change
    create_table :friendships do |t|
      t.references :user, null: false
      t.references :friend, null: false
      t.timestamps
    end

    add_index :friendships, [:user_id, :friend_id], unique: true
  end
end

