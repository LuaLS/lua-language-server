TEST_DIAGNOSTIC [[
---@field <?x Class?>
]] { 'doc-field-no-class' }

TEST_DIAGNOSTIC [[
---@class Class

---@field <?x Class?>
]] { 'doc-field-no-class' }

TEST_DIAGNOSTIC [[
---@class Class
---@field x Class
]] { '-doc-field-no-class' }

TEST_DIAGNOSTIC [[
---@class Class
---@field x Class
---@field y Class
]] { '-doc-field-no-class' }

TEST_DIAGNOSTIC [[
---@class Class
---doc
---doc
---@field x Class
]] { '-doc-field-no-class' }
