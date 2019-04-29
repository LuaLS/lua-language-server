local mt = require 'vm.manager'

function mt:clearEmmy()
    self._emmy = nil
    self._emmyParams = nil
    self._emmyReturns = nil
    self._emmyGeneric = nil
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
    elseif tp == 'emmyTableType' then
    elseif tp == 'emmyFunctionType' then
    elseif tp == 'emmySee' then
    elseif tp == 'emmyIncomplete' then
        self:doEmmyIncomplete(action)
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

function mt:getEmmyGeneric()
    local generic = self._emmyGeneric
    self._emmyGeneric = nil
    return generic
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
    local type = self:buildEmmyType(action[2])
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
    if #type > 1 then
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
    local type = self:getGenericByType(action[2]) or self:buildEmmyType(action[2])
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
    local type = self:getGenericByType(action[1]) or self:buildEmmyType(action[1])
    local rtn = emmyMgr:addReturn(action, type)
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
    local type = self:buildEmmyType(action[3])
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
            defs[i].type = self:buildEmmyType(obj[2])
        end
    end

    local generic = emmyMgr:addGeneric(defs)
    self._emmyGeneric = generic
end

function mt:doEmmyVararg(action)
    ---@type emmyMgr
    local emmyMgr = self.emmyMgr
    self:instantSource(action)
    local type = self:getGenericByType(action[1]) or self:buildEmmyType(action[1])
    local param = emmyMgr:addParam(action, type)
    action:set('emmy.param', param)
    self:addEmmyParam(param)
    if self.lsp then
        self.lsp.global:markGet(self:getUri())
    end
end

function mt:doEmmyIncomplete(action)
    self:instantSource(action)
end
