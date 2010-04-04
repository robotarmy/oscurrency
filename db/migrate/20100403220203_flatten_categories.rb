class FlattenCategories < ActiveRecord::Migration

  # temp classes
  class Category  < ActiveRecord::Base
    acts_as_tree

    def root
      if parent
        parent.root
      else
        self
      end
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
    Person.find(:all).each { |p| p.categories = p.categories.map(&:root).uniq }
    Offer.find(:all).each { |p| p.categories = p.categories.map(&:root).uniq }
    Req.find(:all).each { |p| p.categories = p.categories.map(&:root).uniq }
    Category.find(:all).each { |c| if c.parent != nil then c.destroy end }
    remove_column :categories, :parent_id
  end

  def self.down
    add_column :categories, :parent_id, :integer
  end
end
