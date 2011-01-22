class FixCumulativeTotals < ActiveRecord::Migration
  def self.up
    # disable this, since we renamed the migration
    # but it was already run in production
    return true
    Person.find(:all).each do |p|  
      totalearned=0 
      totalpaid=0 
      p.transactions.each do |t| 
        if t.group_id == nil
          if t.worker_id == p.id 
            totalearned += t.amount  
          end 
          if t.customer_id == p.id 
            totalpaid += t.amount  
          end 
        end
      end
      a=p.account
      puts "#{p.id} #{p.name} since #{totalearned} #{totalpaid} #{a.balance}"
      puts "#{a.total_earned}"
      earndiff= totalearned - a.total_earned 
      if earndiff != 0
        puts "WRONG! off by #{earndiff}"
        a.total_earned = totalearned
        a.save!
      end
      puts "#{a.total_paid}"
      paidiff = totalpaid - a.total_paid 
      if paidiff != 0
        puts "WRONG! off by #{paidiff}"
        a.total_paid = totalpaid
        a.save!
      end
    end  
  end

  def self.down
  end
end
