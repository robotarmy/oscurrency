class Email < ActiveRecord::Base

  belongs_to :from, :class_name => :user
  belongs_to :to, :class_name => :user
  
  validates_presence_of :to

  def self.queue(tmail, from, to)
    self.create(:from => from, # tmail.from[0],
                :to => to, # tmail.to[0],
                :subject => tmail.subject,
                :body => tmail.body)
  end


  def perform
    actually_send
  end

  private
  
  def send
    # ...
  end

end
