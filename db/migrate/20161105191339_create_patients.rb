class CreatePatients < ActiveRecord::Migration[5.0]
  def change
    create_table :patients do |t|
      t.string :first_name
      t.string :last_name
      t.string :dob
      t.string :sex
      t.float :diagnosis
      t.datetime :created_at
      t.datetime :updated_at
      t.string :phone_number
      t.integer :convo_handler_id
      t.integer :physician_id
      t.string :password_digest
      t.boolean :archive
      t.string :signup_status
      t.text :activity_history
      t.string :billing_status
      t.string :doctor_status
      t.string :start_code

      t.timestamps
    end
  end
end
