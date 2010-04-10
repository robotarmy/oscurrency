class Neighborhood < ActiveRecord::Base
  has_and_belongs_to_many :people

  acts_as_tree

  def reqs
    Req.in_neighborhood(self)
  end

  def active_people
    active_people = self.people.find(:all, :conditions => Person.conditions_for_mostly_active)
  end


  def ancestors_name
    if parent
      parent.ancestors_name + parent.name + ':'
    else
      ""
    end
  end

  def long_name
    ancestors_name + name
  end
end
