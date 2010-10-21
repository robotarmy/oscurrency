class Ability
  include CanCan::Ability
  def initialize(person)
    can :read, Group
    can :create, Group
    can :update, Group, :owner => person
    can :destroy, Group, :owner => person
  end
end
