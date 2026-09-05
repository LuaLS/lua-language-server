-- 研究用：staticValue 短路如何丢失字段赋值
-- 运行：bin\lua-language-server.exe --test feature.diagnostic.debug-staticvalue

local function dump(tag, script)
    print(('\n===== %s ====='):format(tag))
    local _, catched = TEST_FRAME(script, function ()
        local vfile = test.scope.vm:getFile(test.fileUri)
        local doc = test.scope:getDocument(test.fileUri)
        if not (vfile and doc) then
            return
        end
        -- 找字段读取点 `t.x` / `v.x` 的 base 变量
        for _, field in ipairs(doc.ast.nodesMap['field'] or {}) do
            ---@cast field LuaParser.Node.Field
            local key = field.key
            if key and key.kind == 'fieldid' and key.id == 'x' and not field.value then
                local base = field.last
                local var = base and test.scope.vm:getVariable(base)
                local node = base and vfile:getNode(base)
                if var and var.kind == 'variable' then
                    local master = var:getMasterVariable()
                    print('  base 节点 kind      = ' .. tostring(node and node.kind))
                    print('  [shadow] currentValue = ' .. tostring(var.currentValue and var.currentValue.kind)
                        .. ' view=' .. tostring(var.currentValue and var.currentValue:view() or '-'))
                    print('  [shadow] staticValue  = ' .. tostring(var.staticValue and var.staticValue.kind))
                    print('  [master] staticValue  = ' .. tostring(master.staticValue and master.staticValue.kind))
                    print('  [master] currentValue = ' .. tostring(master.currentValue and master.currentValue.kind))
                    print('  [master] childsValue  = ' .. tostring(master.childsValue and master.childsValue:view()))
                    print('  读取值 var.value    = ' .. tostring(var.value and var.value:view()))
                end
            end
        end
        ---@diagnostic disable-next-line: await-in-sync
        local diags = ls.feature.diagnostic(test.fileUri)
        for _, d in ipairs(diags) do
            print('  诊断: ' .. tostring(d.code) .. ' | ' .. tostring(d.message))
        end
        if #diags == 0 then
            print('  诊断: （无）')
        end
    end)
    return catched
end

-- ① 表字面量：无 staticValue → 走 equivalentValue → childs 合并 → 字段可见
dump('① local t = {}  （表字面量，正常）', [[
local t = {}
t.x = 1
print(t.x)
]])

-- ② 函数返回值：有 staticValue → value getter 短路 → childs 被跳过 → 字段丢失
dump('② local t = mk() （函数返回，字段丢失）', [[
local function mk() return {} end
local t = mk()
t.x = 1
print(t.x)
]])

-- ③ ②的变体：字段挂在函数内再 return（beautify 同款形态）
dump('③ t = mk() + 函数内挂字段 + return（跨函数丢失）', [[
local function mk() return {} end
local t = mk()

local function f()
    t.x = 1
    return t
end

local v = f()
print(v.x)
]])

-- ④ 用户的猜想：拆开声明与赋值 → 走 assign 而非 localdef
dump('④ local t; t = mk(); t.x = 1（拆开声明与赋值）', [[
local function mk() return {} end
local t
t = mk()
t.x = 1
print(t.x)
]])
