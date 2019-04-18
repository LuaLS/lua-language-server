local mt = require 'vm.manager'

function mt:doEmmyClass(action)
    local emmyMgr = self.emmyMgr
    self:instantSource(action)
    local class = emmyMgr:addClass(action)
    self.emmy = class
    action:set('emmy.class', class)
end

function mt:doEmmyType(action)
    local emmyMgr = self.emmyMgr
end

function mt:doEmmyIncomplete(action)
    self:instantSource(action)
end
