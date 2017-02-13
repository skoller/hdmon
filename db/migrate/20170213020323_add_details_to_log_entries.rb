class AddDetailsToLogEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :log_entries, :password_digest, :string
  end
end
