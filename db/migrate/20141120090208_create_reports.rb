class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.references :location, index: true
      t.references :event, index: true
      t.integer :year
      t.integer :month
      t.integer :day
    end
  end
end
