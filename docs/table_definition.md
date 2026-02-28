# テーブル定義書

## Users テーブル

### 概要
ユーザー情報を管理するテーブル

### カラム定義
| カラム名 | 型 | NULL | デフォルト | 制約 | 説明 |
|---------|-----|------|-----------|------|------|
| id | integer | NO | - | PRIMARY KEY | ユーザーID |
| email | string | NO | - | UNIQUE | メールアドレス |
| encrypted_password | string | NO | - | - | 暗号化されたパスワード |
| uuid | uuid | NO | - | UNIQUE | UUID |
| provider | string | YES | - | - | OAuth プロバイダー名 |
| uid | string | YES | - | - | OAuth UID |
| line_user_id | string | YES | - | - | LINE ユーザーID |
| reset_password_token | string | YES | - | - | パスワードリセットトークン |
| reset_password_sent_at | datetime | YES | - | - | トークン送信日時 |
| remember_created_at | datetime | YES | - | - | ログイン記憶日時 |
| created_at | timestamp | NO | - | - | 作成日時 |
| updated_at | timestamp | NO | - | - | 更新日時 |

### インデックス
| カラム | タイプ | 説明 |
|--------|--------|------|
| email | UNIQUE | メールアドレスの重複を防ぐ |
| uuid | UNIQUE | UUID の重複を防ぐ |

### リレーション
- has_many :user_medicines
- has_many :user_medicines, through: :medicines
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
| id | integer | NO | - | PRIMARY KEY | 薬ID |
| user_id | integer | NO | - | FOREIGN KEY | ユーザーID |
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
| id | integer | NO | - | PRIMARY KEY | 服薬情報ID |
| user_id | integer | NO | - | - | ユーザーID |
| medicine_id | string | NO | - | - | 薬ID |
| dosage_per_time | integer | NO | - | - | 1回あたりの服用量 |
| times_per_day | integer | NO | - | - | 1日あたりの服用回数 |
| prescribed_amount | integer | NO | - | - | 処方された総量 |
| current_stock | integer | NO | - | - | 現在の在庫量 |
| date_of_prescription | date | NO | - | - | 処方日 |
| uuid | uuid | NO | - | UNIQUE | UUID |
| created_at | timestamp | NO | - | - | 作成日時 |
| updated_at | timestamp | NO | - | - | 更新日時 |

### インデックス
| カラム | タイプ | 説明 |
|--------|--------|------|
| user_id, medicine_id | UNIQUE | 同一ユーザーが同じ薬を重複して登録できないように複合ユニーク制約を設定 |

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
| id | integer | NO | - | PRIMARY KEY | 病院ID |
| user_id | integer | NO | - | - | ユーザーID |
| name | string | NO | - | - | 病院名 |
| description | text | YES | - | - | メモ |
| uuid | uuid | NO | - | UNIQUE | UUID |
| created_at | timestamp | NO | - | - | 作成日時 |
| updated_at | timestamp | NO | - | - | 更新日時 |

### インデックス
| カラム | タイプ | 説明 |
|--------|--------|------|
| user_id, name | UNIQUE | 同一ユーザーが同じ名前の病院を重複登録できないように複合ユニーク制約を設定 |

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
| id | integer | NO | - | PRIMARY KEY | 診療時間ID |
| hospital_id | integer | NO | - | - | 病院ID |
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
| id | integer | NO | - | PRIMARY KEY | 通院予定ID |
| user_id | integer | NO | - | - | ユーザーID |
| hospital_id | string | NO | - | - | 病院ID |
| visit_date | date | NO | - | - | 通院予定日 |
| created_at | timestamp | NO | - | - | 作成日時 |
| updated_at | timestamp | NO | - | - | 更新日時 |

### リレーション
- belongs_to :user
- belongs_to :hospital

---

## Notifications テーブル

