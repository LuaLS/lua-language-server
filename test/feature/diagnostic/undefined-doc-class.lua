TEST_DIAGNOSTIC [[
---@class A : <?B?>
]] { 'undefined-doc-class' }

TEST_DIAGNOSTIC [[
---@class A
---@class B : A
]] { '-undefined-doc-class' }

TEST_DIAGNOSTIC [[
---@class Container<T>
---@class A : Container<T>
]] { '-undefined-doc-class' }

TEST_DIAGNOSTIC [[
---@type number
---@class A : number
]] { '-undefined-doc-class' }
