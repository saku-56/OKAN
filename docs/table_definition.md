# テーブル定義書

## Users テーブル

### 概要
ユーザー情報を管理するテーブル

### カラム定義
| カラム名 | 型 | NULL | デフォルト | 制約 | 説明 |
|---------|-----|------|-----------|------|------|
| id | bigint | NO | - | PRIMARY KEY | ユーザーID |
| email | string | NO | ' ' | UNIQUE | メールアドレス |
| encrypted_password | string | NO | ' ' | - | 暗号化されたパスワード |
| uuid | uuid | NO | - | UNIQUE | UUID |
| provider | string | YES | - | - | OAuth プロバイダー名 |
| uid | string | YES | - | - | OAuth UID |
| line_user_id | string | YES | - | UNIQUE | LINE ユーザーID |
| reset_password_token | string | YES | - | - | パスワードリセットトークン |
| reset_password_sent_at | datetime | YES | - | - | トークン送信日時 |
| remember_created_at | datetime | YES | - | - | ログイン記憶日時 |
| created_at | timestamp | NO | - | - | 作成日時 |
| updated_at | timestamp | NO | - | - | 更新日時 |

### リレーション
- has_many :user_medicines
- has_many :medicines
- has_many :user_medicines
- has_many :hospitals
- has_many :consultation_schedules
- has_many :notifications

### 補足
- providerはgoogle_omniauth2かlineを使用
- uuidはURLにidの代わりに表示するために使用

---

## Medicines テーブル

### 概要
薬名を管理するテーブル

### カラム定義
| カラム名 | 型 | NULL | デフォルト | 制約 | 説明 |
|---------|-----|------|-----------|------|------|
| id | bigint | NO | - | PRIMARY KEY | 薬名ID |
| user_id | bigint | NO | - | FOREIGN KEY | ユーザーID |
| name | string | NO | - | - | 薬名 |
| created_at | timestamp | NO | - | - | 作成日時 |
| updated_at | timestamp | NO | - | - | 更新日時 |

### インデックス
| カラム | タイプ | 説明 |
|--------|--------|------|
| user_id, name | UNIQUE | 同一ユーザーが同じ名前の薬を重複登録できないように、複合ユニーク制約を設定 |

### リレーション
- belongs_to :user
- has_one :user_medicine

## UserMedicines テーブル

### 概要
服薬情報テーブル

### カラム定義
| カラム名 | 型 | NULL | デフォルト | 制約 | 説明 |
|---------|-----|------|-----------|------|------|
| id | bigint | NO | - | PRIMARY KEY | 服薬情報ID |
| user_id | bigint | NO | - | - | ユーザーID |
| medicine_id | bigint | NO | - | - | 薬名ID |
| dosage_per_time | integer | NO | - | - | 1回あたりの服用量 |
| times_per_day | integer | NO | 1 | - | 1日あたりの服用回数 |
| prescribed_amount | integer | NO | - | - | 処方された総量 |
| current_stock | integer | NO | 0 | - | 現在の在庫量 |
| date_of_prescription | date | NO | - | - | 処方日 |
| uuid | uuid | NO | - | UNIQUE | UUID |
| created_at | timestamp | NO | - | - | 作成日時 |
| updated_at | timestamp | NO | - | - | 更新日時 |

### インデックス
| カラム | タイプ | 説明 |
|--------|--------|------|
| user_id, medicine_id | UNIQUE | 同一ユーザーが同じ薬を重複して登録できないように、複合ユニーク制約を設定 |

### リレーション
- belongs_to :user
- belongs_to :medicine

### 補足
- uuidはURLにidの代わりに表示するために使用

---

## Hospitals テーブル

### 概要
ユーザーが登録する病院情報を保存するテーブル

### カラム定義
| カラム名 | 型 | NULL | デフォルト | 制約 | 説明 |
|---------|-----|------|-----------|------|------|
| id | bigint | NO | - | PRIMARY KEY | 病院ID |
| user_id | bigint | NO | - | - | ユーザーID |
| name | string | NO | - | - | 病院名 |
| description | text | YES | - | - | メモ |
| uuid | uuid | NO | - | UNIQUE | UUID |
| created_at | timestamp | NO | - | - | 作成日時 |
| updated_at | timestamp | NO | - | - | 更新日時 |

### インデックス
| カラム | タイプ | 説明 |
|--------|--------|------|
| user_id, name | UNIQUE | 同一ユーザーが同じ名前の病院を重複登録できないように、複合ユニーク制約を設定 |

### リレーション
- belongs_to :user
- has_many :hospital_schedules
- has_many :consultation_schedules

### 補足
- uuidはURLにidの代わりに表示するために使用

---

## HospitalSchedules テーブル

### 概要
病院の診療時間を管理するテーブル

### カラム定義
| カラム名 | 型 | NULL | デフォルト | 制約 | 説明 |
|---------|-----|------|-----------|------|------|
| id | bigint | NO | - | PRIMARY KEY | 診療時間ID |
| hospital_id | bigint | NO | - | - | 病院ID |
| day_of_week | integer | NO | - | - | 曜日（0=月, 1=火, 2=水, 3=木, 4=金, 5=土, 6=日, 7=祝） |
| period | integer | NO | - | - | 時間帯（0=午前, 1=午後） |
| start_time | time | YES | - | - | 診療開始時刻 |
| end_time | time | YES | - | - | 診療終了時刻 |
| created_at | timestamp | NO | - | - | 作成日時 |
| updated_at | timestamp | NO | - | - | 更新日時 |

### リレーション
- belongs_to :hospital

### 補足
- day_of_week と period は enum で管理されます
- 病院ごとに曜日と時間帯を組み合わせて診療時間を設定できます

---

## ConsultationSchedules テーブル

### 概要
ユーザーの通院予定を管理するテーブル

### カラム定義
| カラム名 | 型 | NULL | デフォルト | 制約 | 説明 |
|---------|-----|------|-----------|------|------|
| id | bigint | NO | - | PRIMARY KEY | 通院予定ID |
| user_id | bigint | NO | - | - | ユーザーID |
| hospital_id | bigint | NO | - | - | 病院ID |
| visit_date | date | NO | - | - | 通院予定日 |
| created_at | timestamp | NO | - | - | 作成日時 |
| updated_at | timestamp | NO | - | - | 更新日時 |

### リレーション
- belongs_to :user
- belongs_to :hospital

---

## Notifications テーブル

### 概要
ユーザーの通知設定を管理するテーブル

### カラム定義
| カラム名 | 型 | NULL | デフォルト | 制約 | 説明 |
|---------|-----|------|-----------|------|------|
| id | bigint | NO | - | PRIMARY KEY | 通知ID |
| user_id | bigint | NO | - | - | ユーザーID |
| notification_type | string | NO | - | - | 通知タイプ(medicine_stock, consultation_reminder) |
| enable | boolean | NO | false | - | 通知の有効/無効 |
| days_before | integer | NO | 1 | - | 何日前に通知するか |
| created_at | timestamp | NO | - | - | 作成日時 |
| updated_at | timestamp | NO | - | - | 更新日時 |

### インデックス
| カラム | タイプ | 説明 |
|--------|--------|------|
| user_id, notification_type | UNIQUE | 同一ユーザーが同じ通知タイプを重複して登録できないように複合ユニーク制約を設定 |

### リレーション
- belongs_to :user

### 補足
- notification_type は文字列の enum で管理されます
- 各ユーザーは通知タイプごとに1つの設定のみ保持できます
- days_before で通知のタイミングを設定できます