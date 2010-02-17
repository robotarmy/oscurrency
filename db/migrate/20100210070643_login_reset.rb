class LoginReset < ActiveRecord::Migration
  def self.up
    add_column :people, :login_reset_key, :string
    add_column :people, :login_reset_key_expire, :datetime
  end

  def self.down
    drop_column :people, :login_reset_key
    drop_column :people, :login_reset_key_expire
  end
end
