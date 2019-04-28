local mt = require 'vm.manager'

function mt:clearEmmy()
    self._emmy = nil
    self._emmyParams = nil
    self._emmyReturns = nil
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
    elseif tp == 'emmyGeneric' then
    elseif tp == 'emmyVararg' then
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

function mt:doEmmyType(action)
    ---@type emmyMgr
    local emmyMgr = self.emmyMgr
    self:instantSource(action)
    for _, obj in ipairs(action) do
        self:instantSource(obj)
        obj:set('emmy class', obj[1])
    end
    local type = emmyMgr:addType(action)
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
    local type = self:doEmmyType(action[2])
    local alias = emmyMgr:addAlias(action, type)
    action:set('emmy.alias', alias)
    action[1]:set('emmy class', alias:getName())
    if self.lsp then
        self.lsp.global:markSet(self:getUri())
    end
end

function mt:doEmmyParam(action)
    ---@type emmyMgr
    local emmyMgr = self.emmyMgr
    self:instantSource(action)
    self:instantSource(action[1])
    local type = self:doEmmyType(action[2])
    local param = emmyMgr:addParam(action, type)
    action:set('emmy.param', param)
    self._emmy = nil
    self:addEmmyParam(param)
end

function mt:doEmmyReturn(action)
    ---@type emmyMgr
    local emmyMgr = self.emmyMgr
    self:instantSource(action)
    local type = self:doEmmyType(action[1])
    local rtn = emmyMgr:addReturn(action, type)
    action:set('emmy.return', rtn)
    self._emmy = nil
    self:addEmmyReturn(rtn)
end

function mt:doEmmyIncomplete(action)
    self:instantSource(action)
end
