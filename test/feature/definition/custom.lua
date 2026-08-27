print('[feature.definition.custom] 测试中...')

local setupModName = require('test.helpers.custom-alias').modname

---@param scope Scope
---@param kind string
---@param uri Uri
---@return Scope.Root
local function createRoot(scope, kind, uri)
    local root = New 'Scope.Root' (scope, kind, uri, scope.fs, scope.config)
    scope.roots[#scope.roots+1] = root
    return root
end

---@param script string
---@return string script
---@return integer offset
local function parseMark(script)
    local newScript, catched = test.catch(script, '?')
    return newScript, catched['?'][1][1]
end

do
    -- ModName onDefinition：require 'a' 跳转到 a.lua 文件开头
    local scope <close> = ls.scope.create('definition-custom-modname', 'file:///root')
    local root = createRoot(scope, 'workspace', 'file:///root')

    local uriMeta = 'file:///root/meta.lua'
    local uriA = 'file:///root/a.lua'
    local uriMain = 'file:///root/main.lua'
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
local x = 1
return x
]])
    local script, offset = parseMark [[
-- line1
-- line2
require 'a<??>'
]]
    local fileMain <close> = ls.file.setServerText(uriMain, script)

    scope.vm:indexFile(uriMeta)
    scope.vm:indexFile(uriA)
    scope.vm:indexFile(uriMain)

    local results = ls.feature.definition(uriMain, offset)
    lt.assertEquals(#results, 1)
    lt.assertEquals(results[1].uri, uriA)
    -- 跳转到文件开头 offset 0
    lt.assertEquals(results[1].range[1], 0)
    lt.assertEquals(results[1].range[2], 0)
    -- originRange 位于触发文件（main.lua）中
    lt.assertEquals(results[1].originUri, uriMain)
    local docMain = assert(scope:getDocument(uriMain))
    local ast = assert(docMain.ast)
    local src
    for _, node in ipairs(ast.nodesMap['string'] or {}) do
        src = node
        break
    end
    assert(src)
    lt.assertEquals(results[1].originRange[1], src.start)
    lt.assertEquals(results[1].originRange[2], src.finish)

    -- LSP 层转换：originSelectionRange 应用 main.lua（原文件）转换，而非 a.lua
    local dconverter = docMain:makeLSPConverter('utf-16')
    local sconverter = scope:makeLSPConverter('utf-16')
    local link = assert(sconverter:locationLink(results[1]))
    lt.assertEquals(link.targetUri, uriA)
    lt.assertEquals(link.originSelectionRange.start.line, 2)
    lt.assertEquals(link.originSelectionRange.start.character, 8)
    lt.assertEquals(link.originSelectionRange['end'].line, 2)
    lt.assertEquals(link.originSelectionRange['end'].character, 11)

    playground:dispose()
end

do
    -- ModName onDefinition：未匹配到文件时无定义结果
    local scope <close> = ls.scope.create('definition-custom-none', 'file:///root')
    local root = createRoot(scope, 'workspace', 'file:///root')

    local uriMeta = 'file:///root/meta.lua'
    local uriMain = 'file:///root/main.lua'
    root.uriSet[uriMeta] = true
    root.uriSet[uriMain] = true

    local playground = setupModName(scope)

    local fileMeta <close> = ls.file.setServerText(uriMeta, [[
---@generic T: ModName
---@param modname T
---@return Module<T>
function require(modname) end
]])
    local script, offset = parseMark [[
require 'not-exists<??>'
]]
    local fileMain <close> = ls.file.setServerText(uriMain, script)

    scope.vm:indexFile(uriMeta)
    scope.vm:indexFile(uriMain)

    local results = ls.feature.definition(uriMain, offset)
    lt.assertEquals(#results, 0)

    playground:dispose()
end

print('[feature.definition.custom] 测试完毕')