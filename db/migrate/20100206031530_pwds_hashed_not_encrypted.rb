class PwdsHashedNotEncrypted < ActiveRecord::Migration
  def self.up

    if Person.count(:conditions => "crypted_password is not null") > 0 && LocalEncryptionKey.count == 0
      raise "Can't migrate to hash without the RSA encryption keys"
    end

    add_column :people, :password_salt, :string
    Person.reset_column_information # stupid rails can't figure this out for itself

    Person.find(:all, :conditions => "crypted_password is not null").each { |person|
      person.verify_password = true
      person.password = person.unencrypted_password
      person.password_confirmation = person.unencrypted_password
      person.save!
      p [person.name, person.password_salt]
    }
    drop_table :local_encryption_keys

  end

  # can't go back
  def self.down
    error IrreversibleMigration
  end
end
