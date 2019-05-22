local findSource = require 'core.find_source'
local getFunctionHover = require 'core.hover.function'
local getFunctionHoverAsLib = require 'core.hover.lib_function'
local getFunctionHoverAsEmmy = require 'core.hover.emmy_function'
local sourceMgr = require 'vm.source'
local config = require 'config'
local matchKey = require 'core.matchKey'
local parser = require 'parser'
local State

local CompletionItemKind = {
    Text = 1,
    Method = 2,
    Function = 3,
    Constructor = 4,
    Field = 5,
    Variable = 6,
    Class = 7,
    Interface = 8,
    Module = 9,
    Property = 10,
    Unit = 11,
    Value = 12,
    Enum = 13,
    Keyword = 14,
    Snippet = 15,
    Color = 16,
    File = 17,
    Reference = 18,
    Folder = 19,
    EnumMember = 20,
    Constant = 21,
    Struct = 22,
    Event = 23,
    Operator = 24,
    TypeParameter = 25,
}

local KEYS = {'and', 'break', 'do', 'else', 'elseif', 'end', 'false', 'for', 'function', 'goto', 'if', 'in', 'local', 'nil', 'not', 'or', 'repeat', 'return', 'then', 'true', 'until', 'while'}
local KEYMAP = {}
for _, k in ipairs(KEYS) do
    KEYMAP[k] = true
end

local EMMY_KEYWORD = {'class', 'type', 'alias', 'param', 'return', 'field', 'generic', 'vararg', 'language', 'see'}

local function getDucumentation(name, value)
    if value:getType() == 'function' then
        local lib = value:getLib()
        local hover
        if lib then
            hover = getFunctionHoverAsLib(name, lib)
        else
            local emmy = value:getEmmy()
            if emmy and emmy.type == 'emmy.functionType' then
                hover = getFunctionHoverAsEmmy(name, emmy)
            else
                hover = getFunctionHover(name, value:getFunction())
            end
        end
        if not hover then
            return nil
        end
        local text = ([[
```lua
%s
```
%s
```lua
%s
```
%s
]]):format(hover.label or '', hover.description or '', hover.enum or '', hover.doc or '')
        return {
            kind = 'markdown',
            value = text,
        }
    end
    return nil
end

local function getDetail(value)
    local literal = value:getLiteral()
    local tp = type(literal)
    if tp == 'boolean' then
        return ('= %q'):format(literal)
    elseif tp == 'string' then
        return ('= %q'):format(literal)
    elseif tp == 'number' then
        if math.type(literal) == 'integer' then
            return ('= %q'):format(literal)
        else
            local str = ('= %.16f'):format(literal)
            local dot = str:find('.', 1, true)
            local suffix = str:find('[0]+$', dot + 2)
            if suffix then
                return str:sub(1, suffix - 1)
            else
                return str
            end
        end
    end
    return nil
end

local function getKind(cata, value)
    if value:getType() == 'function' then
        local func = value:getFunction()
        if func and func:getObject() then
            return CompletionItemKind.Method
        else
            return CompletionItemKind.Function
        end
    end
    if cata == 'field' then
        local literal = value:getLiteral()
        local tp = type(literal)
        if tp == 'number' or tp == 'integer' or tp == 'string' then
            return CompletionItemKind.Enum
        end
    end
    return nil
end

local function getValueData(cata, name, value, pos, source)
    local data = {
        documentation = getDucumentation(name, value),
        detail = getDetail(value),
        kind = getKind(cata, value),
    }
    if cata == 'field' then
        if not parser:grammar(name, 'Name') then
            if source:get 'simple' and source:get 'simple' [1] ~= source then
                data.textEdit = {
                    start = pos + 1,
                    finish = pos,
                    newText = ('[%q]'):format(name),
                }
                data.additionalTextEdits = {
                    {
                        start = pos,
                        finish = pos,
                        newText = '',
                    }
                }
            else
                data.textEdit = {
                    start = pos + 1,
                    finish = pos,
                    newText = ('_ENV[%q]'):format(name),
                }
                data.additionalTextEdits = {
                    {
                        start = pos,
                        finish = pos,
                        newText = '',
                    }
                }
            end
        end
    end
    return data
end

local function searchLocals(vm, source, word, callback, pos)
    vm:eachSource(function (src)
        local loc = src:bindLocal()
        if not loc then
            return
        end

        if      src.start <= source.start
            and loc:close() >= source.finish
            and matchKey(word, loc:getName())
        then
            callback(loc:getName(), src, CompletionItemKind.Variable, getValueData('local', loc:getName(), loc:getValue(), pos, source))
        end
    end)
end

local function sortPairs(t)
    local keys = {}
    for k in pairs(t) do
        keys[#keys+1] = k
    end
    table.sort(keys)
    local i = 0
    return function ()
        i = i + 1
        local k = keys[i]
        return k, t[k]
    end
end

local function searchFieldsByInfo(parent, word, source, map)
    parent:eachInfo(function (info, src)
        local k = info[1]
        if src == source then
            return
        end
        if map[k] then
            return
        end
        if KEYMAP[k] then
            return
        end
        if info.type ~= 'set child' and info.type ~= 'get child' then
            return
        end
        if type(k) ~= 'string' then
            return
        end
        local v = parent:getChild(k)
        if not v then
            return
        end
        if source:get 'object' and v:getType() ~= 'function' then
            return
        end
        if matchKey(word, k) then
            map[k] = v
        end
    end)
end

local function searchFieldsByChild(parent, word, source, map)
    parent:eachChild(function (k, v)
        if map[k] then
            return
        end
        if KEYMAP[k] then
            return
        end
        if not v:getLib() then
            return
        end
        if type(k) ~= 'string' then
            return
        end
        if source:get 'object' and v:getType() ~= 'function' then
            return
        end
        if matchKey(word, k) then
            map[k] = v
        end
    end)
end

---@param vm VM
local function searchFields(vm, source, word, callback, pos)
    local parent = source:get 'parent' or vm.env:getValue()
    if not parent then
        return
    end
    local map = {}
    local current = parent
    for _ = 1, 3 do
        searchFieldsByInfo(current, word, source, map)
        current = current:getMetaMethod('__index')
        if not current then
            break
        end
    end
    searchFieldsByChild(parent, word, source, map)
    for k, v in sortPairs(map) do
        callback(k, nil, CompletionItemKind.Field, getValueData('field', k, v, pos, source))
    end
end

local function searchIndex(vm, source, word, callback)
    vm:eachSource(function (src)
        if src:get 'table index' then
            if matchKey(word, src[1]) then
                callback(src[1], src, CompletionItemKind.Property)
            end
        end
    end)
end

local function searchCloseGlobal(vm, start, finish, word, callback)
    vm:eachSource(function (src)
        if      (src:get 'global' or src:bindLocal())
            and src.start >= start
            and src.finish <= finish
        then
            if matchKey(word, src[1]) then
                callback(src[1], src, CompletionItemKind.Variable)
            end
        end
    end)
end

local function searchParams(vm, source, func, word, callback)
    if not func then
        return
    end
    ---@type emmyFunction
    local emmyParams = func:getEmmyParams()
    if not emmyParams then
        return
    end
    if #emmyParams > 1 then
        if not func.args
        or not func.args[1]
        or func.args[1]:getSource() == source then
            if matchKey(word, source and source[1] or '') then
                local names = {}
                for _, param in ipairs(emmyParams) do
                    local name = param:getName()
                    names[#names+1] = name
                end
                callback(table.concat(names, ', '), nil, CompletionItemKind.Snippet)
            end
        end
    end
    for _, param in ipairs(emmyParams) do
        local name = param:getName()
        if matchKey(word, name) then
            callback(name, param:getSource(), CompletionItemKind.Interface)
        end
    end
end

local function searchKeyWords(vm, source, word, callback)
    for _, key in ipairs(KEYS) do
        if matchKey(word, key) then
            callback(key, nil, CompletionItemKind.Keyword)
        end
    end
end

local function searchGlobals(vm, source, word, callback, pos)
    local global = vm.env:getValue()
    local map = {}
    local current = global
    for _ = 1, 3 do
        searchFieldsByInfo(current, word, source, map)
        current = current:getMetaMethod('__index')
        if not current then
            break
        end
    end
    searchFieldsByChild(global, word, source, map)
    for k, v in sortPairs(map) do
        callback(k, nil, CompletionItemKind.Field, getValueData('field', k, v, pos, source))
    end
end

local function searchAsGlobal(vm, source, word, callback, pos)
    if word == '' then
        return
    end
    searchLocals(vm, source, word, callback, pos)
    searchFields(vm, source, word, callback, pos)
    searchKeyWords(vm, source, word, callback)
end

local function searchAsKeyowrd(vm, source, word, callback, pos)
    searchLocals(vm, source, word, callback, pos)
    searchGlobals(vm, source, word, callback, pos)
    searchKeyWords(vm, source, word, callback)
end

local function searchAsSuffix(vm, source, word, callback, pos)
    searchFields(vm, source, word, callback, pos)
end

local function searchAsIndex(vm, source, word, callback, pos)
    searchLocals(vm, source, word, callback, pos)
    searchIndex(vm, source, word, callback)
    searchFields(vm, source, word, callback, pos)
end

local function searchAsLocal(vm, source, word, callback)
    local loc = source:bindLocal()
    if loc then
        local close = loc:close()
        -- 因为闭包的关系落在局部变量finish到close范围内的全局变量一定能访问到该局部变量
        searchCloseGlobal(vm, source.finish, close, word, callback)
    end
    -- 特殊支持 local function
    if matchKey(word, 'function') then
        callback('function', nil, CompletionItemKind.Keyword)
    end
    -- 特殊支持 local *toclose
    if word == '' and config.config.runtime.version == 'Lua 5.4' then
        callback('*toclose', nil, CompletionItemKind.Keyword)
    end
end

local function searchAsArg(vm, source, word, callback)
    searchParams(vm, source, source:get 'arg', word, callback)

    local loc = source:bindLocal()
    if loc then
        local close = loc:close()
        -- 因为闭包的关系落在局部变量finish到close范围内的全局变量一定能访问到该局部变量
        searchCloseGlobal(vm, source.finish, close, word, callback)
        return
    end
end

local function searchFunction(vm, source, word, pos, callback)
    if pos >= source.argStart and pos <= source.argFinish then
        searchParams(vm, nil, source:bindFunction():getFunction(), word, callback)
        searchCloseGlobal(vm, source.argFinish, source.finish, word, callback)
    end
end

local function searchEmmyKeyword(vm, source, word, callback)
    for _, kw in ipairs(EMMY_KEYWORD) do
        if matchKey(word, kw) then
            callback(kw, nil, CompletionItemKind.Keyword)
        end
    end
end

local function searchEmmyClass(vm, source, word, callback)
    local classes = {}
    vm.emmyMgr:eachClass(function (class)
        if class.type == 'emmy.class' or class.type == 'emmy.alias' then
            if matchKey(word, class:getName()) then
                classes[#classes+1] = class
            end
        end
    end)
    table.sort(classes, function (a, b)
        return a:getName() < b:getName()
    end)
    for _, class in ipairs(classes) do
        callback(class:getName(), class:getSource(), CompletionItemKind.Class)
    end
end

local function searchEmmyFunctionParam(vm, source, word, callback)
    local func = source:get 'emmy function'
    if not func.args then
        return
    end
    if #func.args > 1 and matchKey(word, func.args[1].name) then
        local list = {}
        local args = {}
        for i, arg in ipairs(func.args) do
            if func:getObject() and i == 1 then
                goto NEXT
            end
            args[#args+1] = arg.name
            if #list == 0 then
                list[#list+1] = ('%s any'):format(arg.name)
            else
                list[#list+1] = ('---@param %s any'):format(arg.name)
            end
            :: NEXT ::
        end
        callback(('%s'):format(table.concat(args, ', ')), nil, CompletionItemKind.Snippet, {
            insertText = table.concat(list, '\n')
        })
    end
    for i, arg in ipairs(func.args) do
        if func:getObject() and i == 1 then
            goto NEXT
        end
        if matchKey(word, arg.name) then
            callback(arg.name, nil, CompletionItemKind.Interface)
        end
        :: NEXT ::
    end
end

local function searchSource(vm, source, word, callback, pos)
    if source.type == 'keyword' then
        searchAsKeyowrd(vm, source, word, callback, pos)
        return
    end
    if source:get 'table index' then
        searchAsIndex(vm, source, word, callback, pos)
        return
    end
    if source:get 'arg' then
        searchAsArg(vm, source, word, callback)
        return
    end
    if source:get 'global' then
        searchAsGlobal(vm, source, word, callback, pos)
        return
    end
    if source:action() == 'local' then
        searchAsLocal(vm, source, word, callback)
        return
    end
    if source:bindLocal() then
        searchAsGlobal(vm, source, word, callback, pos)
        return
    end
    if source:get 'simple'
    and (source.type == 'name' or source.type == '.' or source.type == ':') then
        searchAsSuffix(vm, source, word, callback, pos)
        return
    end
    if source:bindFunction() then
        searchFunction(vm, source, word, pos, callback)
        return
    end
    if source.type == 'emmyIncomplete' then
        searchEmmyKeyword(vm, source, word, callback)
        State.ignoreText = true
        return
    end
    if source:get 'emmy class' then
        searchEmmyClass(vm, source, word, callback)
        State.ignoreText = true
        return
    end
    if source:get 'emmy function' then
        searchEmmyFunctionParam(vm, source, word, callback)
        State.ignoreText = true
        return
    end
end

local function buildTextEdit(start, finish, str, quo)
    local text, lquo, rquo, label, filterText
    if quo == '"' then
        label = str
        filterText = str
        text = str:gsub('\r', '\\r'):gsub('\n', '\\n'):gsub('"', '\\"')
        lquo = quo
        rquo = quo
    elseif quo == "'" then
        label = str
        filterText = str
        text = str:gsub('\r', '\\r'):gsub('\n', '\\n'):gsub("'", "\\'")
        lquo = quo
        rquo = quo
    elseif quo == nil then
        quo = ''
        text = str:gsub('\r', '\\r'):gsub('\n', '\\n'):gsub('"', '\\"')
        lquo = quo
        rquo = quo
        label = '"' .. text .. '"'
        filterText = label
    else
        label = str
        filterText = str
        lquo = quo
        rquo = ']' .. lquo:sub(2, -2) .. ']'
        while str:find(rquo, 1, true) do
            lquo = '[=' .. quo:sub(2)
            rquo = ']' .. lquo:sub(2, -2) .. ']'
        end
        text = str
    end
    return {
        label = label,
        filterText = filterText,
        textEdit = {
            start = start + #quo,
            finish = finish - #quo,
            newText = text,
        },
        additionalTextEdits = {
            {
                start = start,
                finish = start + #quo - 1,
                newText = lquo,
            },
            {
                start = finish - #quo + 1,
                finish = finish,
                newText = rquo,
            },
        }
    }
end

local function searchInRequire(vm, select, source, callback)
    if select ~= 1 then
        return
    end
    if not vm.lsp or not vm.lsp.workspace then
        return
    end
    if source.type ~= 'string' then
        return
    end
    local list, map = vm.lsp.workspace:matchPath(vm.uri, source[1])
    if not list then
        return
    end
    for _, str in ipairs(list) do
        local data = buildTextEdit(source.start, source.finish, str, source[2])
        data.documentation = map[str]
        callback(str, nil, CompletionItemKind.Reference, data)
    end
end

local function searchEnumAsLib(vm, source, word, callback, pos, args, lib)
    local select = #args + 1
    for i, arg in ipairs(args) do
        if arg.start <= pos and arg.finish >= pos then
            select = i
            break
        end
    end

    -- 根据参数位置找枚举值
    if lib.args and lib.enums then
        local arg = lib.args[select]
        local name = arg and arg.name
        for _, enum in ipairs(lib.enums) do
            if enum.name and enum.name == name and enum.enum then
                if matchKey(word, enum.enum) then
                    local strSource = parser:ast(tostring(enum.enum), 'String')
                    if strSource then
                        if source.type == 'string' then
                            local data = buildTextEdit(source.start, source.finish, strSource[1], source[2])
                            data.documentation = enum.description
                            callback(enum.enum, nil, CompletionItemKind.EnumMember, data)
                        else
                            local data = buildTextEdit(source.start, source.finish, strSource[1], nil)
                            data.documentation = enum.description
                            callback(enum.enum, nil, CompletionItemKind.EnumMember, data)
                        end
                    end
                end
            end
        end
    end

    -- 搜索特殊函数
    if lib.special == 'require' then
        searchInRequire(vm, select, source, callback)
    end
end

local function searchEnumAsEmmyParams(vm, source, word, callback, pos, args, func)
    local select = #args + 1
    for i, arg in ipairs(args) do
        if arg.start <= pos and arg.finish >= pos then
            select = i
            break
        end
    end

    local param = func:findEmmyParamByIndex(select)
    if not param then
        return
    end

    param:eachEnum(function (enum)
        if matchKey(word, enum) then
            callback(enum, nil, CompletionItemKind.EnumMember, {
                label = enum,
            })
        end
    end)
end

local function getSelect(args, pos)
    if not args then
        return 1
    end
    for i, arg in ipairs(args) do
        if arg.start <= pos and arg.finish >= pos - 1 then
            return i
        end
    end
    return #args + 1
end

local function isInFunctionOrTable(call, pos)
    local args = call:bindCall()
    if not args then
        return false
    end
    local select = getSelect(args, pos)
    local arg = args[select]
    if not arg then
        return false
    end
    if arg.type == 'function' or arg.type == 'table' then
        return true
    end
    return false
end

local function searchCallArg(vm, source, word, callback, pos)
    local results = {}
    vm:eachSource(function (src)
        if      src.type == 'call'
            and src.start <= pos
            and src.finish >= pos
        then
            results[#results+1] = src
        end
    end)
    if #results == 0 then
        return nil
    end
    -- 可能处于 'func1(func2(' 的嵌套中，将最近的call放到最前面
    table.sort(results, function (a, b)
        return a.start > b.start
    end)
    local call = results[1]
    if isInFunctionOrTable(call, pos) then
        return
    end

    local args = call:bindCall()
    if not args then
        return
    end

    local value = call:findCallFunction()
    if not value then
        return
    end

    local lib = value:getLib()
    if lib then
        searchEnumAsLib(vm, source, word, callback, pos, args, lib)
        return
    end

    ---@type emmyFunction
    local func = value:getFunction()
    if func then
        searchEnumAsEmmyParams(vm, source, word, callback, pos, args, func)
        return
    end
end

local function searchAllWords(vm, source, word, callback, pos)
    if word == '' then
        return
    end
    if source.type == 'string' then
        return
    end
    vm:eachSource(function (src)
        if      src.type == 'name'
            and not (src.start <= pos and src.finish >= pos)
            and matchKey(word, src[1])
        then
            callback(src[1], src, CompletionItemKind.Text)
        end
    end)
end

local function searchSpecialHashSign(vm, pos, text, callback)
    -- 尝试 XXX[#XXX+1]
    -- 1. 搜索 []
    local index
    vm:eachSource(function (src)
        if      src.type == 'index'
            and src.start <= pos
            and src.finish >= pos
        then
            index = src
            return true
        end
    end)
    if not index then
        return nil
    end
    -- 2. [] 内部只能有一个 #
    local inside = index[1]
    if not inside then
        return nil
    end
    if inside.op ~= '#' then
        return nil
    end
    -- 3. [] 左侧必须是 simple ,且index 是 simple 的最后一项
    local simple = index:get 'simple'
    if not simple then
        return nil
    end
    if simple[#simple] ~= index then
        return nil
    end
    local chars = text:sub(simple.start, simple[#simple-1].finish)
    -- 4. 创建代码片段
    if simple:get 'as action' then
        local label = chars .. '+1'
        callback(label, nil, CompletionItemKind.Snippet, {
            textEdit = {
                start = inside.start + 1,
                finish = index.finish,
                newText = ('%s] = '):format(label),
            },
        })
    else
        local label = chars
        callback(label, nil, CompletionItemKind.Snippet, {
            textEdit = {
                start = inside.start + 1,
                finish = index.finish,
                newText = ('%s]'):format(label),
            },
        })
    end
end

local function searchSpecial(vm, source, word, callback, pos, text)
    searchSpecialHashSign(vm, pos, text, callback)
end

local function makeList(source, pos, word)
    local list = {}
    local mark = {}
    return function (name, src, kind, data)
        if src == source then
            return
        end
        if word == name then
            if src and src.start <= pos and src.finish >= pos then
                return
            end
        end
        if mark[name] then
            return
        end
        mark[name] = true
        if not data then
            data = {}
        end
        if not data.label then
            data.label = name
        end
        if not data.kind then
            data.kind = kind
        end
        list[#list+1] = data
    end, list
end

local function searchToclose(text, source, word, callback)
    local pos = source.start
    if text:sub(pos-1, pos-1) ~= '*' then
        return false
    end
    if not matchKey(word, 'toclose') then
        return false
    end
    for i = pos-1, 1, -1 do
        if text:sub(i, i):match '[^%s%c]' then
            if text:sub(i - #'local' + 1, i) == 'local' then
                callback('toclose', nil, CompletionItemKind.Keyword)
                return true
            else
                return false
            end
        end
    end
    return false
end

local function keywordSource(vm, word, pos)
    if not KEYMAP[word] then
        return nil
    end
    return vm:instantSource {
        type   = 'keyword',
        start  = pos,
        finish = pos + #word - 1,
        [1]    = word,
    }
end

local function findStartPos(pos, buf)
    local res = nil
    for i = pos, 1, -1 do
        local c = buf:sub(i, i)
        if c:find '[%w_]' then
            res = i
        else
            break
        end
    end
    if not res then
        for i = pos, 1, -1 do
            local c = buf:sub(i, i)
            if c == '.' or c == ':' or c == '|' or c == '(' then
                res = i
                break
            elseif c == '#' or c == '@' then
                res = i + 1
                break
            elseif c:find '[%s%c]' then
            else
                break
            end
        end
    end
    if not res then
        return pos
    end
    return res
end

local function findWord(position, text)
    local word = text
    for i = position, 1, -1 do
        local c = text:sub(i, i)
        if not c:find '[%w_]' then
            word = text:sub(i+1, position)
            break
        end
    end
    return word:match('^([%w_]*)')
end

local function getSource(vm, pos, text, filter)
    local word = findWord(pos, text)
    local source = keywordSource(vm, word, pos)
    if source then
        return source, pos, word
    end
    source = findSource(vm, pos, filter)
    if source then
        return source, pos, word
    end
    pos = findStartPos(pos, text)
    source = findSource(vm, pos, filter)
    return source, pos, word
end

return function (vm, text, pos, oldText)
    local filter = {
        ['name']           = true,
        ['string']         = true,
        ['.']              = true,
        [':']              = true,
        ['emmyName']       = true,
        ['emmyIncomplete'] = true,
        ['call']           = true,
        ['function']       = true,
        ['localfunction']  = true,
    }
    local source, pos, word = getSource(vm, pos, text, filter)
    if not source then
        return nil
    end
    if oldText then
        local oldWord = oldText:sub(source.start, source.finish)
        if word:sub(1, #oldWord) ~= oldWord then
            return nil
        end
    end
    State = {}
    local callback, list = makeList(source, pos, word)
    if searchToclose(text, source, word, callback) then
        return list
    end
    searchSpecial(vm, source, word, callback, pos, text)
    searchCallArg(vm, source, word, callback, pos)
    searchSource(vm, source, word, callback, pos)
    if not oldText or #list > 0 then
        if not State.ignoreText then
            searchAllWords(vm, source, word, callback, pos)
        end
    end

    if #list == 0 then
        return nil
    end

    return list
end
