TEST_DIAGNOSTIC [[
---@alias <?A?> integer
---@alias <?A?> integer
]] { 'duplicate-doc-alias', 'duplicate-doc-alias' }

TEST_DIAGNOSTIC [[
---@class A
---@class B
---@alias <?A?> B
]] { 'duplicate-doc-alias' }

TEST_DIAGNOSTIC [[
---@alias A integer
---@alias(partial) A integer
]] { '-duplicate-doc-alias' }

TEST_DIAGNOSTIC [[
---@alias A integer
---@alias B string
]] { '-duplicate-doc-alias' }
