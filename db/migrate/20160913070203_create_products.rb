class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.decimal :price, :precision => 8, :scale => 2
      t.decimal :old_price, :precision => 8, :scale => 2
      t.string :link
      t.string :name

      t.timestamps
    end
  end
end
