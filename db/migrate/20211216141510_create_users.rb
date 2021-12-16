class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.text :login, null: false
      t.text :hash
      t.timestamps
    end
  end
end
