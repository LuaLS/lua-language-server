mode: `'index_common' | 'index_meta' | 'full'`

* process(vfile, ast, mode)
  * field -> runner(vfile, mode, context, hook)
    * runner:parseNode(source)
      * hook: `fun(source, node)`
* context
  * field -> variables: `table<source, node>`

```lua
local runner = vm.createRunner(vfile, context, function (source, node)
    if source.kind == 'catfield' then
        self:pushResult { ... }
    end
end)
runner:parseNode(block)
```
