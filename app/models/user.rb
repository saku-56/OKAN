class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :uuid, uniqueness: true

  has_many :user_medicines, dependent: :destroy

  # URLでuuidを使用するための設定
  def to_param
    uuid
  end
end
