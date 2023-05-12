# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user
    can %i[confirmed index_supplier canceled], Transfer
    can :show, House
    # can :index, House
    can %i[create_front ical], Booking
    # can :about, Page
    if user.role? :owner
      can :index, [Transaction]
      can :index_front, [Booking]
      can :index, [Admin]
      can :index, TransactionFile, show: true
    end
    if user.role? 'Transfer'
      can :read, Transfer
      can :index, [Admin]
    end
    if user.role? 'Maid'
      can %i[laundry update_laundry], Job
      can :index, [Admin]
    end
    if user.role? 'Gardener'
      can %i[index create update], WaterUsage
      can :index, [Admin]
    end
    if user.role? 'Accounting'
      can :reimbersment, :document
      can :statement, :document
      can %i[index new create update_invoice_ref], Transaction
      can [:edit, :update], Transaction do |t|
        t.date >= (Date.today - 30.days).beginning_of_month
      end
      can [:destroy], Transaction do |t|
        t.date > Date.today - 1.day
      end
      can [:laundry], Job
      can %i[timeline timeline_data], Booking
      can :index, [Admin]
    end
    if user.role? 'Guest relation'
      can :manage, Job
      can [:destroy], Job, creator: user
      can :index, Transfer
      can %i[timeline timeline_data check_in_out update_comment_gr], Booking
      can :index, [Admin]
    end
    if user.role? :manager
      can %i[index show], User, roles: { name: %w[Owner Tenant] }
      can [:new], User
      can %i[create edit update], User, roles: { name: %w[Owner Tenant] }
      cannot :destroy, User
      can :manage, [HouseType, House, Duration, Season, Price,
                    Booking, Connection, JobType, Transfer, Source,
                    Option, HouseOption, Location, HousePhoto,
                    BookingFile, HouseGroup, TransactionFile]
      cannot :destroy, [HouseType, House, Booking, JobType, Transfer, TransactionFile]
      can %i[index new show create edit update laundry update_laundry], Job
      can [:destroy], Job, creator: user
      can :manage, JobMessage, sender: user
      can :index, [Admin]
      can %i[index new create update_invoice_ref docs], Transaction
      can [:edit, :update], Transaction do |t|
        t.date >= (Date.today - 30.days).beginning_of_month
      end
      can [:destroy], Transaction do |t|
        t.date > Date.today - 1.day
      end
      can :manage, TransactionFile
      # can [ :statement, :reimbersment ], Document
      can %i[index create update], WaterUsage
    end
    if user.role? :admin
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
