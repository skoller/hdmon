class CreateConvoHandlers < ActiveRecord::Migration[5.0]
  def change
    create_table :convo_handlers do |t|
      t.string :state
      t.integer :patient_id
      t.integer :log_entry_id
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
