class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[line google_oauth2]
  validates :name, presence: true, length: { maximum: 20 }
  validates :uuid, uniqueness: true

  has_many :user_medicines, dependent: :destroy
  has_many :medicines, dependent: :destroy
  has_many :hospitals, dependent: :destroy
  has_many :consultation_schedules, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # ユーザー作成後に通知設定を自動作成
  after_create :create_default_notifications

  # URLでuuidを使用するための設定
  def to_param
    uuid
  end

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email || "#{auth.uid}@line.example.com"
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.line_user_id = auth.uid if auth.provider == "line"
    end
  end

  private

  def create_default_notifications
    # 薬の在庫通知を作成
    notifications.create!(
      notification_type: "medicine_stock",
      enabled: false,
      days_before: 5
    )

    # 通院予定通知を作成
    notifications.create!(
      notification_type: "consultation_reminder",
      enabled: false,
      days_before: 1
    )
  end
end
