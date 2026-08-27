-- 自定义 alias 的补全：字符串参数的期望类型为 ModName 时，
-- 通过 onCompletion 回调按已输入前缀枚举模块文件路径。
local setupModName = require('test.helpers.custom-alias').modname

do
    local scope <close> = ls.scope.create('completion-custom', 'file:///root')
    local root = New 'Scope.Root' (scope, 'workspace', 'file:///root', scope.fs, scope.config)
    scope.roots[#scope.roots+1] = root
    local uriMeta  = 'file:///root/meta.lua'
    local uriA     = 'file:///root/a.lua'
    local uriAB    = 'file:///root/a/b.lua'
    local uriTest  = 'file:///root/test.lua'
    local uriMain  = 'file:///root/main.lua'
    root.uriSet[uriMeta] = true
    root.uriSet[uriA] = true
    root.uriSet[uriAB] = true
    root.uriSet[uriTest] = true
    root.uriSet[uriMain] = true

    local playground = setupModName(scope)

    local fileMeta <close> = ls.file.setServerText(uriMeta, [[
---@generic T: ModName
---@param modname T
---@return Module<T>
function require(modname) end
]])
    local fileA <close> = ls.file.setServerText(uriA, [[
return 1
]])
    local fileAB <close> = ls.file.setServerText(uriAB, [[
return 2
]])
    local fileTest <close> = ls.file.setServerText(uriTest, [[
return 3
]])
    local script, catched = test.catch([[
require 'te<??>'
]], '!?')
    local fileMain <close> = ls.file.setServerText(uriMain, script)
    scope.vm:indexFile(uriMeta)
    scope.vm:indexFile(uriA)
    scope.vm:indexFile(uriAB)
    scope.vm:indexFile(uriTest)
    scope.vm:indexFile(uriMain)

    local offset = catched['?'][1][1]
    local items = ls.feature.completion(uriMain, offset)
    lt.assertEquals(#items, 1)
    lt.assertEquals(items[1].label, 'test')
    lt.assertEquals(items[1].kind, ls.spec.CompletionItemKind.Module)
    lt.assertEquals(items[1].detail, 'test.lua')
    lt.assertEquals(items[1].documentation.kind, 'markdown')
    lt.assertEquals(items[1].documentation.value, '* [test.lua](file:///root/test.lua) （搜索路径：`?.lua`）')

    playground:dispose()
end

do
    -- 前缀 'a' 命中 a.lua 与 a/b.lua（按模块名升序）
    local scope <close> = ls.scope.create('completion-custom-a', 'file:///root')
    local root = New 'Scope.Root' (scope, 'workspace', 'file:///root', scope.fs, scope.config)
    scope.roots[#scope.roots+1] = root
    local uriMeta  = 'file:///root/meta.lua'
    local uriA     = 'file:///root/a.lua'
    local uriAB    = 'file:///root/a/b.lua'
    local uriMain  = 'file:///root/main.lua'
    root.uriSet[uriMeta] = true
    root.uriSet[uriA] = true
    root.uriSet[uriAB] = true
    root.uriSet[uriMain] = true

    local playground = setupModName(scope)

    local fileMeta <close> = ls.file.setServerText(uriMeta, [[
---@generic T: ModName
---@param modname T
---@return Module<T>
function require(modname) end
]])
    local fileA <close> = ls.file.setServerText(uriA, [[
return 1
]])
    local fileAB <close> = ls.file.setServerText(uriAB, [[
return 2
]])
    local script, catched = test.catch([[
require 'a<??>'
]], '!?')
    local fileMain <close> = ls.file.setServerText(uriMain, script)
    scope.vm:indexFile(uriMeta)
    scope.vm:indexFile(uriA)
    scope.vm:indexFile(uriAB)
    scope.vm:indexFile(uriMain)

    local offset = catched['?'][1][1]
    local items = ls.feature.completion(uriMain, offset)
    lt.assertEquals(#items, 2)
    lt.assertEquals(items[1].label, 'a')
    lt.assertEquals(items[1].detail, 'a.lua')
    lt.assertEquals(items[1].documentation.kind, 'markdown')
    lt.assertEquals(items[1].documentation.value, '* [a.lua](file:///root/a.lua) （搜索路径：`?.lua`）')
    lt.assertEquals(items[2].label, 'a.b')
    lt.assertEquals(items[2].detail, 'a/b.lua')
    lt.assertEquals(items[2].documentation.kind, 'markdown')
    lt.assertEquals(items[2].documentation.value, '* [a/b.lua](file:///root/a/b.lua) （搜索路径：`?.lua`）')

    playground:dispose()
end

do
    -- 空前缀：列出全部模块（meta、a、a.b、test）
    local scope <close> = ls.scope.create('completion-custom-all', 'file:///root')
    local root = New 'Scope.Root' (scope, 'workspace', 'file:///root', scope.fs, scope.config)
    scope.roots[#scope.roots+1] = root
    local uriMeta  = 'file:///root/meta.lua'
    local uriA     = 'file:///root/a.lua'
    local uriAB    = 'file:///root/a/b.lua'
    local uriTest  = 'file:///root/test.lua'
    local uriMain  = 'file:///root/main.lua'
    root.uriSet[uriMeta] = true
    root.uriSet[uriA] = true
    root.uriSet[uriAB] = true
    root.uriSet[uriTest] = true
    root.uriSet[uriMain] = true

    local playground = setupModName(scope)

    local fileMeta <close> = ls.file.setServerText(uriMeta, [[
---@generic T: ModName
---@param modname T
---@return Module<T>
function require(modname) end
]])
    local fileA <close> = ls.file.setServerText(uriA, [[
return 1
]])
    local fileAB <close> = ls.file.setServerText(uriAB, [[
return 2
]])
    local fileTest <close> = ls.file.setServerText(uriTest, [[
return 3
]])
    local script, catched = test.catch([[
require '<??>'
]], '!?')
    local fileMain <close> = ls.file.setServerText(uriMain, script)
    scope.vm:indexFile(uriMeta)
    scope.vm:indexFile(uriA)
    scope.vm:indexFile(uriAB)
    scope.vm:indexFile(uriTest)
    scope.vm:indexFile(uriMain)

    local offset = catched['?'][1][1]
    local items = ls.feature.completion(uriMain, offset)
    lt.assertEquals(#items, 5)
    lt.assertEquals(items[1].label, 'a')
    lt.assertEquals(items[2].label, 'a.b')
    lt.assertEquals(items[3].label, 'b')
    lt.assertEquals(items[4].label, 'meta')
    lt.assertEquals(items[5].label, 'test')

    playground:dispose()
end

do
    -- 自定义 kind：回调用 c.XXXXKind 指定补全项 kind，消费端原样使用
    local scope <close> = ls.scope.create('completion-custom-kind', 'file:///root')
    local root = New 'Scope.Root' (scope, 'workspace', 'file:///root', scope.fs, scope.config)
    scope.roots[#scope.roots+1] = root
    local uriMeta = 'file:///root/meta.lua'
    local uriMain = 'file:///root/main.lua'
    root.uriSet[uriMeta] = true
    root.uriSet[uriMain] = true

    local playground = ls.custom.playground(scope)
    do
        local _ENV = playground.env
        _ENV.alias('Cmd')
            : define(function (c)
                c.setValue(c.type 'string')
            end)
            : onCompletion(function (c)
                return {
                    { label = 'run',   kind = c.kind.Keyword },
                    { label = 'reset', kind = c.kind.Value },
                }
            end)
    end

    local fileMeta <close> = ls.file.setServerText(uriMeta, [[
---@param cmd Cmd
function run(cmd) end
]])
    local script, catched = test.catch([[
run 'r<??>'
]], '!?')
    local fileMain <close> = ls.file.setServerText(uriMain, script)
    scope.vm:indexFile(uriMeta)
    scope.vm:indexFile(uriMain)

    local offset = catched['?'][1][1]
    local items = ls.feature.completion(uriMain, offset)
    lt.assertEquals(#items, 2)
    lt.assertEquals(items[1].label, 'run')
    lt.assertEquals(items[1].kind, ls.spec.CompletionItemKind.Keyword)
    lt.assertEquals(items[2].label, 'reset')
    lt.assertEquals(items[2].kind, ls.spec.CompletionItemKind.Value)

    playground:dispose()
end

do
    -- 用户场景：空字符串 require ''（编辑器自动补全引号后，光标在引号内）
    local scope <close> = ls.scope.create('completion-custom-empty', 'file:///root')
    local root = New 'Scope.Root' (scope, 'workspace', 'file:///root', scope.fs, scope.config)
    scope.roots[#scope.roots+1] = root
    local uriMeta  = 'file:///root/meta.lua'
    local uriA     = 'file:///root/a.lua'
    local uriMain  = 'file:///root/main.lua'
    root.uriSet[uriMeta] = true
    root.uriSet[uriA] = true
    root.uriSet[uriMain] = true

    local playground = setupModName(scope)

    local fileMeta <close> = ls.file.setServerText(uriMeta, [[
---@generic T: ModName
---@param modname T
---@return Module<T>
function require(modname) end
]])
    local fileA <close> = ls.file.setServerText(uriA, [[
return 1
]])
    local script, catched = test.catch([[
require '<??>'
]], '!?')
    local fileMain <close> = ls.file.setServerText(uriMain, script)
    scope.vm:indexFile(uriMeta)
    scope.vm:indexFile(uriA)
    scope.vm:indexFile(uriMain)

    local offset = catched['?'][1][1]
    local items = ls.feature.completion(uriMain, offset)
    local labels = {}
    for _, it in ipairs(items) do
        labels[#labels+1] = it.label
    end
    lt.assertEquals(table.concat(labels, ','), 'a,meta')

    playground:dispose()
end

do
    -- 括号形式 require('') 空字符串补全
    local scope <close> = ls.scope.create('completion-custom-paren', 'file:///root')
    local root = New 'Scope.Root' (scope, 'workspace', 'file:///root', scope.fs, scope.config)
    scope.roots[#scope.roots+1] = root
    local uriMeta  = 'file:///root/meta.lua'
    local uriA     = 'file:///root/a.lua'
    local uriMain  = 'file:///root/main.lua'
    root.uriSet[uriMeta] = true
    root.uriSet[uriA] = true
    root.uriSet[uriMain] = true

    local playground = setupModName(scope)

    local fileMeta <close> = ls.file.setServerText(uriMeta, [[
---@generic T: ModName
---@param modname T
---@return Module<T>
function require(modname) end
]])
    local fileA <close> = ls.file.setServerText(uriA, [[
return 1
]])
    local script, catched = test.catch([[
require('<??>')
]], '!?')
    local fileMain <close> = ls.file.setServerText(uriMain, script)
    scope.vm:indexFile(uriMeta)
    scope.vm:indexFile(uriA)
    scope.vm:indexFile(uriMain)

    local offset = catched['?'][1][1]
    local items = ls.feature.completion(uriMain, offset)
    local labels = {}
    for _, it in ipairs(items) do
        labels[#labels+1] = it.label
    end
    lt.assertEquals(table.concat(labels, ','), 'a,meta')

    playground:dispose()
end

do
    -- 用户场景：单字符 require 'a'（编辑器自动补全引号后，光标在引号内）
    local scope <close> = ls.scope.create('completion-custom-onechar', 'file:///root')
    local root = New 'Scope.Root' (scope, 'workspace', 'file:///root', scope.fs, scope.config)
    scope.roots[#scope.roots+1] = root
    local uriMeta  = 'file:///root/meta.lua'
    local uriA     = 'file:///root/a.lua'
    local uriMain  = 'file:///root/main.lua'
    root.uriSet[uriMeta] = true
    root.uriSet[uriA] = true
    root.uriSet[uriMain] = true

    local playground = setupModName(scope)

    local fileMeta <close> = ls.file.setServerText(uriMeta, [[
---@generic T: ModName
---@param modname T
---@return Module<T>
function require(modname) end
]])
    local fileA <close> = ls.file.setServerText(uriA, [[
return 1
]])
    local script, catched = test.catch([[
require 'a<??>'
]], '!?')
    local fileMain <close> = ls.file.setServerText(uriMain, script)
    scope.vm:indexFile(uriMeta)
    scope.vm:indexFile(uriA)
    scope.vm:indexFile(uriMain)

    local offset = catched['?'][1][1]
    local items = ls.feature.completion(uriMain, offset)
    local labels = {}
    for _, it in ipairs(items) do
        labels[#labels+1] = it.label
    end
    lt.assertEquals(table.concat(labels, ','), 'a')

    playground:dispose()
end

do
    -- 字符串内无期望类型时，不显示关键字/全局变量
    local scope <close> = ls.scope.create('completion-custom-noglobal', 'file:///root')
    local root = New 'Scope.Root' (scope, 'workspace', 'file:///root', scope.fs, scope.config)
    scope.roots[#scope.roots+1] = root
    local uriMain  = 'file:///root/main.lua'
    root.uriSet[uriMain] = true

    local script, catched = test.catch([[
local s = 'a<??>'
]], '!?')
    local fileMain <close> = ls.file.setServerText(uriMain, script)
    scope.vm:indexFile(uriMain)

    local offset = catched['?'][1][1]
    local items = ls.feature.completion(uriMain, offset)
    local labels = {}
    for _, it in ipairs(items) do
        labels[#labels+1] = it.label
    end
    lt.assertEquals(#labels, 0)

    -- 引号内的全局 require 调用场景（无 ModName 期望）：也不应显示全局变量
    local script2, catched2 = test.catch([[
foo 'a<??>'
]], '!?')
    ls.file.setServerText(uriMain, script2)
    scope.vm:indexFile(uriMain)
    local offset2 = catched2['?'][1][1]
    local items2 = ls.feature.completion(uriMain, offset2)
    local labels2 = {}
    for _, it in ipairs(items2) do
        labels2[#labels2+1] = it.label
    end
    lt.assertEquals(#labels2, 0)

    -- 全局变量应在字符串外正常提供
    local script3, catched3 = test.catch([[
myGlobal = 1
m<??>
]], '!?')
    ls.file.setServerText(uriMain, script3)
    scope.vm:indexFile(uriMain)
    local offset3 = catched3['?'][1][1]
    local items3 = ls.feature.completion(uriMain, offset3)
    local labels3 = {}
    for _, it in ipairs(items3) do
        labels3[#labels3+1] = it.label
    end
    lt.assertEquals(table.concat(labels3, ','):find('myGlobal', 1, true) ~= nil, true)
end

do
    -- 跨文件空字符串赋值不污染 require '' 的期望类型（池化 value 共享 expectParent）
    local scope <close> = ls.scope.create('completion-custom-pollute', 'file:///root')
    local root = New 'Scope.Root' (scope, 'workspace', 'file:///root', scope.fs, scope.config)
    scope.roots[#scope.roots+1] = root
    local uriMeta  = 'file:///root/meta.lua'
    local uriA     = 'file:///root/a.lua'
    local uriMain  = 'file:///root/main.lua'
    root.uriSet[uriMeta] = true
    root.uriSet[uriA] = true
    root.uriSet[uriMain] = true

    local playground = setupModName(scope)

    local fileMeta <close> = ls.file.setServerText(uriMeta, [[
---@generic T: ModName
---@param modname T
---@return Module<T>
function require(modname) end
]])
    local fileA <close> = ls.file.setServerText(uriA, [[
local y = ''
]])
    local script, catched = test.catch([[
require '<??>'
]], '!?')
    local fileMain <close> = ls.file.setServerText(uriMain, script)
    scope.vm:indexFile(uriMeta)
    scope.vm:indexFile(uriMain)
    scope.vm:indexFile(uriA)

    local offset = catched['?'][1][1]
    local items = ls.feature.completion(uriMain, offset)
    local labels = {}
    for _, it in ipairs(items) do
        labels[#labels+1] = it.label
    end
    lt.assertEquals(table.concat(labels, ','), 'a,meta')

    playground:dispose()
end