local functionMgr = require 'vm.function'
local library = require 'vm.library'
local mt = require 'vm.manager'

function mt:clearEmmy()
    self._emmy = nil
    self._emmyParams = nil
    self._emmyReturns = nil
    self._emmyGeneric = nil
    self._emmyComment = nil
    self._emmyOverLoads = nil
end

function mt:doEmmy(action)
    local tp = action.type
    if tp == 'emmyClass' then
        self:doEmmyClass(action)
    elseif tp == 'emmyType' then
        self:doEmmyType(action)
    elseif tp == 'emmyAlias' then
        self:doEmmyAlias(action)
    elseif tp == 'emmyParam' then
        self:doEmmyParam(action)
    elseif tp == 'emmyReturn' then
        self:doEmmyReturn(action)
    elseif tp == 'emmyField' then
        self:doEmmyField(action)
    elseif tp == 'emmyGeneric' then
        self:doEmmyGeneric(action)
    elseif tp == 'emmyVararg' then
        self:doEmmyVararg(action)
    elseif tp == 'emmyLanguage' then
    elseif tp == 'emmyArrayType' then
        self:doEmmyArrayType(action)
    elseif tp == 'emmyTableType' then
        self:doEmmyTableType(action)
    elseif tp == 'emmyFunctionType' then
        self:doEmmyFunctionType(action)
    elseif tp == 'emmySee' then
        self:doEmmySee(action)
    elseif tp == 'emmyOverLoad' then
        self:doEmmyOverLoad(action)
    elseif tp == 'emmyIncomplete' then
        self:doEmmyIncomplete(action)
    elseif tp == 'emmyComment' then
        self:doEmmyComment(action)
    end
end

function mt:getEmmy()
    local emmy = self._emmy
    self._emmy = nil
    return emmy
end

function mt:addEmmyParam(param)
    if not self._emmyParams then
        self._emmyParams = {}
    end
    self._emmyParams[#self._emmyParams+1] = param
end

function mt:addEmmyReturn(rtn)
    if not self._emmyReturns then
        self._emmyReturns = {}
    end
    self._emmyReturns[#self._emmyReturns+1] = rtn
end

function mt:addEmmyOverLoad(funcObj)
    if not self._emmyOverLoads then
        self._emmyOverLoads = {}
    end
    self._emmyOverLoads[#self._emmyOverLoads+1] = funcObj
end

function mt:getEmmyParams()
    local params = self._emmyParams
    self._emmyParams = nil
    return params
end

function mt:getEmmyReturns()
    local returns = self._emmyReturns
    self._emmyReturns = nil
    return returns
end

function mt:getEmmyOverLoads()
    local overLoads = self._emmyOverLoads
    self._emmyOverLoads = nil
    return overLoads
end

function mt:getEmmyGeneric()
    local generic = self._emmyGeneric
    self._emmyGeneric = nil
    return generic
end

---@return string
function mt:getEmmyComment()
    local comment = self._emmyComment
    self._emmyComment = nil
    return comment
end

function mt:doEmmyClass(action)
    ---@type emmyMgr
    local emmyMgr = self.emmyMgr
    self:instantSource(action)
    self:instantSource(action[1])
    local class = emmyMgr:addClass(action)
    action:set('emmy class', class:getName())
    action[1]:set('emmy class', class:getName())
    local extends = action[2]
    if extends then
        self:instantSource(extends)
        extends:set('emmy class', extends[1])
    end
    self._emmy = class
    action:set('emmy.class', class)
    if self.lsp then
        self.lsp.global:markSet(self:getUri())
    end
end

function mt:buildEmmyType(action)
    ---@type emmyMgr
    local emmyMgr = self.emmyMgr
    self:instantSource(action)
    for _, obj in ipairs(action) do
        self:instantSource(obj)
        obj:set('emmy class', obj[1])
    end
    local type = emmyMgr:addType(action)
    return type
end

function mt:doEmmyType(action)
    local type = self:buildEmmyType(action)
    self._emmy = type
    if self.lsp then
        self.lsp.global:markGet(self:getUri())
    end
    return type
end

function mt:doEmmyAlias(action)
    ---@type emmyMgr
    local emmyMgr = self.emmyMgr
    self:instantSource(action)
    self:instantSource(action[1])
    local type = self:buildEmmyAnyType(action[2])
    local alias = emmyMgr:addAlias(action, type)
    action:set('emmy.alias', alias)
    action[1]:set('emmy class', alias:getName())
    self._emmy = type
    if self.lsp then
        self.lsp.global:markSet(self:getUri())
    end
end

function mt:getGenericByType(type)
    local generics = self._emmyGeneric
    if not generics then
        return
    end
    if #type ~= 1 then
        return
    end
    local name = type[1][1]
    for _, generic in ipairs(generics) do
        if generic:getName() == name then
            return generic
        end
    end
    return nil
end

function mt:doEmmyParam(action)
    ---@type emmyMgr
    local emmyMgr = self.emmyMgr
    self:instantSource(action)
    self:instantSource(action[1])
    local type = self:getGenericByType(action[2]) or self:buildEmmyAnyType(action[2])
    local param = emmyMgr:addParam(action, type)
    action:set('emmy.param', param)
    self:addEmmyParam(param)
    if self.lsp then
        self.lsp.global:markGet(self:getUri())
    end
end

function mt:doEmmyReturn(action)
    ---@type emmyMgr
    local emmyMgr = self.emmyMgr
    self:instantSource(action)
    local type = action[1] and (self:getGenericByType(action[1]) or self:buildEmmyAnyType(action[1]))
    local name = action[2]
    local rtn = emmyMgr:addReturn(action, type, name)
    action:set('emmy.return', rtn)
    self:addEmmyReturn(rtn)
    if self.lsp then
        self.lsp.global:markGet(self:getUri())
    end
end

function mt:doEmmyField(action)
    ---@type emmyMgr
    local emmyMgr = self.emmyMgr
    self:instantSource(action)
    self:instantSource(action[2])
    local type = self:buildEmmyAnyType(action[3])
    local value = self:createValue('nil', action[2])
    local field = emmyMgr:addField(action, type, value)
    value:setEmmy(type)
    action:set('emmy.field', field)

    local class = self._emmy
    if not self._emmy or self._emmy.type ~= 'emmy.class' then
        return
    end
    class:addField(field)
    action:set('target class', class)
end

function mt:doEmmyGeneric(action)
    ---@type emmyMgr
    local emmyMgr = self.emmyMgr
    self:instantSource(action)

    local defs = {}
    for i, obj in ipairs(action) do
        defs[i] = {}
        defs[i].name = self:instantSource(obj[1])
        if obj[2] then
            defs[i].type = self:buildEmmyAnyType(obj[2])
        end
    end

    local generic = emmyMgr:addGeneric(defs)
    self._emmyGeneric = generic
end

function mt:doEmmyVararg(action)
    ---@type emmyMgr
    local emmyMgr = self.emmyMgr
    self:instantSource(action)
    local type = self:getGenericByType(action[1]) or self:buildEmmyAnyType(action[1])
    local param = emmyMgr:addParam(action, type)
    action:set('emmy.param', param)
    self:addEmmyParam(param)
    if self.lsp then
        self.lsp.global:markGet(self:getUri())
    end
end

function mt:buildEmmyArrayType(action)
    ---@type emmyMgr
    local emmyMgr = self.emmyMgr
    self:instantSource(action)
    for _, obj in ipairs(action) do
        self:instantSource(obj)
        action:set('emmy class', obj[1])
    end
    local type = emmyMgr:addArrayType(action)
    return type
end

function mt:doEmmyArrayType(action)
    local type = self:buildEmmyArrayType(action)
    self._emmy = type
    if self.lsp then
        self.lsp.global:markGet(self:getUri())
    end
    return type
end

function mt:buildEmmyTableType(action)
    ---@type emmyMgr
    local emmyMgr = self.emmyMgr
    self:instantSource(action)
    local keyType = self:buildEmmyAnyType(action[1])
    local valueType = self:buildEmmyAnyType(action[2])
    local type = emmyMgr:addTableType(action, keyType, valueType)
    return type
end

function mt:doEmmyTableType(action)
    local type = self:buildEmmyTableType(action)
    self._emmy = type
    if self.lsp then
        self.lsp.global:markGet(self:getUri())
    end
    return type
end

function mt:buildEmmyFunctionType(source)
    ---@type emmyMgr
    local emmyMgr = self.emmyMgr
    self:instantSource(source)
    local funcObj = emmyMgr:addFunctionType(source)
    ---@type emmyFunction
    local func = functionMgr.create(source)
    local args = source.args
    if args then
        for i = 1, #args // 2 do
            local nameSource = args[i*2-1]
            local typeSource = args[i*2]
            local paramType = self:buildEmmyAnyType(typeSource)
            funcObj:addParam(nameSource[1], paramType)
            local value = self:createValue(paramType:getType(), typeSource)
            value:setEmmy(paramType)
            self:instantSource(nameSource)
            local arg = func:addArg(nameSource[1], nameSource, value)
            arg:set('emmy arg', true)
        end
    end
    local returns = source.returns
    if returns then
        for i = 1, #returns do
            local returnSource = returns[i]
            local returnType = self:buildEmmyAnyType(returnSource)
            funcObj:addReturn(returnType)
            local value = self:createValue(returnType:getType(), returnSource)
            value:setEmmy(returnType)
            func:setReturn(i, value)
        end
    end
    funcObj:bindFunction(func)
    return funcObj
end

function mt:doEmmyFunctionType(action)
    local funcObj = self:buildEmmyFunctionType(action)
    self._emmy = funcObj
    return funcObj
end

function mt:buildEmmyAnyType(source)
    if source.type == 'emmyType' then
        return self:buildEmmyType(source)
    elseif source.type == 'emmyArrayType' then
        return self:buildEmmyArrayType(source)
    elseif source.type == 'emmyTableType' then
        return self:buildEmmyTableType(source)
    elseif source.type == 'emmyFunctionType' then
        return self:buildEmmyFunctionType(source)
    else
        error('Unknown emmy type: ' .. table.dump(source))
    end
end

function mt:doEmmyIncomplete(action)
    self:instantSource(action)
end

function mt:doEmmyComment(action)
    self._emmyComment = action[1]
end

function mt:doEmmySee(action)
    self:instantSource(action)
    self:instantSource(action[2])
    action[2]:set('emmy see', action)
end

function mt:doEmmyOverLoad(action)
    local funcObj = self:buildEmmyFunctionType(action)
    self:addEmmyOverLoad(funcObj)
end
