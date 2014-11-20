class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :url
      t.date :start_date
    end
  end
end
