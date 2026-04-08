# Module Map

## Parser
- `script/parser/compile.lua`: public parser entry, builds `LuaParser.Ast` and resolves goto/const checks.
- `script/parser/ast/`: AST node definitions.
- `script/parser/ast/cats/`: LuaCats-specific parsing and node forms.

Use for:
- New syntax support.
- LuaCats annotation syntax.
- Parser error recovery or name/token rules.

## Node Runtime
- `script/node/init.lua`: loads all node kinds and runtime helpers.
- Representative kinds include alias, class, union, intersection, function, variable, field, narrow, tracer.

Rules:
- Register new node modules in `script/node/init.lua`.
- Prefer public Node APIs such as `findValue`, `each`, and variable child accessors.
- Do not re-scan raw LuaDoc text inside feature code when runtime type information already exists.

## VM And Coder
- `script/vm/init.lua`: loads VM core pieces.
- `script/vm/virtual_file.lua`: file-level semantic container.
- `script/vm/coder/`: AST to middle-code translation, flow metadata, and execution support.

Rules:
- Treat middle-code generation and flow metadata as the source of truth for tracer debugging.
- Do not add new narrowing behavior to legacy `flow.lua` or `branch.lua`.

## Language Features
- `script/feature/`: high-level language features.
- `script/feature/completion/init.lua`: loads completion providers.
- Completion providers currently include luacats, word, field, string, postfix, and text.
- `script/feature/text-scanner.lua`: cursor-context scanning for completion.

Use for:
- Completion routing and provider behavior.
- Definition/hover/reference-style feature logic.
- Feature-specific helpers that sit above VM/Node.

## Language Server
- `script/language-server/language-server.lua`: lifecycle, transport loop, request resolution.
- `script/language-server/language-client.lua`: client capability handling.

Use for:
- Request lifecycle.
- Capability negotiation.
- Transport-specific behavior.

## Tests
- `test.lua`: test bootstrap and filter support.
- `test/parser/`: parser coverage.
- `test/node/`: node runtime coverage.
- `test/coder/`: coder and flow coverage.
- `test/feature/`: end-user feature behavior.
- `test/feature/completion/init.lua`: completion test harness and provider imports.

Use for:
- Keeping tests close to the subsystem you changed.
- Reusing helpers like `TEST_COMPLETION` rather than building ad hoc assertions.
