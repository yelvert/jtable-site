class CreateWidgets < ActiveRecord::Migration
  def self.up
    create_table :widgets do |t|
      t.string :name
      t.text :content
      t.boolean :test_1
      t.string :test_2

      t.timestamps
    end
  end

  def self.down
    drop_table :widgets
  end
end
