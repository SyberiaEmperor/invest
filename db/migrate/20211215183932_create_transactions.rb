class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.belongs_to :portfolio
      t.string :ticker, null: false
      t.integer :amount, null: false
      t.decimal :balance_change, null: false
      t.timestamps
    end
  end
end
