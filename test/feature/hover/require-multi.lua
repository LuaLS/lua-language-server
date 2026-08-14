print('[hover.require-multi] 测试中...')

do
    -- require 被用户覆盖（多定义）后，ModName 的 onHover 仍应触发
    local scope <close> = ls.scope.create('hover-require-multi', 'file:///root')
    local root = New 'Scope.Root' (scope, 'workspace', 'file:///root', scope.fs, scope.config)
    scope.roots[#scope.roots+1] = root
    local uriMeta = 'file:///root/meta.lua'
    local uriA = 'file:///root/test.lua'
    local uriMain = 'file:///root/main.lua'
    root.uriSet[uriMeta] = true
    root.uriSet[uriA] = true
    root.uriSet[uriMain] = true

    local setupModName = require('test.helpers.custom-alias').modname
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
require = function () end
local x = require 'te<??>st'
]], '!?')
    local fileMain <close> = ls.file.setServerText(uriMain, script)

    scope.vm:indexFile(uriMeta)
    scope.vm:indexFile(uriA)
    scope.vm:indexFile(uriMain)

    local offset = catched['?'][1][1]
    local hover = ls.feature.hover(uriMain, offset)
    lt.assertEquals(hover ~= nil, true)
    if hover then
        lt.assertEquals(#hover.items >= 2, true)
        -- 第二个 item 为 ModName onHover 结果：description 含文件路径
        local second = hover.items[2]
        local desc = second and second.description
        lt.assertEquals(desc, '* [test.lua]({}) （搜索路径：`?.lua`）' % { uriA })
    end
end

do
    -- require 被保存/覆盖/恢复（originRequire 模式，覆盖函数有参数）后，onHover 仍应触发
    local scope <close> = ls.scope.create('hover-require-origin', 'file:///root')
    local root = New 'Scope.Root' (scope, 'workspace', 'file:///root', scope.fs, scope.config)
    scope.roots[#scope.roots+1] = root
    local uriMeta = 'file:///root/meta.lua'
    local uriA = 'file:///root/test.lua'
    local uriMain = 'file:///root/main.lua'
    root.uriSet[uriMeta] = true
    root.uriSet[uriA] = true
    root.uriSet[uriMain] = true

    local setupModName = require('test.helpers.custom-alias').modname
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
local originRequire = require
require = function (n)
    local v, p = originRequire(n)
    if p and p:find 'test/' then
        package.loaded[n] = nil
    end
    return v, p
end
require 'te<??>st'
require = originRequire
]], '!?')
    local fileMain <close> = ls.file.setServerText(uriMain, script)

    scope.vm:indexFile(uriMeta)
    scope.vm:indexFile(uriA)
    scope.vm:indexFile(uriMain)

    local offset = catched['?'][1][1]
    local hover = ls.feature.hover(uriMain, offset)
    lt.assertEquals(hover ~= nil, true)
    if hover then
        lt.assertEquals(#hover.items >= 2, true)
        local second = hover.items[2]
        local desc = second and second.description
        lt.assertEquals(desc, '* [test.lua]({}) （搜索路径：`?.lua`）' % { uriA })
    end
end

print('[hover.require-multi] 完毕')
