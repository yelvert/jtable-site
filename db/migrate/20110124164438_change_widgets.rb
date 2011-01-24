class ChangeWidgets < ActiveRecord::Migration
  def self.up
    add_column :widgets, :column_1, :string
    add_column :widgets, :column_2, :string
    add_column :widgets, :column_3, :string
    add_column :widgets, :column_4, :string
  end

  def self.down
    remove_column :widgets, :column_4
    remove_column :widgets, :column_3
    remove_column :widgets, :column_2
    remove_column :widgets, :column_1
  end
end