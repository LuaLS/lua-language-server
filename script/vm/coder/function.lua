---@class Coder
local M = Class 'Coder'

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

        if source.name then
            coder:withIndentation(function ()
                coder:addLine('')
                if source.name.last then
                    coder:compile(source.name.last)
                end
                coder:compile(source.name)
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
                    coder:addLine('-- ' .. param.code)
                    coder:compile(param)
                    coder:addLine('{funcKey}:addParamDef({paramKey%q}, {paramNode})' % {
                        funcKey   = funcKey,
                        paramKey  = param.id,
                        paramNode = coder:getKey(param),
                    })
                end
            end, 'function params --')
        end

        ---@type LuaParser.Node.CatStateReturn[]?
        local returns = coder:findNearedCats(source, 'catstatereturn')
        if returns then
            coder:withIndentation(function ()
                for _, cat in ipairs(returns) do
                    if cat.value then
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

        if #source.childs > 0 then
            coder:withIndentation(function ()
                coder:pushBlock()
                coder:setBlockKV('function', funcKey)
                for _, child in ipairs(source.childs) do
                    coder:compile(child)
                    coder:addLine('')
                end
                coder:popBlock()
            end, 'function body --')
        end

        if overloads then
            local overloadKeys = { funcKey }

            for _, overload in ipairs(overloads) do
                overloadKeys[#overloadKeys+1] = coder:getKey(overload.value)
            end

            coder:addLine('-- function overloads --')
            coder:addLine('{key} = rt.union { {overloadList} }' % {
                key          = coder:getKey(source),
                funcKey      = funcKey,
                overloadList = table.concat(overloadKeys, ', '),
            })
        end

        if source.name then
            coder:compileAssign(source.name, 1, coder:getKey(source))
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
