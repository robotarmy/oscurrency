class PwdsHashedNotEncrypted < ActiveRecord::Migration
  def self.up

    add_column :people, :password_salt, :string

    Person.find(:all).each { |person|
      person.verify_password = true
      person.password = person.unencrypted_password
      person.password_confirmation = person.unencrypted_password
      person.save!
    }
    drop_table :local_encryption_keys

  end

  # can't go back
  def self.down
    error IrreversibleMigration
  end
end
