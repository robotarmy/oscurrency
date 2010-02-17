class AddMoreEmailNotificationPreferences < ActiveRecord::Migration
  def self.up
    add_column :users, :notifications, :boolean, :default => true
    add_column :users, :active, :boolean, :default => true
  end

  def self.down
    remove_column :users, :notifications
    remove_column :users, :active
  end
end
