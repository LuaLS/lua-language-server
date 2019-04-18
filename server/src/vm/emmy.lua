local mt = require 'vm.manager'

function mt:doEmmyClass(action)
    if not self.lsp then
        return
    end
    local emmyMgr = self.lsp.emmyMgr
    local class = action[1]
    local parent = action[2]
    self:instantSource(class)
    if parent then
        self:instantSource(parent)
    end
    local emmyClass = emmyMgr:addClass(class, parent)
    self.emmy = emmyClass
end
