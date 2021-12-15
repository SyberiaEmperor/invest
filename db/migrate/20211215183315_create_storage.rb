class CreateStorage < ActiveRecord::Migration[6.1]
  def change
    create_table :storage, id: false do |t|
      t.belongs_to :portfolio
      t.string :ticker, null: false
      t.integer :amount, null: false
    end
  end
end
