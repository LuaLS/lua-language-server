# Contributing

## Pull Request Guidelines

- Commit messages are recommended to be written in English following a `type: description` format (e.g. `feat:`, `fix:`, `chore:`). This is only a suggestion, not a requirement — its only effect is being automatically counted in the contribution statistics when releasing a version.
- Changes that alter behavior must update `changelog.md` (enforced by CI).
- When a change touches both the server and the extension, commit them together in the same PR: update the `server` submodule pointer and the extension configuration (`package.json`, `package.nls*.json`, `setting/schema*.json`).
- Do not commit the `doc/` and `locale/` directories. For `locale/`, only commit your own language. Translations for the other languages will be completed by AI when the PR is created.
