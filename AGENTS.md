# Agent Working Notes (Single Entry)

This file is the single project-facing summary exported from previous AI progress.
It is intended for both human collaborators and coding agents.

## 1) Run and Test Rules

- Run tests from the `server` root with:
  - `bin\\lua-language-server.exe test.lua`
  - or `bin\\lua-language-server.exe --test <suite-or-file>`
- Do not run tasks `PreCompile` or `Compile` for feature work in this repo context.
- Keep changes focused. Avoid unrelated refactors and broad formatting-only edits.
- Put temporary debug outputs in `tmp/` only.

## 2) Where Changes Belong

- Parser / syntax:
  - `script/parser/ast/`
  - LuaCats: `script/parser/ast/cats/`
- Type node system:
  - `script/node/`
  - Register new nodes in `script/node/init.lua`
- VM / middle code:
  - `script/vm/coder/`
- Tests:
  - parser: `test/parser/`
  - node/tracer: `test/node/`
  - feature: `test/feature/`

## 3) Tracer and Narrowing Constraints

- Prefer the new narrowing path in `script/node/tracer.lua`.
- Do not add new narrowing features into legacy flow/branch code in:
  - `script/vm/coder/flow.lua`
  - `script/vm/coder/branch.lua`
- `self.map` in tracer is strict by design.
  - If you see `No such key`, do not bypass with `pcall` or `rawget`.
  - Check generated middle code and flow data first (`LAST_CODE`, `LAST_FLOW`).
  - If needed, inspect failed coder logs and verify read-before-write ordering of keys.

## 4) Worker/Thread Boundary Rules

Data crossing worker channels must be serializable plain data only:

- Allowed: string, number, boolean, and nested plain tables.
- Not allowed: functions, userdata, thread objects, complex objects with metamethod behavior.

## 5) Completion Feature Snapshot

Key files:

- `script/feature/completion.lua`
- `script/feature/text-scanner.lua`
- `test/feature/completion/`

Implemented providers:

- keyword
- local variable
- field access (`.` / `:`)
- global variable (with local shadow handling)

Known open points:

- `test/feature/completion/luadoc.lua` not implemented
- `test/feature/completion/string.lua` not implemented
- One known word-scan offset issue around `myfunc(fa<??>)` in completion tests

## 6) Migration Workflow for Completion Tests

- Migrate in small batches (up to 5 tests per step).
- After migration, remove moved tests from legacy common test file and leave an "already migrated" marker comment at the old location.
- Run completion tests after each migration batch before moving to the next batch.
- `TEST_COMPLETION` uses a bare environment. If a test needs stdlib symbols, define them inside the test snippet.
- If behavior is ambiguous, stop and confirm expected behavior before proceeding.

## 7) Completion Migration Scope Snapshot

- Already migrated:
  - keyword cases (`keyword.lua`)
  - word/local-global cases (`word.lua`)
  - field access cases (`field.lua`)
  - part of special cases (`special.lua`)
- Not implemented yet:
  - LuaDoc completion (`luadoc.lua`)
  - string enum completion (`string.lua`)
  - workspaceWord text completion, metatable `__index`, global stdlib table fields,
    special dotted field names, Chinese field names, function snippet insertText

## 8) Style Note

For multi-condition `if` blocks using `and/or`, keep project-consistent aligned layout.

---

Maintainer note:
If this file and runtime reality diverge, update this file first so the next agent run starts from accurate constraints.
