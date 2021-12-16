class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.references :portfolio, null: false, foreign_key: true
      t.text :ticker
      t.integer :amount
      t.decimal :balance_change

      t.timestamps
    end
  end
end
