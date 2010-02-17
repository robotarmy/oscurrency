class PersonMailer < ActionMailer::Base
  extend PreferencesHelper
  
  def domain
    @domain ||= PersonMailer.global_prefs.domain
  end
  
  def server
    @server_name ||= PersonMailer.global_prefs.server_name
  end
  
  def password_reset(person)
    from         "Password reset <password-reset@#{domain}>"
    recipients   person.email
    subject      formatted_subject("Password reset")
    body         "domain" => server, "person" => person
    content_type "text/html"
  end
  
  def message_notification(message)
    from         "#{message.sender.name} <message@#{domain}>"
    recipients   message.recipient.email
    subject      formatted_subject(message.subject)
    content_type "text/html"
    body         "domain" => server, "message" => message,
                 "preferences_note" => preferences_note(message.recipient)
  end
  
  def connection_request(connection)
    from         "#{connection.contact..name} <connection@#{domain}>"
    recipients   connection.person.email
    subject      formatted_subject("New contact request")
    body         "domain" => server,
                 "connection" => connection,
                 "url" => edit_connection_path(connection),
                 "preferences_note" => preferences_note(connection.person)
  end
  
  def membership_public_group(membership)
    from         "#{membership.group.name} <membership@#{domain}>"
    recipients   membership.group.owner.email
    subject      formatted_subject("#{membership.person.name} joined group #{membership.group.name}")
    body         "domain" => server,
                 "membership" => membership,
                 "url" => members_group_path(membership.group),
                 "preferences_note" => preferences_note(membership.group.owner)
  end
  
  def membership_request(membership)
    from         "#{membership.group.name} <membership@#{domain}>"
    recipients   membership.group.owner.email
    subject      formatted_subject("#{membership.person.name} wants to join group #{membership.group.name}")
    body         "domain" => server,
                 "membership" => membership,
                 "url" => members_group_path(membership.group),
                 "preferences_note" => preferences_note(membership.group.owner)
  end
  
  def membership_accepted(membership)
    from         "#{membership.group.name} <membership@#{domain}>"
    recipients   membership.person.email
    subject      formatted_subject("You have been accepted to join #{membership.group.name}")
    body         "domain" => server,
                 "membership" => membership,
                 "url" => group_path(membership.group),
                 "preferences_note" => preferences_note(membership.person)
  end
  
  def invitation_notification(membership)
    from         "#{membership.group.name} <invitation#{domain}>"
    recipients   membership.person.email
    subject      formatted_subject("Invitation from group #{membership.group.name}")
    body         "domain" => server,
                 "membership" => membership,
                 "url" => edit_membership_path(membership),
                 "preferences_note" => preferences_note(membership.person)
  end
  
  def invitation_accepted(membership)
    from         "#{membership.group.name} <invitation@#{domain}>"
    recipients   membership.group.owner.email
    subject      formatted_subject("#{membership.person.name} accepted the invitation")
    body         "domain" => server,
                 "membership" => membership,
                 "url" => members_group_path(membership.group),
                 "preferences_note" => preferences_note(membership.group.owner)
  end
  
  def blog_comment_notification(comment)
    from         "Blog <comment@#{domain}>"
    recipients   comment.commented_person.email
    subject      formatted_subject("New blog comment")
    body         "domain" => server, "comment" => comment,
                 "url" => 
                 blog_post_path(comment.commentable.blog, comment.commentable),
                 "preferences_note" => 
                    preferences_note(comment.commented_person)
  end
  
  def wall_comment_notification(comment)
    from         "Wall <comment@#{domain}>"
    recipients   comment.commented_person.email
    subject      formatted_subject("New wall comment")
    body         "domain" => server, "comment" => comment,
                 "url" => person_path(comment.commentable, :anchor => "wall"),
                 "preferences_note" => 
                    preferences_note(comment.commented_person)
  end
 
  def forum_post_notification(subscriber, forum_post)
    from         "#{forum_post.person.name} <forum@#{domain}>"
    recipients   subscriber.email
    subject      formatted_group_subject(forum_post.topic.forum.group, forum_post.topic.name)
    content_type "text/html"
    body         "domain" => server, "forum_post" => forum_post,
                 "preferences_note" => 
                    preferences_note(subscriber)
  end

  def email_verification(ev)
    from         "Email verification <email@#{domain}>"
    recipients   ev.person.email
    subject      formatted_subject("Email verification")
    body         "server_name" => server,
                 "code" => ev.code
  end

  def registration_notification(new_peep)
    from         "Registration notification <registration@#{domain}>"
    recipients   PersonMailer.global_prefs.new_member_notification.split
    subject      formatted_subject("New registration")
    body         "email" => new_peep.email,
                  "name" => new_peep.name,
                  "domain" => server,
                 "url" => person_path(new_peep)
  end

  def req_notification(req, recipient)
    from         "#{req.person.name} <request@#{domain}>"
    recipients   recipient.email
    subject      formatted_subject("#{req.name} request")
    body         "name" => req.name,
                 "description" => req.description,
                 "domain" => server,
                 "requestor" => req.person.name,
                 "url" => req_path(req)
  end

  def offer_notification(offer, recipient)
    from         "#{offer.person.name} <offer@#{domain}>"
    recipients   recipient.email
    subject      formatted_subject("#{offer.name} offered")
    body         "name" => offer.name,
                 "description" => offer.description,
                 "domain" => server,
                 "offerer" => offer.person.name,
                 "url" => offer_path(offer)
  end
  
  private
  
    # Prepend the application name to subjects if present in preferences.
    def formatted_subject(text)
      name = PersonMailer.global_prefs.app_name
      label = name.blank? ? "" : "[#{name}] "
      "#{label}#{text}"
    end

    def formatted_group_subject(group,text)
      if !group
        formatted_subject(text)
      else
        "[#{group.name}] #{text}"
      end
    end
  
    def preferences_note(person)
      %(To change your email notification preferences, visit
      
http://#{server}/people/#{person.to_param}/edit)
    end
end
