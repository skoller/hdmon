class Physician < ApplicationRecord

    # attr_writer :email, :password, :password_confirmation, :password_digest, :first_name, :last_name, :state, :specialty, :arch_id, :archive
    #     attr_reader :email, :password, :password_confirmation, :password_digest, :first_name, :last_name, :state, :specialty, :arch_id, :archive

    has_secure_password
    validates :email, presence: true, uniqueness: true

    # validates :password, presence: true

    # def initialize(attributes = {})
    #         @email = attributes[:email]
    #         @password  = attributes[:password]
    #         @password_confirmation  = attributes[:password_confirmation]
    #         @password_digest  = attributes[:password_digest]
    #         @first_name  = attributes[:first_name]
    #         @last_name  = attributes[:last_name]
    #         @state  = attributes[:state]
    #         @specialty  = attributes[:specialty]
    #         @arch_id  = attributes[:arch_id]
    #         @archive  = attributes[:archive]
    #     end

        # validates_presence_of :first_name, :last_name, :state, :specialty, :on => :update
        #                             # validates_presence_of :password, :on => :create
        #                             #                             validates_length_of :password, :minimum => 6, :allow_blank => false, :on => :create
        #                             #                             validates_confirmation_of :password, :on => :create
        #                             validates_presence_of :email, :on => :create
        #                             validates_uniqueness_of :email, :on => :create
        #                             validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

    has_many :patients
    accepts_nested_attributes_for :patients

    # validates_presence_of :password, :if => :should_validate_password?
    # validates_presence_of :country
    # validates_presence_of :state, :if => :in_us?
    # attr_accessor :updating_password

    # def in_us?
    #   country == 'US'
    # end

    # def should_validate_password?
    #   updating_password || new_record?
    # end

    # # in controller
    # @user.updating_password = true
    # @user.save


    def full_name
      self.first_name + " " + self.last_name
    end


end
