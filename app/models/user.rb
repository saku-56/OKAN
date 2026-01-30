class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  validates :name, presence: true, length: { maximum: 20 }
  validates :uuid, uniqueness: true

  has_many :user_medicines, dependent: :destroy
  has_many :medicines, dependent: :destroy
  has_many :hospitals, dependent: :destroy
  has_many :consultation_schedules, dependent: :destroy

  # URLでuuidを使用するための設定
  def to_param
    uuid
  end

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
    end
  end
end
