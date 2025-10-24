---@class VM.Coder
local M = Class 'VM.Coder'

---@param param LuaParser.Node.Param
---@return LuaParser.Node.CatStateParam?
function M:findMatchedCatParam(param)
    local catGroup = self:getCatGroup(param)
    if not catGroup then
        return nil
    end
    for _, catState in ipairs(catGroup) do
        local cat = catState.value
        if not cat then
            goto continue
        end
        if cat.kind == 'catstateparam' then
            ---@cast cat LuaParser.Node.CatStateParam
            if cat.key.id == param.id then
                return cat
            end
        end
        ::continue::
    end
end

---@param func LuaParser.Node.Function
---@return LuaParser.Node.CatStateGeneric[]?
function M:findCatTypeParams(func)
    local catGroup = self:getCatGroup(func)
    if not catGroup then
        return nil
    end
    local typeParams = {}

    for _, catState in ipairs(catGroup) do
        local cat = catState.value
        if not cat then
            goto continue
        end
        if cat.kind == 'catstategeneric' then
            ---@cast cat LuaParser.Node.CatStateGeneric
            typeParams[#typeParams+1] = cat
        end
        ::continue::
    end

    if #typeParams == 0 then
        return nil
    end

    return typeParams
end

---@param func LuaParser.Node.Function
---@return LuaParser.Node.CatStateReturn[]?
function M:findCatReturns(func)
    local catGroup = self:getCatGroup(func)
    if not catGroup then
        return nil
    end
    local returns = {}

    for _, catState in ipairs(catGroup) do
        local cat = catState.value
        if not cat then
            goto continue
        end
        if cat.kind == 'catstatereturn' then
            ---@cast cat LuaParser.Node.CatStateReturn
            returns[#returns+1] = cat
        end
        ::continue::
    end

    if #returns == 0 then
        return nil
    end

    return returns
end

---@param coder VM.Coder
---@param source LuaParser.Node.Function
---@param param LuaParser.Node.Param
local function resolveParam(coder, source, param)
    coder:compile(param)
    coder:addLine('{funcKey}:addParamDef({paramKey:q}, {paramNode})' % {
        funcKey   = coder:getKey(source),
        paramKey  = param.id,
        paramNode = coder:getKey(param),
    })
end

ls.vm.registerCoderProvider('function', function (coder, source)
    ---@cast source LuaParser.Node.Function

    coder:withIndentation(function ()
        coder:addLine('{key} = node.func()' % {
            key = coder:getKey(source),
        })
        if source.name then
            coder:withIndentation(function ()
                coder:addLine('')
                coder:compile(source.name)
                coder:compileAssign(source.name, 1, coder:getKey(source))
            end, 'function name --')
        end

        local typeParams = coder:findCatTypeParams(source)
        if typeParams then
            coder:withIndentation(function ()
                for _, cat in ipairs(typeParams) do
                    for _, param in ipairs(cat.typeParams) do
                        coder:addLine('-- ' .. param.code)
                        coder:addLine('{func}:addTypeParam({param})' % {
                            func  = coder:getKey(source),
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
                    resolveParam(coder, source, param)
                end
            end, 'function params --')
        end

        local returns = coder:findCatReturns(source)
        if returns then
            coder:withIndentation(function ()
                for _, cat in ipairs(returns) do
                    if cat.value then
                        coder:addLine('-- ' .. cat.code)
                        coder:addLine('{funcKey}:addReturnDef({returnKey}, {returnType})' % {
                            funcKey    = coder:getKey(source),
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
                for _, child in ipairs(source.childs) do
                    coder:compile(child)
                    coder:addLine('')
                end
                coder:popBlock()
            end, 'function body --')
        end
    end, source.code)
end)
