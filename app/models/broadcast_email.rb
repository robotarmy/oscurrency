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

  def perform
    peeps = Person.all_active
    peeps.each do |peep|
      logger.info("BroadcaseEmail: sending email to #{peep.id}: #{peep.name}")
      Message.create(:recipient => peep, 
                     :sender => nil, # indicates from system
                     :subject => formatted_subject(subject), 
                     :content => message + preferences_note(recipient))
    end
  end

  # was in broadcase_mailer.rb
  # Prepend the application name to subjects if present in preferences.
  def formatted_subject(text)
    name = PersonMailer.global_prefs.app_name
    label = name.blank? ? "" : "[#{name}] "
    "#{label}#{text}"
  end

  # was in broadcase_mailer.rb
  def preferences_note(person)
    %(

To change your email notification preferences, visit
      
http://#{server}/people/#{person.to_param}/edit)
  end

end
