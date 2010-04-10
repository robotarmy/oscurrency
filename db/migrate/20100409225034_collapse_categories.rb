class CollapseCategories < ActiveRecord::Migration

  class Category  < ActiveRecord::Base
    has_and_belongs_to_many :people
    has_and_belongs_to_many :offers
    has_and_belongs_to_many :reqs

    def self.cc(f_id, t_id)
      Category.find(t_id).collapse(Category.find(f_id))
    end

    def collapse(othercat)
      p "Collapsing #{othercat.name} to #{self.name}"
      othercat.people { |p| p.categories.remove(othercat).push(self) }
      othercat.offers { |p| p.categories.remove(othercat).push(self) }
      othercat.reqs { |p| p.categories.remove(othercat).push(self) }
      othercat.destroy
    end

  end

  class Person < ActiveRecord::Base
    has_and_belongs_to_many :categories
  end
  class Offer < ActiveRecord::Base
    has_and_belongs_to_many :categories
  end
  class Req < ActiveRecord::Base
    has_and_belongs_to_many :categories
  end

  def self.up
    Category.cc(12,13)
    Category.cc(15,10)
    Category.cc(62,90)
    Category.cc(69,1)
    Category.cc(70,3)
    Category.cc(83,5)
    Category.cc(4,11)
    Category.cc(14,11)
    Category.cc(61,11)
    Category.cc(16,19)
    Category.cc(87,90)
    Category.cc(89,90)
    Category.cc(6,10)
    Category.cc(40,23)
    Category.cc(35,17)
    Category.cc(59,22)
    Category.cc(80,22)
    Category.cc(43,11)
  end

  def self.down
    error IrreversibleMigration
  end
end
