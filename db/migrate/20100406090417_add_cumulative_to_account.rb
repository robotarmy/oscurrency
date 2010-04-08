class AddCumulativeToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :total_paid, :decimal, :precision => 8, :scale => 2, :default => 0
    add_column :accounts, :total_earned, :decimal,  :precision => 8, :scale => 2,:default => 0
    Account.reset_column_information 
    exchanges = Exchange.find(:all)
    exchanges.each do |t| 
      a=t.customer.account
      a.total_paid += t.amount
      a.save!
      b= t.worker.account
      b.total_earned += t.amount
      b.save!
    end
  end

  def self.down
    remove_column :accounts, :total_earned
    remove_column :accounts, :total_paid
  end
end
 
