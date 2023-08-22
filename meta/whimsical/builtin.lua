---@meta _

--[[@@@
---@inner class -> {
    self.istruly = true
    self.truly   = self
    self.falsy   = Class 'never'
    self.view    = self.name
}
---@inner integer -> {
    self.istruly = true
    self.truly   = self
    self.falsy   = Class 'never'
    self.view    = tostring(self.value)
}
---@inner string -> {
    self.istruly = true
    self.truly   = self
    self.falsy   = Class 'never'
    self.view    = cat.util.viewString(self.value, self.quotation)
}
---@inner union -> {
    self.istruly = function (subs)
        local istruly = subs[1].istruly
        if istruly == nil then
            return nil
        end
        if istruly == true then
            for i = 2, #subs do
                if subs[i].istruly ~= true then
                    return nil
                end
            end
            return true
        else
            for i = 2, #subs do
                if subs[i].istruly ~= false then
                    return nil
                end
            end
            return false
        end
        return nil
    end
    self.truly = function (subs)
        local union = Union()
        for i = 1, #subs do
            union:add(subs[i].truly)
        end
        if union:len() == 0 then
            return Class 'never'
        end
        if union:len() == 1 then
            return union:first()
        end
        return union
    end
    self.falsy = function (subs)
        local union = Union()
        for i = 1, #subs do
            union:add(subs[i].falsy)
        end
        if union:len() == 0 then
            return Class 'never'
        end
        if union:len() == 1 then
            return union:first()
        end
        return union
    end
    self.view = function (subs)
        local views = {}
        for i = 1, #subs do
            views[i] = subs[i].view
        end
        if #views == 0 then
            return 'never'
        end
        return table.concat(views, '|')
    end
}
---@class nil -> {
    self.istruly = false
    self.truly   = Class 'never'
    self.falsy   = self
}
---@class never -> {
    self.istruly = nil
}
---@class true -> {
    self.istruly = true
    self.truly   = self
    self.falsy   = Class 'never'
}
---@class false -> {
    self.istruly = false
    self.truly   = Class 'never'
    self.falsy   = self
}
---@class any: { [unknown]: any } -> {
    self.istruly = nil
    self.truly   = Class 'truly'
    self.falsy   = Class 'false' | Class 'nil'
}
---@class truly: { [unknown]: any }
---@class unknown: truly | false
---@class boolean: true | false
---@class number
---@class thread
---@class table: { [unknown]: any }
---@class table<K, V>: { [K]: V }
---@class string: stringlib
---@class userdata: { [unknown]: any }
---@class lightuserdata
---@class function: fun(...): ...
]]
