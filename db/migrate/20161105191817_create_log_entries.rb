class CreateLogEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :log_entries do |t|
      t.integer :day
      t.text :food
      t.boolean :binge
      t.boolean :vomit
      t.boolean :laxative
      t.text :personal_notes
      t.string :time
      t.datetime :created_at
      t.datetime :updated_at
      t.integer :patient_id
      t.datetime :date
      t.integer :convo_handler_id
      t.text :location

      t.timestamps
    end
  end
end
