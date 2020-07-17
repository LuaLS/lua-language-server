local lang = require 'language'
local config = require 'config'
local library = require 'core.library'
local buildGlobal = require 'vm.global'
local DiagnosticSeverity = require 'constant.DiagnosticSeverity'
local DiagnosticDefaultSeverity = require 'constant.DiagnosticDefaultSeverity'
local DiagnosticTag = require 'constant.DiagnosticTag'

local mt = {}
mt.__index = mt

local function isContainPos(obj, start, finish)
    if obj.start <= start and obj.finish >= finish then
        return true
    end
    return false
end

function mt:searchUnusedLocals(callback)
    self.vm:eachSource(function (source)
        local loc = source:bindLocal()
        if not loc then
            return
        end
        if loc:get 'emmy arg' then
            return
        end
        local name = loc:getName()
        if name == '_' or name == '_ENV' or name == '' then
            return
        end
        if source:action() ~= 'local' then
            return
        end
        if loc:get 'hide' then
            return
        end
        if loc.tags then
            for _, tag in ipairs(loc.tags) do
                if tag[1] == 'close' then
                    return
                end
            end
        end
        local used = loc:eachInfo(function (info)
            if info.type == 'get' then
                return true
            end
        end)
        if not used then
            callback(source.start, source.finish, name)
        end
    end)
end

function mt:searchUnusedFunctions(callback)
    self.vm:eachSource(function (source)
        local loc = source:bindLocal()
        if not loc then
            return
        end
        if loc:get 'emmy arg' then
            return
        end
        if source:action() ~= 'local' then
            return
        end
        if loc:get 'hide' then
            return
        end
        local used = loc:eachInfo(function (info)
            if info.type == 'get' then
                return true
            end
        end)
        if used then
            return
        end
        loc:eachInfo(function (info, src)
            if info.type == 'set' or info.type == 'local' then
                local v = src:bindValue()
                local func = v and v:getFunction()
                if func and func:getSource().uri == self.vm.uri then
                    callback(func:getSource().start, func:getSource().finish)
                end
            end
        end)
    end)
end

function mt:searchUndefinedGlobal(callback)
    local definedGlobal = {}
    for name in pairs(config.config.diagnostics.globals) do
        definedGlobal[name] = true
    end
    local envValue = buildGlobal(self.vm.lsp)
    envValue:eachInfo(function (info)
        if info.type == 'set child' then
            local name = info[1]
            definedGlobal[name] = true
        end
    end)
    self.vm:eachSource(function (source)
        if not source:get 'global' then
            return
        end
        local name = source:getName()
        if name == '' then
            return
        end
        local parent = source:get 'parent'
        if not parent then
            return
        end
        if not parent:get 'ENV' and not source:get 'in index' then
            return
        end
        if definedGlobal[name] then
            return
        end
        if type(name) ~= 'string' then
            return
        end
        callback(source.start, source.finish, name)
    end)
end

function mt:searchUnusedLabel(callback)
    self.vm:eachSource(function (source)
        local label = source:bindLabel()
        if not label then
            return
        end
        if source:action() ~= 'set' then
            return
        end
        local used = label:eachInfo(function (info)
            if info.type == 'get' then
                return true
            end
        end)
        if not used then
            callback(source.start, source.finish, label:getName())
        end
    end)
end

function mt:searchUnusedVararg(callback)
    self.vm:eachSource(function (source)
        local value = source:bindFunction()
        if not value then
            return
        end
        local func = value:getFunction()
        if not func then
            return
        end
        if func._dotsSource and not func._dotsLoad then
            callback(func._dotsSource.start, func._dotsSource.finish)
        end
    end)
end

local function isInString(vm, start, finish)
    return vm:eachSource(function (source)
        if source.type == 'string' and isContainPos(source, start, finish) then
            return true
        end
    end)
end

function mt:searchSpaces(callback)
    local vm = self.vm
    local lines = self.lines
    for i = 1, #lines do
        local line = lines:line(i)

        if line:find '^[ \t]+$' then
            local start, finish = lines:range(i)
            if isInString(vm, start, finish) then
                goto NEXT_LINE
            end
            callback(start, finish, lang.script.DIAG_LINE_ONLY_SPACE)
            goto NEXT_LINE
        end

        local pos = line:find '[ \t]+$'
        if pos then
            local start, finish = lines:range(i)
            start = start + pos - 1
            if isInString(vm, start, finish) then
                goto NEXT_LINE
            end
            callback(start, finish, lang.script.DIAG_LINE_POST_SPACE)
            goto NEXT_LINE
        end

        ::NEXT_LINE::
    end
end

function mt:searchRedefinition(callback)
    local used = {}
    local uri = self.uri
    self.vm:eachSource(function (source)
        local loc = source:bindLocal()
        if not loc then
            return
        end
        local shadow = loc:shadow()
        if not shadow then
            return
        end
        if used[shadow] then
            return
        end
        used[shadow] = true
        if loc:get 'hide' then
            return
        end
        local name = loc:getName()
        if name == '_' or name == '_ENV' or name == '' then
            return
        end
        local related = {}
        for i = 1, #shadow do
            related[i] = {
                start  = shadow[i]:getSource().start,
                finish = shadow[i]:getSource().finish,
                uri    = uri,
            }
        end
        for i = 2, #shadow do
            callback(shadow[i]:getSource().start, shadow[i]:getSource().finish, name, related)
        end
    end)
end

function mt:searchNewLineCall(callback)
    local lines = self.lines
    self.vm:eachSource(function (source)
        if source.type ~= 'simple' then
            return
        end
        for i = 1, #source - 1 do
            local callSource = source[i]
            local funcSource = source[i-1]
            if callSource.type ~= 'call' then
                goto CONTINUE
            end
            local callLine = lines:rowcol(callSource.start)
            local funcLine = lines:rowcol(funcSource.finish)
            if callLine > funcLine then
                callback(callSource.start, callSource.finish)
            end
            :: CONTINUE ::
        end
    end)
end

function mt:searchNewFieldCall(callback)
    local lines = self.lines
    self.vm:eachSource(function (source)
        if source.type ~= 'table' then
            return
        end
        for i = 1, #source do
            local field = source[i]
            if field.type == 'simple' then
                local callSource = field[#field]
                local funcSource = field[#field-1]
                local callLine = lines:rowcol(callSource.start)
                local funcLine = lines:rowcol(funcSource.finish)
                if callLine > funcLine then
                    callback(funcSource.start, callSource.finish
                        , lines.buf:sub(funcSource.start, funcSource.finish)
                        , lines.buf:sub(callSource.start, callSource.finish)
                    )
                end
            end
        end
    end)
end

function mt:searchRedundantParameters(callback)
    self.vm:eachSource(function (source)
        local args = source:bindCall()
        if not args then
            return
        end

        -- 回调函数不检查
        local simple = source:get 'simple'
        if simple and simple[2] == source then
            local loc = simple[1]:bindLocal()
            if loc then
                local source = loc:getSource()
                if source:get 'arg' then
                    return
                end
            end
        end

        local value = source:findCallFunction()
        if not value then
            return
        end

        local func = value:getFunction()
        -- 参数中有 ... ，不用再检查了
        if func:hasDots() then
            return
        end
        local max = #func.args
        local passed = #args
        -- function m.open() end
        -- m:open()
        -- 这种写法不算错
        if passed == 1 and source:get 'has object' then
            return
        end
        for i = max + 1, passed do
            local extra = args[i]
            callback(extra.start, extra.finish, max, passed)
        end
    end)
end

local opMap = {
    ['+']  = true,
    ['-']  = true,
    ['*']  = true,
    ['/']  = true,
    ['//'] = true,
    ['^']  = true,
    ['<<'] = true,
    ['>>'] = true,
    ['&']  = true,
    ['|']  = true,
    ['~']  = true,
    ['..'] = true,
}

local literalMap = {
    ['number']  = true,
    ['boolean'] = true,
    ['string']  = true,
    ['table']   = true,
}

function mt:searchAmbiguity1(callback)
    self.vm:eachSource(function (source)
        if source.op ~= 'or' then
            return
        end
        local first  = source[1]
        local second = source[2]
        -- a + (b or 0) --> (a + b) or 0
        do
            if opMap[first.op]
                and first.type ~= 'unary'
                and not second.op
                and literalMap[second.type]
                and not first.brackets
            then
                callback(source.start, source.finish, first.start, first.finish)
            end
        end
        -- (a or 0) + c --> a or (0 + c)
        do
            if opMap[second.op]
                and second.type ~= 'unary'
                and not first.op
                and literalMap[second[1].type]
                and not second.brackets
            then
                callback(source.start, source.finish, second.start, second.finish)
            end
        end
    end)
end

function mt:searchLowercaseGlobal(callback)
    local definedGlobal = {}
    for name in pairs(config.config.diagnostics.globals) do
        definedGlobal[name] = true
    end
    for name in pairs(library.global) do
        definedGlobal[name] = true
    end
    self.vm:eachSource(function (source)
        if source.type == 'name'
        and source:get 'parent'
        and not source:get 'simple'
        and not source:get 'table index'
        and source:action() == 'set'
        then
            local name = source[1]
            if definedGlobal[name] then
                return
            end
            local first = name:match '%w'
            if not first then
                return
            end
            if first:match '%l' then
                callback(source.start, source.finish)
            end
        end
    end)
end

function mt:searchDuplicateIndex(callback)
    self.vm:eachSource(function (source)
        if source.type ~= 'table' then
            return
        end
        local mark = {}
        for _, obj in ipairs(source) do
            if obj.type == 'pair' then
                local key = obj[1]
                local name
                if key.type == 'index' then
                    if key[1].type == 'string' then
                        name = key[1][1]
                    end
                elseif key.type == 'name' then
                    name = key[1]
                end
                if name then
                    if mark[name] then
                        mark[name][#mark[name]+1] = obj
                    else
                        mark[name] = { obj }
                    end
                end
            end
        end
        for name, defs in pairs(mark) do
            if #defs > 1 then
                local related = {}
                for i = 1, #defs do
                    related[i] = {
                        start  = defs[i][1].start,
                        finish = defs[i][2].finish,
                        uri    = self.uri,
                    }
                end
                for i = 1, #defs - 1 do
                    callback(defs[i][1].start, defs[i][2].finish, name, related, 'unused')
                end
                for i = #defs, #defs do
                    callback(defs[i][1].start, defs[i][1].finish, name, related, 'duplicate')
                end
            end
        end
    end)
end

function mt:searchDuplicateMethod(callback)
    local uri = self.uri
    local mark = {}
    local map = {}
    self.vm:eachSource(function (source)
        local parent = source:get 'parent'
        if not parent then
            return
        end
        if mark[parent] then
            return
        end
        mark[parent] = true
        local relates = {}
        parent:eachInfo(function (info, src)
            local k = info[1]
            if info.type ~= 'set child' then
                return
            end
            if type(k) ~= 'string' then
                return
            end
            if src.start == 0 then
                return
            end
            if not src:get 'object' then
                return
            end
            if map[src] then
                return
            end
            if not relates[k] then
                relates[k] = map[src] or {
                    name = k,
                }
            end
            map[src] = relates[k]
            relates[k][#relates[k]+1] = {
                start  = src.start,
                finish = src.finish,
                uri    = src.uri
            }
        end)
    end)
    for src, relate in pairs(map) do
        if #relate > 1 and src.uri == uri then
            callback(src.start, src.finish, relate.name, relate)
        end
    end
end

function mt:searchEmptyBlock(callback)
    self.vm:eachSource(function (source)
        -- 认为空repeat与空while是合法的
        -- 要去vm中激活source
        if source.type == 'if' then
            for _, block in ipairs(source) do
                if #block > 0 then
                    return
                end
            end
            callback(source.start, source.finish)
            return
        end
        if source.type == 'loop'
        or source.type == 'in'
        then
            if #source == 0 then
                callback(source.start, source.finish)
            end
            return
        end
    end)
end

function mt:searchRedundantValue(callback)
    self.vm:eachSource(function (source)
        if source.type == 'set' or source.type == 'local' then
            local args = source[1]
            local values = source[2]
            if not source[2] then
                return
            end
            local argCount, valueCount
            if args.type == 'list' then
                argCount = #args
            else
                argCount = 1
            end
            if values.type == 'list' then
                valueCount = #values
            else
                valueCount = 1
            end
            for i = argCount + 1, valueCount do
                local value = values[i]
                callback(value.start, value.finish, argCount, valueCount)
            end
        end
    end)
end

function mt:searchUndefinedEnvChild(callback)
    self.vm:eachSource(function (source)
        if not source:get 'global' then
            return
        end
        local name = source:getName()
        if name == '' then
            return
        end
        if source:get 'in index' then
            return
        end
        local parent = source:get 'parent'
        if parent:get 'ENV' then
            return
        end
        local value = source:bindValue()
        if not value then
            return
        end
        if value:getSource() == source then
            callback(source.start, source.finish, name)
        end
        return
    end)
end

function mt:searchGlobalInNilEnv(callback)
    self.vm:eachSource(function (source)
        if not source:get 'global' then
            return
        end
        local name = source:getName()
        if name == '' then
            return
        end
        local parentSource = source:get 'parent' :getSource()
        if parentSource and parentSource.type == 'nil' then
            callback(source.start, source.finish, {
                {
                    start  = parentSource.start,
                    finish = parentSource.finish,
                    uri    = self.uri,
                }
            })
        end
        return
    end)
end

function mt:checkEmmyClass(source, callback)
    local class = source:get 'emmy.class'
    if not class then
        return
    end
    -- class重复定义
    local name = class:getName()
    local related = {}
    self.vm.emmyMgr:eachClass(name, function (class)
        if class.type ~= 'emmy.class' and class.type ~= 'emmy.alias' then
            return
        end
        local src = class:getSource()
        if src ~= source then
            related[#related+1] = {
                start = src.start,
                finish = src.finish,
                uri = src.uri,
            }
        end
    end)
    if #related > 0 then
        callback(source.start, source.finish, lang.script.DIAG_DUPLICATE_CLASS ,related)
    end
    -- 继承不存在的class
    local extends = class.extends
    if not extends then
        return
    end
    local parent = self.vm.emmyMgr:eachClass(extends, function (parent)
        if parent.type == 'emmy.class' then
            return parent
        end
    end)
    if not parent then
        callback(source[2].start, source[2].finish, lang.script.DIAG_UNDEFINED_CLASS)
        return
    end

    -- class循环继承
    local related = {}
    local current = class
    for _ = 1, 10 do
        local extends = current.extends
        if not extends then
            break
        end
        related[#related+1] = {
            start = current:getSource().start,
            finish = current:getSource().finish,
            uri = current:getSource().uri,
        }
        current = self.vm.emmyMgr:eachClass(extends, function (parent)
            if parent.type == 'emmy.class' then
                return parent
            end
        end)
        if not current then
            break
        end
        if current:getName() == class:getName() then
            callback(source.start, source.finish, lang.script.DIAG_CYCLIC_EXTENDS, related)
            break
        end
    end
end

function mt:checkEmmyType(source, callback)
    for _, tpsource in ipairs(source) do
        -- TODO 临时决绝办法，重构后解决
        local name
        if tpsource.type == 'emmyArrayType' then
            name = tpsource[1][1]
        else
            name = tpsource[1]
        end
        local class = self.vm.emmyMgr:eachClass(name, function (class)
            if class.type == 'emmy.class' or class.type == 'emmy.alias' then
                return class
            end
        end)
        if not class then
            callback(tpsource.start, tpsource.finish, lang.script.DIAG_UNDEFINED_CLASS)
        end
    end
end

function mt:checkEmmyAlias(source, callback)
    local class = source:get 'emmy.alias'
    if not class then
        return
    end
    -- class重复定义
    local name = class:getName()
    local related = {}
    self.vm.emmyMgr:eachClass(name, function (class)
        if class.type ~= 'emmy.class' and class.type ~= 'emmy.alias' then
            return
        end
        local src = class:getSource()
        if src ~= source then
            related[#related+1] = {
                start = src.start,
                finish = src.finish,
                uri = src.uri,
            }
        end
    end)
    if #related > 0 then
        callback(source.start, source.finish, lang.script.DIAG_DUPLICATE_CLASS ,related)
    end
end

function mt:checkEmmyParam(source, callback, mark)
    local func = source:get 'emmy function'
    if not func then
        return
    end
    if mark[func] then
        return
    end
    mark[func] = true

    -- 检查不存在的参数
    local emmyParams = func:getEmmyParams()
    local funcParams = {}
    if func.args then
        for _, arg in ipairs(func.args) do
            funcParams[arg.name] = true
        end
    end
    for _, param in ipairs(emmyParams) do
        local name = param:getName()
        if not funcParams[name] then
            callback(param:getSource()[1].start, param:getSource()[1].finish, lang.script.DIAG_INEXISTENT_PARAM)
        end
    end

    -- 检查重复的param
    local lists = {}
    for _, param in ipairs(emmyParams) do
        local name = param:getName()
        if not lists[name] then
            lists[name] = {}
        end
        lists[name][#lists[name]+1] = param:getSource()[1]
    end
    for _, list in pairs(lists) do
        if #list > 1 then
            local related = {}
            for _, src in ipairs(list) do
                related[#related+1] = {
                    src.start,
                    src.finish,
                    src.uri,
                }
                callback(src.start, src.finish, lang.script.DIAG_DUPLICATE_PARAM)
            end
        end
    end
end

function mt:checkEmmyField(source, callback, mark)
    ---@type EmmyClass
    local class = source:get 'target class'
    -- 必须写在 class 的后面
    if not class then
        callback(source.start, source.finish, lang.script.DIAG_NEED_CLASS)
    end

    -- 检查重复的 field
    if class and not mark[class] then
        mark[class] = true
        local lists = {}
        class:eachField(function (field)
            local name = field:getName()
            if not lists[name] then
                lists[name] = {}
            end
            lists[name][#lists[name]+1] = field:getSource()[2]
        end)
        for _, list in pairs(lists) do
            if #list > 1 then
                local related = {}
                for _, src in ipairs(list) do
                    related[#related+1] = {
                        src.start,
                        src.finish,
                        src.uri,
                    }
                    callback(src.start, src.finish, lang.script.DIAG_DUPLICATE_FIELD)
                end
            end
        end
    end
end

function mt:searchEmmyLua(callback)
    local mark = {}
    self.vm:eachSource(function (source)
        if source.type == 'emmyClass' then
            self:checkEmmyClass(source, callback)
        elseif source.type == 'emmyType' then
            self:checkEmmyType(source, callback)
        elseif source.type == 'emmyAlias' then
            self:checkEmmyAlias(source, callback)
        elseif source.type == 'emmyParam' then
            self:checkEmmyParam(source, callback, mark)
        elseif source.type == 'emmyField' then
            self:checkEmmyField(source, callback, mark)
        end
    end)
end

function mt:searchSetConstLocal(callback)
    local mark = {}
    self.vm:eachSource(function (source)
        local loc = source:bindLocal()
        if not loc then
            return
        end
        if mark[loc] then
            return
        end
        mark[loc] = true
        if not loc.tags then
            return
        end
        local const
        for _, tag in ipairs(loc.tags) do
            if tag[1] == 'const' then
                const = true
                break
            end
        end
        if not const then
            return
        end
        loc:eachInfo(function (info, src)
            if info.type == 'set' then
                callback(src.start, src.finish)
            end
        end)
    end)
end

function mt:searchSetForState(callback)
    local locs = {}
    self.vm:eachSource(function (source)
        if source.type == 'loop' then
            locs[#locs+1] = source.arg:bindLocal()
        elseif source.type == 'in' then
            --self.vm:forList(source.arg, function (arg)
            --    locs[#locs+1] = arg:bindLocal()
            --end)
        end
    end)
    for i = 1, #locs do
        local loc = locs[i]
        loc:eachInfo(function (info, src)
            if info.type == 'set' then
                callback(src.start, src.finish)
            end
        end)
    end
end

function mt:doDiagnostics(func, code, callback)
    if config.config.diagnostics.disable[code] then
        return
    end
    local level = config.config.diagnostics.severity[code]
    if not DiagnosticSeverity[level] then
        level = DiagnosticDefaultSeverity[code]
    end
    func(self, function (start, finish, ...)
        local data = callback(...)
        data.code   = code
        data.start  = start
        data.finish = finish
        data.level  = data.level or DiagnosticSeverity[level]
        self.datas[#self.datas+1] = data
    end)
    if coroutine.isyieldable() then
        if self.vm:isRemoved() then
            coroutine.yield('stop')
        else
            coroutine.yield()
        end
    end
end

return function (vm, lines, uri)
    local session = setmetatable({
        vm = vm,
        lines = lines,
        uri = uri,
        datas = {},
    }, mt)

    -- 未使用的局部变量
    session:doDiagnostics(session.searchUnusedLocals, 'unused-local', function (key)
        return {
            message = lang.script('DIAG_UNUSED_LOCAL', key),
            tags = {DiagnosticTag.Unnecessary},
        }
    end)
    -- 未使用的函数
    session:doDiagnostics(session.searchUnusedFunctions, 'unused-function', function ()
        return {
            message = lang.script.DIAG_UNUSED_FUNCTION,
            tags = {DiagnosticTag.Unnecessary},
        }
    end)
    -- 读取未定义全局变量
    session:doDiagnostics(session.searchUndefinedGlobal, 'undefined-global', function (key)
        local message = lang.script('DIAG_UNDEF_GLOBAL', key)
        local otherVersion = library.other[key]
        local customLib = library.custom[key]
        if otherVersion then
            message = ('%s(%s)'):format(message, lang.script('DIAG_DEFINED_VERSION', table.concat(otherVersion, '/'), config.config.runtime.version))
        end
        if customLib then
            message = ('%s(%s)'):format(message, lang.script('DIAG_DEFINED_CUSTOM', table.concat(customLib, '/')))
        end
        return {
            message = message,
        }
    end)
    -- 未使用的Label
    session:doDiagnostics(session.searchUnusedLabel, 'unused-label', function (key)
        return {
            message = lang.script('DIAG_UNUSED_LABEL', key),
            tags = {DiagnosticTag.Unnecessary},
        }
    end)
    -- 未使用的不定参数
    session:doDiagnostics(session.searchUnusedVararg, 'unused-vararg', function ()
        return {
            message = lang.script.DIAG_UNUSED_VARARG,
            tags = {DiagnosticTag.Unnecessary},
        }
    end)
    -- 只有空格与制表符的行，以及后置空格
    session:doDiagnostics(session.searchSpaces, 'trailing-space', function (message)
        return {
            message = message,
        }
    end)
    -- 重定义局部变量
    session:doDiagnostics(session.searchRedefinition, 'redefined-local', function (key, related)
        return {
            message = lang.script('DIAG_REDEFINED_LOCAL', key),
            related = related,
        }
    end)
    -- 以括号开始的一行（可能被误解析为了上一行的call）
    session:doDiagnostics(session.searchNewLineCall, 'newline-call', function ()
        return {
            message = lang.script.DIAG_PREVIOUS_CALL,
        }
    end)
    -- 以字符串开始的field（可能被误解析为了上一行的call）
    session:doDiagnostics(session.searchNewFieldCall, 'newfield-call', function (func, call)
        return {
            message = lang.script('DIAG_PREFIELD_CALL', func, call),
        }
    end)
    -- 调用函数时的参数数量是否超过函数的接收数量
    session:doDiagnostics(session.searchRedundantParameters, 'redundant-parameter', function (max, passed)
        return {
            message = lang.script('DIAG_OVER_MAX_ARGS', max, passed),
            tags = {DiagnosticTag.Unnecessary},
        }
    end)
    -- x or 0 + 1
    session:doDiagnostics(session.searchAmbiguity1, 'ambiguity-1', function (start, finish)
        return {
            message = lang.script('DIAG_AMBIGUITY_1', lines.buf:sub(start, finish)),
        }
    end)
    -- 不允许定义首字母小写的全局变量（很可能是拼错或者漏删）
    session:doDiagnostics(session.searchLowercaseGlobal, 'lowercase-global', function ()
        return {
            message = lang.script.DIAG_LOWERCASE_GLOBAL,
        }
    end)
    -- 未定义的变量（重载了 `_ENV`）
    session:doDiagnostics(session.searchUndefinedEnvChild, 'undefined-env-child', function (key)
        if vm.envType == '_ENV' then
            return {
                message = lang.script('DIAG_UNDEF_ENV_CHILD', key),
            }
        else
            return {
                message = lang.script('DIAG_UNDEF_FENV_CHILD', key),
            }
        end
    end)
    -- 全局变量不可用（置空了 `_ENV`）
    session:doDiagnostics(session.searchGlobalInNilEnv, 'global-in-nil-env', function (related)
        if vm.envType == '_ENV' then
            return {
                message = lang.script.DIAG_GLOBAL_IN_NIL_ENV,
                related = related,
            }
        else
            return {
                message = lang.script.DIAG_GLOBAL_IN_NIL_FENV,
                related = related,
            }
        end
    end)
    -- 构建表时重复定义field
    session:doDiagnostics(session.searchDuplicateIndex, 'duplicate-index', function (key, related, type)
        if type == 'unused' then
            return {
                message = lang.script('DIAG_DUPLICATE_INDEX', key),
                related = related,
                level = DiagnosticSeverity.Hint,
                tags = {DiagnosticTag.Unnecessary},
            }
        else
            return {
                message = lang.script('DIAG_DUPLICATE_INDEX', key),
                related = related,
            }
        end
    end)
    -- 往表里面塞重复的method
    --session:doDiagnostics(session.searchDuplicateMethod, 'duplicate-method', function (key, related)
    --    return {
    --        message = lang.script('DIAG_DUPLICATE_METHOD', key),
    --        related = related,
    --    }
    --end)
    -- 空代码块
    session:doDiagnostics(session.searchEmptyBlock, 'empty-block', function ()
        return {
            message = lang.script.DIAG_EMPTY_BLOCK,
            tags = {DiagnosticTag.Unnecessary},
        }
    end)
    -- 多余的赋值
    session:doDiagnostics(session.searchRedundantValue, 'redundant-value', function (max, passed)
        return {
            message = lang.script('DIAG_OVER_MAX_VALUES', max, passed),
            tags = {DiagnosticTag.Unnecessary},
        }
    end)
    -- Emmy相关的检查
    session:doDiagnostics(session.searchEmmyLua, 'emmy-lua', function (message, related)
        return {
            message = message,
            related = related,
        }
    end)
    -- 检查给const变量赋值
    session:doDiagnostics(session.searchSetConstLocal, 'set-const', function ()
        return {
            message = lang.script.DIAG_SET_CONST
        }
    end)
    -- 检查修改for的内置变量
    session:doDiagnostics(session.searchSetForState, 'set-for-state', function ()
        return {
            message = lang.script.DIAG_SET_FOR_STATE,
        }
    end)
    return session.datas
end
