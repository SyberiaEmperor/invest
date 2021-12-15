class CreatePortfolios < ActiveRecord::Migration[6.1]
  def change
    create_table :portfolios do |t|
      t.belongs_to :user
      t.string :title, null: false
      t.timestamps
    end
  end
end
