class TempMessage < Message

  # a variant of Message to encapsulate an outgoing email for delivery; deleted after it's done.

  def self.queue(tmail, from, to)
    TempMessage.create(:sender => from, # tmail.from[0],
                       :recipient => to, # tmail.to[0],
                       :subject => tmail.subject,
                       :content => tmail.body)
  end

  private
  
  def assign_conversation
    # don't bother
  end

  def actually_send_receipt_reminder
    super
    destroy
  end

end
