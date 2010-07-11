class AddTransientToCommunication < ActiveRecord::Migration
  def self.up
    add_column :communications, :transient, :boolean, :default => false
  end

  def self.down
    remove_column :communications, :transient
  end
end
