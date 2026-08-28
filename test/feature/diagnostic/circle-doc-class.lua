TEST_DIAGNOSTIC [[
---@class <?A : B?>
---@class <?B : C?>
---@class <?C : D?>
---@class <?D : A?>
]] { 'circle-doc-class', 'circle-doc-class', 'circle-doc-class', 'circle-doc-class' }

TEST_DIAGNOSTIC [[
---@class A : B
---@class B : C
---@class C : D
---@class D
]] { '-circle-doc-class' }

TEST_DIAGNOSTIC [[
---@class A : B
---@class B
]] { '-circle-doc-class' }
