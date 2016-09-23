class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.belongs_to :product, index: true
      t.boolean :is_new
      t.boolean :is_updated
      t.boolean :is_restocked
      t.boolean :is_sent, default: false

      t.timestamps
    end
  end
end
