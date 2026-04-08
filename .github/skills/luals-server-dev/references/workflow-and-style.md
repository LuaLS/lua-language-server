# Workflow And Style

## Validation Commands
Run from the server root.

```powershell
bin\lua-language-server.exe --test
bin\lua-language-server.exe --test parser
bin\lua-language-server.exe --test node
bin\lua-language-server.exe --test coder
bin\lua-language-server.exe --test feature.completion
bin\lua-language-server.exe --test feature.completion.field
```

## Test Workflow
- Prefer the narrowest relevant suite first, then expand only if needed.
- For parser work, add tests under `test/parser/`.
- For node or tracer work, add tests under `test/node/` or `test/coder/` depending on ownership.
- For LSP-facing behavior, add tests under `test/feature/`.
- Completion tests use the local harness in `test/feature/completion/init.lua`; remember that `TEST_COMPLETION` runs in a bare environment.

## Debugging Workflow
- For tracer or flow failures, inspect `tmp/LAST_CODE`, `tmp/LAST_FLOW`, and `tmp/LAST_PMAP` after a failing test.
- If `self.map` reports `No such key`, investigate read-before-write ordering in coder output instead of bypassing the map.
- Keep temporary logs and diagnostic artifacts in `tmp/` only.
- If using a debugger, stop any existing session before starting another one, and disconnect when done.

## Style Expectations
- Lua files use spaces with width 4.
- Keep line length near the repository limit of 120.
- Preserve existing alignment style, especially for assignments, parameter lists, and `if` branches.
- Project-specific multi-condition `if` formatting is intentionally aligned, for example:

```lua
if  condA
and condB
and condC then
    ...
end
```

- Follow existing class patterns from `script/class.lua`, including `Class` and `New` usage.
- Avoid broad formatting-only edits.

## Practical Constraints
- Do not run the `PreCompile` or `Compile` tasks for routine feature work.
- Worker-thread boundaries only accept serializable plain data.
- Completion-related logic should prefer VM/Node-derived type information over raw text rescans.
- Keep changes focused and local to the owning subsystem.
