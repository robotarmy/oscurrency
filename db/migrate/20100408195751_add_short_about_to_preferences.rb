class AddShortAboutToPreferences < ActiveRecord::Migration
  def self.up
    add_column :preferences, :short_about, :text
  end

  def self.down
    remove_column :preferences, :short_about
  end
end
