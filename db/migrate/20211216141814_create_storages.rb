class CreateStorages < ActiveRecord::Migration[6.1]
  def change
    create_table :storages do |t|
      t.references :portfolio, null: false, foreign_key: true
      t.text :ticker
      t.integer :amount
    end
  end
end
