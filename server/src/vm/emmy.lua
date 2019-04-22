local mt = require 'vm.manager'

function mt:clearEmmy()
    self._emmy = nil
end

function mt:doEmmy(action)
    local tp = action.type
    if tp == 'emmyClass' then
        self:doEmmyClass(action)
    elseif tp == 'emmyType' then
        self:doEmmyType(action)
    elseif tp == 'emmyAlias' then
    elseif tp == 'emmyParam' then
    elseif tp == 'emmyReturn' then
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

function mt:doEmmyClass(action)
    ---@type emmyMgr
    local emmyMgr = self.emmyMgr
    self:instantSource(action)
    local class = emmyMgr:addClass(action)
    local extends = action[2]
    if extends then
        self:instantSource(extends)
        extends:set('target class', extends[1])
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
    local type = emmyMgr:addType(action)
    self._emmy = type
    action:set('emmy.type', type)
    for _, obj in ipairs(action) do
        self:instantSource(obj)
        obj:set('target class', obj[1])
    end
    if self.lsp then
        self.lsp.global:markGet(self:getUri())
    end
end

function mt:doEmmyIncomplete(action)
    self:instantSource(action)
end
