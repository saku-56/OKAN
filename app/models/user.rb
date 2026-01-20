class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }
  validates :uuid, uniqueness: true

  has_many :user_medicines, dependent: :destroy
  has_many :medicines, dependent: :destroy

  # URLでuuidを使用するための設定
  def to_param
    uuid
  end
end
