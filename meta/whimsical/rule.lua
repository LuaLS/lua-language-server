local cat

cat.rule.inner.default = function (self)
    self.istruly = true
    self.truly   = self
    self.falsy   = cat.class 'never'
    self.view    = self.name
end

cat.rule.inner.never = function (self)
    self.istruly = nil
end

cat.rule.inner.any = function (self)
    self.istruly = nil
    self.truly   = cat.class 'truly'
    self.falsy   = cat.boolean(false) | cat.class 'nil'
end

cat.rule.inner['nil'] = function (self)
    self.istruly = false
    self.truly   = cat.class 'never'
    self.falsy   = self
end

cat.rule.inner.boolean = function (self)
    if self.value == true then
        self.istruly = true
        self.truly   = self
        self.falsy   = cat.class 'never'
    elseif self.value == false then
        self.istruly = false
        self.truly   = cat.class 'never'
        self.falsy   = self
    else
        self.istruly = nil
        self.truly   = cat.boolean(true)
        self.falsy   = cat.boolean(false)
    end
end

cat.rule.inner.number = function (self)
    self.istruly = true
    self.truly   = self
    self.falsy   = cat.class 'never'
    self.view    = tostring(self.value)
end

cat.rule.inner.integer = function (self)
    self.istruly = true
    self.truly   = self
    self.falsy   = cat.class 'never'
    self.view    = tostring(self.value)
end

cat.rule.inner.string = function (self)
    self.istruly = true
    self.truly   = self
    self.falsy   = cat.class 'never'
    self.view    = cat.util.viewString(self.value, self.quotation)
end

cat.rule.inner.union = function (self)
    self.istruly = function (union)
        local istruly = union.subs[1].istruly
        if istruly == nil then
            return nil
        end
        if istruly == true then
            for i = 2, #union.subs do
                if union.subs[i].istruly ~= true then
                    return nil
                end
            end
            return true
        else
            for i = 2, #union.subs do
                if union.subs[i].istruly ~= false then
                    return nil
                end
            end
            return false
        end
        return nil
    end
    self.truly = function (union)
        local new = cat.union()
        for i = 1, #union.subs do
            new:add(union.subs[i].truly)
        end
        if new:len() == 0 then
            return cat.class 'never'
        end
        if new:len() == 1 then
            return new[1]
        end
        return new
    end
    self.falsy = function (union)
        local new = cat.union()
        for i = 1, #union.subs do
            new:add(union.subs[i].falsy)
        end
        if new:len() == 0 then
            return cat.class 'never'
        end
        if new:len() == 1 then
            return new[1]
        end
        return new
    end
    self.view = function (union)
        local views = {}
        for i = 1, #union.subs do
            views[i] = union.subs[i].view
        end
        if #views == 0 then
            return 'never'
        end
        return table.concat(views, '|')
    end
end
