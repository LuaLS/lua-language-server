# Architecture

## Startup Flow
- `main.lua` sets GC behavior, loads `luals` and `master`, then either enters test mode through `test.lua` or starts the language server.
- `script/luals.lua` builds the global `ls` table, wires core tools, async/event-loop helpers, JSON modules, and inspection helpers.
- `script/master.lua` sets the master thread name, initializes runtime state, configures logging, and schedules periodic status reporting.
- `script/language-server/language-server.lua` creates the server object, starts transport, resolves tasks, and enforces server lifecycle states.

## Main Layers
- `script/parser/`: lexer, parser, AST creation. Put syntax and LuaCats parsing changes here.
- `script/node/`: semantic type node system and runtime helpers. New node modules must be loaded in `script/node/init.lua`.
- `script/vm/`: virtual file model, coder pipeline, contribution system, and type-execution machinery.
- `script/scope/`: workspace/document ownership, reload lifecycle, and scope-level services.
- `script/feature/`: user-facing language features such as completion, definition, and other LSP-backed behaviors.
- `script/language-server/`: LSP transport integration, client capability negotiation, request dispatch.
- `script/config/`: workspace and project configuration.
- `script/file/`, `script/filesystem/`, `script/runtime/`, `script/tools/`: supporting platform, runtime, and utility infrastructure.

## Data Flow
1. File content is tracked by scope and document management.
2. Parser compiles source into AST.
3. VM coder converts AST into middle code and flow metadata.
4. Runtime and tracer build semantic values and narrowing results.
5. Feature modules query the VM/Node model to answer LSP requests.

## Important Boundaries
- Parser changes should stay in parser/AST modules, not feature code.
- New semantic value kinds belong in `script/node/` and should use the public Node interfaces.
- Flow-sensitive reasoning should prefer `script/node/tracer.lua`.
- LSP protocol routing belongs in `script/language-server/`; feature behavior belongs in `script/feature/`.

## Core Entry Files
- `main.lua`
- `script/luals.lua`
- `script/master.lua`
- `script/language-server/language-server.lua`
- `script/parser/compile.lua`
- `script/node/init.lua`
- `script/vm/init.lua`
- `test.lua`
