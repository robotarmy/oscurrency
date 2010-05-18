class MaintenanceController < ApplicationController

  def fix_cumulative
    result=""
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
      result += "#{p.id} #{p.name} since #{totalearned} #{totalpaid} #{a.balance}\n"
      result += "#{a.total_earned}"
      earndiff= totalearned - a.total_earned 
      if earndiff != 0
        result += "WRONG! off by #{earndiff}\n"
        a.total_earned = totalearned
        a.save!
      end
      result += "#{a.total_paid}"
      paidiff = totalpaid - a.total_paid 
      if paidiff != 0
        result += "WRONG! off by #{paidiff}\n"
        a.total_paid = totalpaid
        a.save!
      end
    end

    render :text => result 
  end

end



