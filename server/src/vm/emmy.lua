local mt = require 'vm.manager'

function mt:clearEmmy()
    self._emmy = nil
end

function mt:getEmmy()
    local emmy = self._emmy
    self._emmy = nil
    return emmy
end

function mt:doEmmyClass(action)
    local emmyMgr = self.emmyMgr
    self:instantSource(action)
    local class = emmyMgr:addClass(action)
    self._emmy = class
    action:set('emmy.class', class)
end

function mt:doEmmyType(action)
    local emmyMgr = self.emmyMgr
    self:instantSource(action)
    local type = emmyMgr:createType(action)
    self._emmy = type
    action:set('emmy.type', type)
end

function mt:doEmmyIncomplete(action)
    self:instantSource(action)
end
