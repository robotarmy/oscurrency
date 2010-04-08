class AddCumulativeToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :total_paid, :decimal, :precision => 8, :scale => 2, :default => 0
    add_column :accounts, :total_earned, :decimal,  :precision => 8, :scale => 2,:default => 0
    Account.reset_column_information 
    accounts = Account.find(:all)
    accounts.each do |a| 
      a.total_paid = 0
      a.total_earned = 0
      a.save!
    end
    exchanges = Exchange.find(:all)
    exchanges.each do |t| 
      a=t.customer.account
      a.total_paid += t.amount
      a.save!
      b= t.worker.account
      b.total_earned += t.amount
      b.save!
    end; nil
  end

  def self.down
    remove_column :accounts, :total_earned
    remove_column :accounts, :total_paid
  end
end
