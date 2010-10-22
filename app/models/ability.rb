class Ability
  include CanCan::Ability
  def initialize(person)
    can :read, Group
    can :create, Group
    can [:update, :destroy], Group, :owner => person
    can [:new_photo, :save_photo, :delete_photo], Group, :owner => person
  end
end
