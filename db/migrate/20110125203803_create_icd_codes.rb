class CreateIcdCodes < ActiveRecord::Migration
  def self.up
    create_table :icd_codes do |t|
      t.string :identifier
      t.string :short_description
      t.string :medium_description
      t.text :description
      t.string :code_type
      t.boolean :mcc
      t.boolean :cc
      t.date :activated
      t.date :deactivated

      t.timestamps
    end
  end

  def self.down
    drop_table :icd_codes
  end
end
