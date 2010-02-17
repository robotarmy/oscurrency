class AddNotifications < ActiveRecord::Migration
  def self.up
    add_column :people, :notifications, :boolean, :default => true
    add_column :people, :active, :boolean, :default => true
  end

  def self.down
    remove_column :people, :notifications
    remove_column :people, :active
  end
end
