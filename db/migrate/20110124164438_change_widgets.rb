class ChangeWidgets < ActiveRecord::Migration
  def self.up
    add_column :widgets, :column_1, :string
    add_column :widgets, :column_2, :string
    add_column :widgets, :column_3, :string
    add_column :widgets, :column_4, :string
    Widget.destroy_all
    2500.times do |i|
      Widget.create(
        :name => "Widget #{i}",
        :content => "This is Widget #{i}",
        :test_1 => i%2==0,
        :test_2 => "testing #{i}",
        :column_1 => "Column 1 for Widget #{i}",
        :column_2 => "Column 2 for Widget #{i}",
        :column_3 => "Column 3 for Widget #{i}",
        :column_4 => "Column 4 for Widget #{i}"
      )
    end
  end

  def self.down
    remove_column :widgets, :column_4
    remove_column :widgets, :column_3
    remove_column :widgets, :column_2
    remove_column :widgets, :column_1
  end
end