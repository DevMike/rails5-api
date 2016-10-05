class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.text :body
      t.references :sender
      t.references :receiver
      t.timestamps
    end

    add_index :messages, [:sender_id, :receiver_id], unique: true
  end
end
