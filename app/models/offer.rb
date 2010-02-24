class Offer < ActiveRecord::Base
  include ActivityLogger
  extend PreferencesHelper 

  index do 
    name
    description
  end

  has_and_belongs_to_many :categories
  has_many :exchanges, :as => :metadata
  belongs_to :person
  attr_protected :person_id, :created_at, :updated_at
  validates_presence_of :name
  after_create :notify_workers, :if => :notifications
  after_create :log_activity

  class << self

    def current(page=1)
      today = DateTime.now
      Offer.paginate(:all, :page => page, :conditions => ["available_count > ? AND (expiration_date >= ? OR expiration_date is null)", 0, today], :order => 'created_at DESC')
    end
  end

  def can_destroy?
    self.exchanges.length == 0
  end

  def log_activity
    add_activities(:item => self, :person => self.person)
  end

  def formatted_categories
    #i'm told that this is stupid, and it'd be better to go:
    #categories.collect{|cat| cat.long_name}.join("<br />")
    # but i haven't tested it
    categories.collect {|cat| cat.long_name + "<br />"}.to_s.chop.chop.chop.chop
  end

  private

  def validate
    if self.categories.length > 5
      errors.add_to_base('Only 5 categories are allowed per offer')
    end
  end

  def notify_workers
    workers = []
    # even though pseudo-offers created by direct payments do not have associated categories, let's
    # be extra cautious and check for the active property as well
    #
    if self.active? && Offer.global_prefs.can_send_email? && Offer.global_prefs.email_notifications?
      self.categories.each do |category|
        workers << category.people
      end

      workers.flatten!
      workers.uniq!
      workers.each do |worker|
        if worker.active?
          PersonMailer.deliver_offer_notification(self, worker) if worker.connection_notifications?
        end
      end
    end
  end
end
 
 
