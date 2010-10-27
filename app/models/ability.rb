class Ability
  include CanCan::Ability
  def initialize(person)
    can :read, Group
    can :create, Group
    can [:update, :destroy], Group, :owner => person
    can :update, Group do |group|
      membership = Membership.mem(person,group)
      membership && membership.is?(:admin)
    end
    can :members, Group
    can [:new_photo, :save_photo, :delete_photo], Group, :owner => person

    can :read, Exchange
    can :destroy, Exchange, :customer => person

    can :create, Exchange do |exchange|
      unless exchange.group
        true
      else
        membership = Membership.mem(person,exchange.group)
        unless membership
          false
        else
          if membership.is?(:org)
            true # unconditional trust
          else
            account = Account.find_by_person_id_and_group_id(person, exchange.group)
            account && (exchange.amount <= account.balance)
          end
        end
      end
    end
  end
end
