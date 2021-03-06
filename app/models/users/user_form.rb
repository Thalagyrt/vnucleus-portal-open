module Users
  class UserForm
    include ActiveModel::Model

    attr_accessor :password
    attr_reader :email

    validates :email, presence: true, email: true
    validates :password, presence: true, length: { minimum: 8 }

    validate :check_email_uniqueness

    def email=(value)
      @email = value.downcase
    end

    def user_params
      {
          email: email,
          password: password,
      }
    end

    private
    def check_email_uniqueness
      if Users::User.exists?(email: email)
        errors[:email] << 'already in use'
      end
    end
  end
end