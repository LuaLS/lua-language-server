-- custom alias 的 onHover 支持测试：
-- 定义 setValue(string/number) + onHover 的 alias，hover 字符串/数字字面量时，
-- 除常规提示外追加 onHover 返回值。

print('[hover.custom] 测试中...')

local setupModName = require('test.helpers.custom-alias').modname

do
    local playground = ls.custom.playground(test.scope)
    do
        local _ENV = playground.env
        _ENV.alias('ModName')
            : define(function (c)
                c.setValue(c.type 'string')
            end)
            : onHover(function (c)
                local src = c.source
                if not src then
                    return
                end
                if src.kind == 'string' then
                    ---@cast src LuaParser.Node.String
                    return 'ModName: ' .. src.value
                elseif src.kind == 'local' then
                    ---@cast src LuaParser.Node.Local
                    return 'ModName var: ' .. src.id
                end
            end)
        _ENV.alias('Count')
            : define(function (c)
                c.setValue(c.type 'integer')
            end)
            : onHover(function (c)
                return { label = 'Count A', description = 'Count B' }
            end)
    end

    ---@async
    ---@param code string
    ---@return string[]
    local function hoverLabels(code)
        local script, catched = test.catch(code, '!?')
        local file <close> = ls.file.setServerText(test.fileUri, script)
        local vfile <close> = test.scope.vm:indexFile(test.fileUri)
        local offset = catched['?'][1][1]
        local hover = ls.feature.hover(test.fileUri, offset)
        if not hover then
            return {}
        end
        return ls.util.map(hover.items, function (item)
            return item.label
        end)
    end

    -- 字符串字面量 + ---@type ModName：常规提示 + custom hover（返回单个字符串）
    lt.assertEquals(hoverLabels([[
---@type ModName
local modname = 'utility<??>'
]]), {
        '7 个字节',
        'ModName: utility',
    })

    -- onHover 返回 { label, description } 对象：label 为 item 标题，description 为附加说明
    lt.assertEquals(hoverLabels([[
---@type Count
local count = 42<??>
]]), {
        'Count A',
    })

    -- assign 场景：类型注解来自变量声明，通过 getExpectValue 兜底触发
    lt.assertEquals(hoverLabels([[
---@type ModName
local modname
modname = 'utility<??>'
]]), {
        '7 个字节',
        'ModName: utility',
    })

    -- 变量名本身：常规变量提示 + custom hover（source 为 local 节点）
    lt.assertEquals(hoverLabels([[
---@type ModName
local <?modname?> = 'utility'
]]), {
        'local modname: ModName',
        'ModName var: modname',
    })

    -- 无类型注解的普通字符串：不触发 custom hover
    lt.assertEquals(hoverLabels([[
local s = 'hello<??>'
]]), {
        '5 个字节',
    })

    playground:dispose()
end

do
    -- require 场景：hover `require 'test'` 的字符串参数，通过参数的期望类型
    -- （泛型约束 T: ModName）触发 ModName 的 onHover，显示搜索到的文件路径
    local scope <close> = ls.scope.create('hover-custom-require', 'file:///root')
    local root = New 'Scope.Root' (scope, 'workspace', 'file:///root', scope.fs, scope.config)
    scope.roots[#scope.roots+1] = root
    local uriMeta = 'file:///root/meta.lua'
    local uriA = 'file:///root/test.lua'
    local uriB = 'file:///root/main.lua'
    root.uriSet[uriMeta] = true
    root.uriSet[uriA] = true
    root.uriSet[uriB] = true

    local playground = setupModName(scope)

    -- meta 定义 require 签名：参数类型约束为 ModName
    local fileMeta <close> = ls.file.setServerText(uriMeta, [[
---@generic T: ModName
---@param modname T
---@return Module<T>
function require(modname) end
]])
    local fileA <close> = ls.file.setServerText(uriA, [[
return 1
]])
    local scriptB, catched = test.catch([[
require 'te<??>st'
]], '!?')
    local fileB <close> = ls.file.setServerText(uriB, scriptB)

    scope.vm:indexFile(uriMeta)
    scope.vm:indexFile(uriA)
    scope.vm:indexFile(uriB)

    local offset = catched['?'][1][1]
    local hover = ls.feature.hover(uriB, offset)
    local labels = ls.util.map(hover and hover.items or {}, function (item)
        return item.label
    end)
    lt.assertEquals(labels, {
        '4 个字节',
        '',
    })
    local second = hover and hover.items[2]
    local desc = second and second.description
    lt.assertEquals(desc, '* [test.lua]({}) （搜索路径：`?.lua`）' % { uriA })

    playground:dispose()
end

print('[hover.custom] 完毕')
