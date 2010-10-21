require 'spec_helper'
require 'cancan/matchers'

describe Group do
  describe 'attributes' do
    before(:each) do
      @p = people(:quentin)
      @p2 = people(:aaron)
      @valid_attributes = {
        :name => "value for name",
        :description => "value for description",
        :mode => 1,
        :unit => "value for unit",
        :owner => @p,
        :adhoc_currency => false
      }
    end

    it "should create a new instance given valid attributes" do
      Group.create!(@valid_attributes)
    end

    it "should not be able to update someone else's group" do
      g = Group.create!(@valid_attributes)
      ability = Ability.new(@p2)
      ability.should_not be_able_to(:update,g)
    end

    it "should be able to update own group" do
      g = Group.create!(@valid_attributes)
      ability = Ability.new(@p)
      ability.should be_able_to(:update,g)
    end
  end
end
