---
name: luals-server-dev
description: 'Project skill for developing the lua-language-server server codebase. Use when modifying parser, LuaCats, node runtime, VM/coder, tracer narrowing, language-server/LSP handlers, completion providers, workspace scope, configuration, or tests. Includes project architecture, module map, code style, debugging workflow, and validation commands.'
argument-hint: 'Describe the subsystem or feature you are changing, for example: parser syntax, tracer narrowing, completion provider, or LSP request handling.'
---

# LuaLS Server Development

Use this skill for work inside the server repository when you need project-specific guidance instead of generic Lua advice.

## When To Use
- Add or change parser and AST behavior.
- Add or change Node runtime types or type inference.
- Debug VM coder output, tracer narrowing, or flow issues.
- Implement or adjust LSP features under language-server or feature.
- Add or migrate tests under test/parser, test/node, test/coder, or test/feature.
- Check repository-specific style, safety rules, and validation commands before editing.

## Repository Entry Points
- Process startup: `main.lua` -> `script/luals.lua` -> `script/master.lua` -> `script/language-server/language-server.lua`.
- Test startup: `main.lua` with `ls.args.TEST` -> `test.lua`.
- Global bootstrap object: `ls` from `script/luals.lua`.

## Development Rules
- Run tests from the server root with `bin\\lua-language-server.exe --test <suite-or-file>`.
- Do not run the `PreCompile` or `Compile` tasks for normal feature work.
- Keep changes small and focused; avoid unrelated refactors and formatting sweeps.
- Put temporary diagnostics in `tmp/` only.
- Prefer the narrowing path in `script/node/tracer.lua`; do not add new narrowing behavior to legacy flow code under `script/vm/coder/flow.lua` or `script/vm/coder/branch.lua`.
- When tracer reports `No such key`, inspect generated middle code and flow artifacts before adding defensive access.

## Procedure
1. Identify the subsystem you are touching using [architecture](./references/architecture.md).
2. Check file ownership and extension points in [module map](./references/module-map.md).
3. Follow project conventions in [workflow and style](./references/workflow-and-style.md).
4. Make the smallest change that matches the subsystem boundary.
5. Run the narrowest relevant test suite from [workflow and style](./references/workflow-and-style.md).

## Fast Routing
- Parser or syntax work: start with [architecture](./references/architecture.md) and `script/parser/`.
- Type nodes or runtime work: start with [module map](./references/module-map.md) and `script/node/`.
- VM, coder, tracing, or flow work: start with [module map](./references/module-map.md) and `script/vm/`.
- LSP request handling: inspect `script/language-server/` and `script/feature/`.
- Completion work: inspect `script/feature/completion/`, `script/feature/text-scanner.lua`, and completion tests.
- Test additions or regressions: start with [workflow and style](./references/workflow-and-style.md) and `test/`.

## High-Value Triggers
- "modify parser"
- "add LuaCats syntax"
- "add node type"
- "debug tracer narrowing"
- "inspect middle code"
- "fix completion provider"
- "implement LSP feature"
- "add feature test"
- "understand repository architecture"
