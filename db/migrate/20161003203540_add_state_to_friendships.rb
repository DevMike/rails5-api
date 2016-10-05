class AddStateToFriendships < ActiveRecord::Migration[5.1]
  def change
    add_column :friendships, :state, :string, default: 'friend', null: false
  end
end
