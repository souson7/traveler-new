class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following_user, through: :follower, source: :followed
  has_many :follower_user, through: :followed, source: :follower
  has_many :user_rooms, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :rooms, through: :user_rooms

  attachment :profile_image

  #　ユーザーをフォローする
  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  #　ユーザーのフォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  #　フォローしていなければtrueを返す
  def following?(user)
    following_user.include?(user)
  end

  def get_profile_image(width, height)
    if profile_image_id.present?
      profile_image
    else
      "no_image_svg"
    end
  end
  
  validates :name, presence: true
  
end
