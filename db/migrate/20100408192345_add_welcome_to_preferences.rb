class AddWelcomeToPreferences < ActiveRecord::Migration
  def self.up
    add_column :preferences, :welcome, :text
  end

  def self.down
    remove_column :preferences, :welcome
  end
end
