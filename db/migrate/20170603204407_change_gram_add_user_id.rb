class ChangeGramAddUserId < ActiveRecord::Migration[5.0]
  def change
    add_column :grams, :user_id, :integer
    add_index :grams, :user_id
  end
end
