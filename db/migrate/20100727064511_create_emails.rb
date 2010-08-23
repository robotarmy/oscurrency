class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails do |t|
      t.integer :from_id
      t.integer :to_id
      t.string :subject
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :emails
  end
end
