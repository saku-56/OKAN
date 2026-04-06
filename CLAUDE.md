# CLAUDE.md

Claude Code がこのリポジトリで作業する際のルールをまとめたファイルです。

## GitHub Issue・PR 作成ルール

Issue と PR を作成する際は必ずテンプレートを使用してください。

### Issue

- バグ修正: `gh issue create --template "バグ修正用テンプレート.md"`
- 機能追加: `gh issue create --template "機能追加用テンプレート.md"`

### PR

- `gh pr create --body-file .github/pull_request_template.md`
