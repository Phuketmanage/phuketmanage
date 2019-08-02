# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new                          # guest user
    can [:confirmed, :index_supplier, :canceled], Transfer
    if user.role? :owner
      # can :read, [ House ]
    elsif user.role? 'Transfer'
      can :read, Transfer
    elsif user.role? 'Maid'
      can :read, Job
    elsif user.role? 'Guest relation'
      can :manage, Job
      cannot :destroy, Job
      can :index, Transfer
      can :check_in_out, Booking
    elsif user.role? :manager
      can [:index, :show], User, roles: { name: ['Owner', 'Tenant'] }
      can [:new ], User
      can [:create, :edit, :update], User, roles: { name: ['Owner', 'Tenant'] }
      cannot :destroy, User
      can :manage, [  HouseType, House, Duration, Season, Price, Booking,
                      Connection, JobType, Transfer ]
      cannot :destroy, [ HouseType, House, Booking, JobType, Transfer ]
      can [:index, :new, :create, :edit, :update], Job
      can [:destroy], Job, creator: user
    elsif user.role? :admin
      can :manage, :all
      # # manage products, assets he owns
      # can :manage, Product do | product |
      #   product.try( :owner ) == user
      # end
      # can :manage, Asset do | asset |
      #   asset.assetable.try( :owner ) == user
      # end
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
