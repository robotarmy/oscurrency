# == Schema Information
# Schema version: 20090216032013
#
# Table name: broadcast_emails
#
#  id         :integer(4)      not null, primary key
#  subject    :string(255)     
#  message    :text            
#  created_at :datetime        
#  updated_at :datetime        
#

class BroadcastEmail < ActiveRecord::Base

  def broadcast_sender
    Person.find_by_email("notes@#{Req.global_prefs.domain}") ||
      Person.create(:email => "notes@#{Req.global_prefs.domain}",
                    :name => "Time Exchange Notes",
                    :password => "ughfoo",
                    :password_confirmation => "ughfoo",
                    :accept_agreement => true
                    ).save!
  end

  def perform
    sender = broadcast_sender
    peeps = Person.all_active
    peeps.each do |peep|
      logger.info("BroadcaseEmail: sending email to #{peep.id}: #{peep.name}")
#      email = BroadcastMailer.create_spew(peep, subject, message)
#      email.set_content_type("text/html")
#      BroadcastMailer.deliver(email)
      Message.build(:recipient => peep, :subject => subject, :content => message)

    end
  end

end
