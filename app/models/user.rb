class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise  :trackable, :omniauthable
  #:database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :uid, :provider, :password
  #attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"]
      end
    end
  end


  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name:auth.extra.raw_info.name,
                          provider:auth.provider,
                          uid:auth.uid,
                          # email:auth.info.email, #emailを取得したい場合は、migrationにemailを追加してください。
                          password:Devise.friendly_token[0,20]
                          )
    end
    user
  end


  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name:auth.info.nickname,
                          provider:auth.provider,
                          uid:auth.uid,
                          # email:auth.extra.user_hash.email, #色々頑張りましたがtwitterではemail取得できません
                          password:Devise.friendly_token[0,20]
                          )
    end
    user
  end
end
