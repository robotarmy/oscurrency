# == Schema Information
# Schema version: 20090216032013
#
# Table name: accounts
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)     
#  balance    :decimal(8, 2)   default(0.0)
#  person_id  :integer(4)      
#  created_at :datetime        
#  updated_at :datetime        
#

class Account < ActiveRecord::Base
  belongs_to :person
  belongs_to :group

  after_create :reset_totals

  INITIAL_BALANCE = 0

  def reset_totals
    begin
      self.total_paid = 0
      self.total_earned = 0
    rescue
      $stderr.puts "warning - ignore reset_totals exception"
    end
  end

  def withdraw(amount)
    self.total_paid += amount
    adjust_balance_and_save(-amount)
  end

  def deposit(amount)
    self.total_earned += amount
    adjust_balance_and_save(amount)
  end

  def adjust_balance_and_save(amount)
    self.balance += amount
    save!
  end

  def self.transfer(from, to, amount, metadata)
    transaction do
      exchange = Exchange.new()
      exchange.customer = from.person
      exchange.worker = to.person
      exchange.amount = amount
      exchange.metadata = metadata
      exchange.save!
    end
  end
end
