class CreateGrams < ActiveRecord::Migration[5.0]
  def change
    create_table :grams do |t|
      t.text :message
      t.timestamps
    end
  end
end
