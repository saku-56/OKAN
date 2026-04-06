# CLAUDE.md

Claude Code がこのリポジトリで作業する際のルールをまとめたファイルです。

## GitHub Issue・PR 作成ルール

Issue と PR を作成する際は必ずテンプレートを使用してください。

### タイトルの命名規則

`【種別】タイトル` の形式を使用してください。

| 種別 | 用途 |
|------|------|
| `【bugfix】` | バグ修正 |
| `【feature】` | 機能追加 |
| `【chore】` | その他の作業（設定、ドキュメントなど） |

### Issue

`--template` と `--body` は併用不可のため、テンプレートの構造を `--body` に直接記述してください。

**バグ修正テンプレート構造** (`.github/ISSUE_TEMPLATE/バグ修正用テンプレート.md`):
```
### 概要
### 現状
### 実施内容
### 補足
```

**機能追加テンプレート構造** (`.github/ISSUE_TEMPLATE/機能追加用テンプレート.md`):
```
### 実装内容
### 実装項目
### 確認事項
### 補足
```

### PR

- `gh pr create --body-file .github/pull_request_template.md`
