local parser = require 'parser'
local fs = require 'bee.filesystem'
local utility = require 'utility'

EXISTS = {}

local function eq(a, b)
    local tp1, tp2 = type(a), type(b)
    if tp1 ~= tp2 then
        return false
    end
    if a == '<LOOP>' and tp1 == 'table' then
        return true
    end
    if b == '<LOOP>' and tp2 == 'table' then
        return true
    end
    if tp1 == 'table' then
        local checked = {}
        for k in pairs(a) do
            if not eq(a[k], b[k]) then
                return false
            end
            checked[k] = true
        end
        for k in pairs(b) do
            if not checked[k] then
                return false
            end
        end
        return true
    end
    if tp1 == 'number' then
        return ('%q'):format(a) == ('%q'):format(b)
    end
    return a == b
end

---@type {[string]: integer, [integer]: string}
local sortList = {
    'specials',
    'type', 'start', 'vstart', 'bstart', 'finish', 'effect', 'range', 'tindex',
    'tag', 'special', 'keyword',
    'parent', 'extParent', 'child',
    'filter',
    'vararg',
    'node', 'locPos',
    'op', 'args',
    'loc', 'init', 'max', 'step', 'keys', 'exps', 'call', 'func',
    'dot', 'colon',
    'field', 'index', 'method',
    'exp', 'value', 'vref',
    'attrs', 'escs',
    'locals', 'ref', 'returns', 'breaks',
}
for i, v in ipairs(sortList) do
    sortList[v] = i
end
local ignoreList = {
    'specials', 'locals', 'ref', 'node', 'parent', 'extParent', 'returns', 'state', 'mirror', 'next', 'vararg', 'originalComment', 'typeCache', 'eachCache', 'bindSource'
}
local ignoreMap = {}
for i, v in ipairs(ignoreList) do
    ignoreMap[v] = true
end

IGNORE_MAP = ignoreMap

local myOption = {
    alignment = true,
    sorter = function (keys, keymap)
        table.sort(keys, function (a, b)
            local tp1 = type(a)
            local tp2 = type(b)
            if tp1 == 'number' and tp2 ~= 'number' then
                return false
            end
            if tp1 ~= 'number' and tp2 == 'number' then
                return true
            end
            if tp1 == 'number' and tp2 == 'number' then
                return a < b
            end
            local s1 = sortList[a] or 9999
            local s2 = sortList[b] or 9999
            if s1 == s2 then
                return a < b
            else
                return s1 < s2
            end
        end)
    end,
    loop = ('%q'):format('<LOOP>'),
    number = function (n)
        return ('%q'):format(n)
    end,
    format = setmetatable({}, { __index = function (_, key)
        return function (value, _, _, _)
            if ignoreMap[key] then
                return '<IGNORE>'
            end
            if type(key) == 'string' and key:sub(1, 1) == '_' then
                return nil
            end
            return value
        end
    end}),
}

local targetOption = {
    alignment = true,
    sorter = function (keys, keymap)
        table.sort(keys, function (a, b)
            local tp1 = type(a)
            local tp2 = type(b)
            if tp1 == 'number' and tp2 ~= 'number' then
                return false
            end
            if tp1 ~= 'number' and tp2 == 'number' then
                return true
            end
            if tp1 == 'number' and tp2 == 'number' then
                return a < b
            end
            local s1 = sortList[a] or 9999
            local s2 = sortList[b] or 9999
            if s1 == s2 then
                return a < b
            else
                return s1 < s2
            end
        end)
    end,
    loop = ('%q'):format('<LOOP>'),
    number = function (n)
        return ('%q'):format(n)
    end,
}

local function autoFix(myBuf, targetBuf)
    local info = debug.getinfo(3, 'Sl')
    local filename = info.source:sub(2)
    local fileBuf = utility.loadFile(filename)
    assert(fileBuf)
    local pos = fileBuf:find(targetBuf, 1, true)
    local newFileBuf = fileBuf:sub(1, pos-1) .. myBuf .. fileBuf:sub(pos + #targetBuf)
    utility.saveFile(filename, newFileBuf)
end

local function test(type)
    local mode = type
    if mode == 'Dirty' then
        mode = 'Lua'
    end
    CHECK = function (buf, opt)
        return function (target_ast)
            local state, err = parser.compile(buf, mode, 'Lua 5.4', opt)
            if not state then
                error(('语法树生成失败：%s'):format(err))
            end
            state.ast.state = nil
            local result = utility.dump(state.ast, myOption)
            local expect = utility.dump(target_ast, targetOption)
            if result ~= expect then
                fs.create_directories(ROOT / 'test' / 'log')
                utility.saveFile((ROOT / 'test' / 'log' / 'my_ast.ast'):string(), result)
                utility.saveFile((ROOT / 'test' / 'log' / 'target_ast.ast'):string(), expect)
                autoFix(result, expect)
                error(('语法树不相等：%s\n%s'):format(type, buf))
            end
        end
    end
    LuaDoc = function (buf)
        return function (target_doc)
            local state, err = parser.compile(buf, 'Lua', 'Lua 5.4')
            if not state then
                error(('语法树生成失败：%s'):format(err))
            end
            parser.luadoc(state)
            for _, doc in ipairs(state.ast.docs) do
                doc.bindGroup = nil
                doc.bindSources = nil
            end
            state.ast.docs.groups = nil
            local result = utility.dump(state.ast.docs, myOption)
            local expect = utility.dump(target_doc, targetOption)
            if result ~= expect then
                fs.create_directories(ROOT / 'test' / 'log')
                utility.saveFile((ROOT / 'test' / 'log' / 'my_doc.ast'):string(), result)
                utility.saveFile((ROOT / 'test' / 'log' / 'target_doc.ast'):string(), expect)
                autoFix(result, expect)
                error(('语法树不相等：%s\n%s'):format(type, buf))
            end
        end
    end
    Comment = function (buf)
        return function (target_comment)
            local state, err = parser.compile(buf, mode, 'Lua 5.4', {
                ['nonstandardSymbol'] = {
                    ['//'] = true,
                },
            })
            if not state then
                error(('语法树生成失败：%s'):format(err))
            end
            state.ast.state = nil
            local result = utility.dump(state.comms, myOption)
            local expect = utility.dump(target_comment, targetOption)
            if result ~= expect then
                fs.create_directories(ROOT / 'test' / 'log')
                utility.saveFile((ROOT / 'test' / 'log' / 'my_ast.ast'):string(), result)
                utility.saveFile((ROOT / 'test' / 'log' / 'target_ast.ast'):string(), expect)
                --autoFix(result, expect)
                error(('语法树不相等：%s\n%s'):format(type, buf))
            end
        end
    end
    require('parser_test.ast.' .. type)
end

test 'Nil'
test 'Boolean'
test 'String'
test 'Number'
test 'Exp'
test 'Action'
test 'Lua'
test 'Dirty'
test 'LuaDoc'
test 'Comment'
