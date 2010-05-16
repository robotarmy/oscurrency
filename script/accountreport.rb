#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../config/boot'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!( :default => '%m/%d/%Y', :date_time12  => "%m/%d/%Y %I:%M%p", :date_time24  => "%m/%d/%Y %H:%M")


file = File.new( "/tmp/report.html", "w" ) 
file.puts "<html><head><title>total account consistency check</title></head><body><table border='1'><tr><td>Person</td><td>Earned</td><td>Paid</td><td>Balance</td><td>Balance<br />Consistency<br />Flag</td><td>Listed<br />Earned</td><td>Earned<br />Consistency<br />Flag</td><td>Listed<br />Paid</td><td>Paid<br />Consistency<br />Flag</td></tr>" 
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
  file.puts "<tr><td><a href='http://localhost:3000/people/#{p.id}'>#{p.name}</a><br />since #{p.created_at}</td><td>#{totalearned}</td><td>#{totalpaid}</td><td>#{p.account.balance}</td><td>"
  calc=totalearned - totalpaid
  if  calc!= p.account.balance
    offby = calc - p.account.balance
    file.puts "WRONG!<br />S/B #{calc}<br /> off by #{offby}"
  else
    file.puts "&nbsp;"
  end
  file.puts "</td><td>#{p.account.total_earned}</td><td>"
  earndiff= totalearned - p.account.total_earned 
  if earndiff != 0
    file.puts "WRONG!<br />off by #{earndiff}"
  else
    file.puts "&nbsp;"
  end
  file.puts "</td><td>#{p.account.total_paid}</td><td>"
  paidiff = totalpaid - p.account.total_paid 
  if paidiff != 0
    file.puts "WRONG!<br />off by #{paidiff}"
  else
    file.puts "&nbsp;"
  end
  file.puts "</td></tr>" 
end  
file.puts "</table></body></html>" 
file.close;nil
