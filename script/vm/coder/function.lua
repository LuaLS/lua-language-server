---@class Coder
local M = Class 'Coder'

local function makeVarargListCode(coder, overloads)
    local params = {}
    local min
    local max = 0
    for _, overload in ipairs(overloads) do
        local value = overload.value
        if value and value.params then
            local count = #value.params
            if min == nil or count < min then
                min = count
            end
            if count > max then
                max = count
            end
            for i, param in ipairs(value.params) do
                if param.name.id == '...' then
                    break
                end
                if param.value and not coder.compiled[param.value] then
                    coder:compile(param.value)
                end
                local typeCode = param.value and coder:getKey(param.value) or 'rt.ANY'
                params[i] = params[i] and ('%s | %s'):format(params[i], typeCode) or typeCode
            end
        end
    end
    if min == nil then
        return nil
    end
    for i = 1, max do
        params[i] = params[i] or 'rt.NIL'
    end
    return ('rt.list({%s}, %d, %d)'):format(table.concat(params, ', '), min, max)
end

local function makeVarargTableCode(coder, overloads)
    local tables = {}
    for _, overload in ipairs(overloads) do
        local value = overload.value
        if value and value.params then
            local fields = {}
            local count = #value.params
            local valid = true
            for i, param in ipairs(value.params) do
                if param.name.id == '...' or param.optional then
                    valid = false
                    break
                end
                if param.value and not coder.compiled[param.value] then
                    coder:compile(param.value)
                end
                fields[#fields + 1] = ('addField(rt.field(rt.value(%d), %s))'):format(
                    i,
                    param.value and coder:getKey(param.value) or 'rt.ANY'
                )
            end
            if valid then
                fields[#fields + 1] = ('addField(rt.field(rt.value("n"), rt.value(%d)))'):format(count)
                tables[#tables + 1] = 'rt.table():' .. table.concat(fields, ':')
            end
        end
    end
    if #tables == 0 then
        return nil
    end
    return table.concat(tables, ' | ')
end

---@package
---@param source LuaParser.Node.Base
---@param kind string
---@return LuaParser.Node.Cat[]?
function M:findNearedCats(source, kind)
    local catGroup = self:getCatGroup(source)
    if not catGroup then
        return nil
    end
    local results = {}
    for _, catState in ipairs(catGroup) do
        local cat = catState.value
        if not cat then
            goto continue
        end
        if cat.kind == kind then
            results[#results+1] = cat
        end
        ::continue::
    end
    if #results == 0 then
        return nil
    end
    return results
end

---@param param LuaParser.Node.Param
---@return LuaParser.Node.CatStateParam?
function M:findMatchedCatParam(param)
    local params = self:findNearedCats(param, 'catstateparam')
    if not params then
        return nil
    end
    ---@cast params LuaParser.Node.CatStateParam[]
    for _, catParam in ipairs(params) do
        if catParam.key.id == param.id then
            return catParam
        end
    end
    return nil
end

ls.vm.registerCoderProvider('function', function (coder, source)
    ---@cast source LuaParser.Node.Function

    coder:withIndentation(function ()
        ---@type LuaParser.Node.CatStateOverload[]?
        local overloads = coder:findNearedCats(source, 'catstateoverload')

        local funcKey = overloads
                    and coder:getCustomKey('origin|' .. source.uniqueKey)
                    or  coder:getKey(source)
        coder:addLine('{key} = rt.func()' % {
            key = funcKey,
        })
        coder:addLine('{key}:setLocation {location}' % {
            key      = funcKey,
            location = coder:makeLocationCode(source),
        })

        local catGroup = coder:getCatGroup(source)
        if catGroup then
            for _, cat in ipairs(catGroup) do
                if cat.subtype == 'async' then
                    coder:addLine('{key}:setAsync()' % {
                        key = funcKey,
                    })
                    break
                end
            end
        end

        -- function name() end 翻译为 name = function() end：
        -- 先注册名字（建立 key），但 appendVar 要推迟到函数体构建之后，
        -- 保证 flow 中 ref（函数体内对名字的引用）先于 var（名字赋值）出现。
        local tracer = coder:getTracer()
        if source.name and tracer then
            tracer:beginDeferVar()
        end

        if source.name then
            coder:withIndentation(function ()
                coder:addLine('')
                -- if source.name.last then
                --     coder:compile(source.name.last)
                -- end
                coder:compile(source.name)
                coder:addLine('{func}:setName({nameKey})' % {
                    func    = funcKey,
                    nameKey = coder:getKey(source.name),
                })
            end, 'function name --')
        end

        ---@type LuaParser.Node.CatStateGeneric[]?
        local typeParams = coder:findNearedCats(source, 'catstategeneric')
        if typeParams then
            coder:withIndentation(function ()
                for _, cat in ipairs(typeParams) do
                    for _, param in ipairs(cat.typeParams) do
                        coder:addLine('-- ' .. param.code)
                        coder:addLine('{func}:addTypeParam({param})' % {
                            func  = funcKey,
                            param = coder:getKey(param),
                        })
                    end
                end
            end, 'function type params --')
        end

        if source.params then
            coder:withIndentation(function ()
                for i, param in ipairs(source.params) do
                    local catParam = coder:findMatchedCatParam(param)
                    coder:addLine('-- ' .. param.code)
                    coder:compile(param)
                    if param.varargLocal then
                        local varargLocal = assert(param.varargLocal)
                        local varargKey = coder:getKey(varargLocal)
                        coder:addLine('{key} = rt.variable {name%q}' % {
                            key  = varargKey,
                            name = varargLocal.id,
                        })
                        coder:addLine('{key}:setLocation {location}' % {
                            key      = varargKey,
                            location = coder:makeLocationCode(varargLocal),
                        })
                        coder:getTracer():appendVar(varargLocal)
                        local varargTable = overloads and makeVarargTableCode(coder, overloads)
                        coder:addLine('{key}:addType({type})' % {
                            key  = varargKey,
                            type = varargTable or 'rt.array(rt.ANY) & rt.table():addField(rt.field(rt.value("n"), rt.INTEGER))',
                        })
                    end
                    if param.id == '...' and overloads then
                        local varargList = makeVarargListCode(coder, overloads)
                        if varargList then
                            coder:addLine('{key}:setVarargList({list})' % {
                                key  = coder:getKey(param),
                                list = varargList,
                            })
                        end
                    end
                    coder:addLine('{funcKey}:addParamDef({paramKey%q}, {paramNode}, {optional%q}, {varargName})' % {
                        funcKey    = funcKey,
                        paramKey   = param.id,
                        paramNode  = coder:getKey(param),
                        optional   = catParam and catParam.optional or nil,
                        varargName = param.varargName and ('%q'):format(param.varargName) or 'nil',
                    })
                end
            end, 'function params --')
        end

        ---@type LuaParser.Node.CatStateReturn[]?
        local returns = coder:findNearedCats(source, 'catstatereturn')
        if returns then
            coder:withIndentation(function ()
                for _, cat in ipairs(returns) do
                    local returnItems = cat.returns
                    if returnItems and #returnItems > 0 then
                        coder:addLine('-- ' .. cat.code)
                        for _, ret in ipairs(returnItems) do
                            local returnType
                            if ret.spread then
                                returnType = 'rt.spread({value})' % {
                                    value = coder:getKey(ret.value),
                                }
                            else
                                returnType = coder:getKey(ret.value)
                            end
                            coder:addLine('{funcKey}:addReturnDef({returnKey}, {returnType})' % {
                                funcKey    = funcKey,
                                returnKey  = ret.key and ('%q'):format(ret.key.id) or 'nil',
                                returnType = returnType,
                            })
                        end
                    elseif cat.value then
                        coder:addLine('-- ' .. cat.code)
                        coder:addLine('{funcKey}:addReturnDef({returnKey}, {returnType})' % {
                            funcKey    = funcKey,
                            returnKey  = cat.key and ('%q'):format(cat.key.id) or 'nil',
                            returnType = coder:getKey(cat.value),
                        })
                    end
                end
            end, 'function returns --')
        end

        ---@type LuaParser.Node.CatStateNarrow[]?
        local narrows = coder:findNearedCats(source, 'catstatenarrow')
        if narrows then
            coder:withIndentation(function ()
                for _, cat in ipairs(narrows) do
                    coder:addLine('-- ' .. cat.code)
                    coder:addLine('{funcKey}:addNarrowDef({paramKey%q}, {narrowType})' % {
                        funcKey    = funcKey,
                        paramKey   = cat.key.id,
                        narrowType = cat.type and coder:getKey(cat.type) or 'nil',
                    })
                end
            end, 'function narrows --')
        end

        if #source.childs > 0 then
            coder:withIndentation(function ()
                coder:pushBlock()
                coder:startTracer(source)
                coder:setBlockKV('function', funcKey)
                for _, child in ipairs(source.childs) do
                    coder:compile(child)
                    coder:addLine('')
                end
                coder:finishTracer()
                coder:popBlock()
            end, 'function body --')
        end

        if overloads then
            local overloadKeys = { funcKey }

            for _, overload in ipairs(overloads) do
                local overloadKey = coder:getKey(overload.value)
                overloadKeys[#overloadKeys+1] = overloadKey
                if source.name then
                    coder:addLine('{overloadKey}:setName({nameKey})' % {
                        overloadKey = overloadKey,
                        nameKey     = coder:getKey(source.name),
                    })
                end
            end

            coder:addLine('-- function overloads --')
            coder:addLine('{key} = rt.union { {overloadList} }' % {
                key          = coder:getKey(source),
                funcKey      = funcKey,
                overloadList = table.concat(overloadKeys, ', '),
            })
        end

        if source.name then
            -- 函数体已构建完毕，现在 flush 推迟的 appendVar（名字赋值），
            -- 保证 flow 中顺序为：ref（函数体内引用名字）→ var（名字赋值）
            if tracer then
                tracer:flushDeferVar()
            end
            coder:compileAssign(source.name, 1, coder:getKey(source))

            if catGroup then
                for _, cat in ipairs(catGroup) do
                    if cat.subtype == 'private'
                    or cat.subtype == 'protected'
                    or cat.subtype == 'public' then
                        coder:addLine('{varKey}:setVisibleType({visibleType%q})' % {
                            varKey      = coder:getKey(source.name),
                            visibleType = cat.subtype,
                        })
                        break
                    end
                end
            end
        end

        -- 一个潜规则：
        -- 如果函数有overload注解，但没有任何 param 与 return 注解，
        -- 那么这个函数本身就不算一个原型。
        if overloads and not returns and not coder:findNearedCats(source, 'catstateparam') then
            coder:addLine('{key}:setDummy()' % {
                key = funcKey,
            })
        end

    end, source)
end)
