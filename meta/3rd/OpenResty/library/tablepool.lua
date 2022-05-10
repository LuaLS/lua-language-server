---@meta
local tablepool = {}

--- Releases the already used Lua table, `tb`, into the table pool named `pool_name`. If the specified table pool does not exist, create it right away.
---
--- The caller must *not* continue using the released Lua table, `tb`, after this call. Otherwise random data corruption is expected.
---
--- The optional `no_clear` parameter specifies whether to clear the contents in the Lua table `tb` before putting it into the pool. Defaults to `false`, that is, always clearing the Lua table.
---
--- If you always initialize all the elements in the Lua table and always use the exactly same number of elements in the Lua table, then you can set this argument to `true` to avoid the overhead of explicit table clearing.
---
--- According to the current implementation, for maximum 200 Lua tables can be cached in an individual pool. We may make this configurable in the future. If the specified table pool already exceeds its size limit, then the `tb` table is subject to garbage collection. This behavior is to avoid potential memory leak due to unbalanced `fetch` and `release` method calls.
---
---@param pool_name string
---@param tb        table
---@param no_clear? boolean
function tablepool.release(pool_name, tb, no_clear) end

--- Fetches a (free) Lua table from the table pool of the specified name `pool_name`.
---
--- If the pool does not exist or the pool is empty, simply create a Lua table whose array part has `narr` elements and whose hash table part has `nrec` elements.
---
---@param  pool_name string
---@param  narr      number size of the array-like part of the table
---@param  nrec      number size of the hash-like part of the table
---@return table
function tablepool.fetch(pool_name, narr, nrec) end

return tablepool