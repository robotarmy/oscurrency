class AddEmailNoticesBoolean < ActiveRecord::Migration
  def self.up
    add_column :preferences, :email_notices, :boolean, :default => true
  end

  def self.down
    remove_column :preferences, :email_notices
  end
end
