class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.references :type, index: true
      t.references :report, index: true
      t.string :value
      t.integer :day
    end
  end
end
