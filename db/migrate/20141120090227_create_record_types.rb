class CreateRecordTypes < ActiveRecord::Migration
  def change
    create_table :record_types do |t|
      t.string :name
    end
  end
end
