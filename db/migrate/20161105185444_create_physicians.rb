class CreatePhysicians < ActiveRecord::Migration[5.0]
  def change
    create_table :physicians do |t|
      t.string :email
      t.string :password_digest
      t.datetime :created_at
      t.datetime :updated_at
      t.string :first_name
      t.string :last_name
      t.string :state
      t.string :specialty
      t.integer :arch_id
      t.boolean :archive

      t.timestamps
    end
  end
end
