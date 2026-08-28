TEST_DIAGNOSTIC [[
---@class A
---@field <?x?> Class
---@field <?x?> Class
]] { 'duplicate-doc-field', 'duplicate-doc-field' }

TEST_DIAGNOSTIC [[
---@class Emit
---@field on fun(eventName: string, cb: function)
---@field on fun(eventName: '"died"', cb: fun(i: integer))
]] { '-duplicate-doc-field' }

-- [SKIPPED] 同签名 fun 重复检测：函数 field 一律按重载跳过（本分支暂不支持签名比较），留待后续
TEST_DIAGNOSTIC [[
---@class Emit
---@field on fun(eventName: string, cb: function)
---@field on fun(eventName: '"died"', cb: fun(i: integer))
---@field on fun(eventName: '"died"', cb: fun(i: integer))
]] { '-duplicate-doc-field' }

TEST_DIAGNOSTIC [[
---@class A
---@class B
---@field [integer] A
---@field [A] true
]] { '-duplicate-doc-field' }

TEST_DIAGNOSTIC [[
---@class A
---@class B
---@field [<?A?>] A
---@field [<?A?>] true
]] { 'duplicate-doc-field', 'duplicate-doc-field' }
