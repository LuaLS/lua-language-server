local cat

cat.rule.default = function (self)
    self.isTruly = true
    self.truly   = self
    self.falsy   = cat.class 'never'
    self.view    = self.name
end

cat.rule.never = function (self)
    self.isTruly = nil
end

cat.rule.any = function (self)
    self.isTruly = nil
    self.truly   = cat.class 'truly'
    self.falsy   = cat.boolean(false) | cat.class 'nil'
end

cat.rule['nil'] = function (self)
    self.isTruly = false
    self.truly   = cat.class 'never'
    self.falsy   = self
end

cat.rule.boolean = function (self)
    if self.value == true then
        self.isTruly = true
        self.truly   = self
        self.falsy   = cat.class 'never'
    elseif self.value == false then
        self.isTruly = false
        self.truly   = cat.class 'never'
        self.falsy   = self
    else
        self.isTruly = nil
        self.truly   = cat.boolean(true)
        self.falsy   = cat.boolean(false)
    end
end

cat.rule.number = function (self)
    self.isTruly = true
    self.truly   = self
    self.falsy   = cat.class 'never'
    self.view    = tostring(self.value)
end

cat.rule.integer = function (self)
    self.isTruly = true
    self.truly   = self
    self.falsy   = cat.class 'never'
    self.view    = tostring(self.value)
end

cat.rule.string = function (self)
    self.isTruly = true
    self.truly   = self
    self.falsy   = cat.class 'never'
    self.view    = cat.util.viewString(self.value, self.quotation)
end

cat.rule.union = function (self)
    self.isTruly = function (union)
        local isTruly = union.subs[1].isTruly
        if isTruly == nil then
            return nil
        end
        if isTruly == true then
            for i = 2, #union.subs do
                if union.subs[i].isTruly ~= true then
                    return nil
                end
            end
            return true
        else
            for i = 2, #union.subs do
                if union.subs[i].isTruly ~= false then
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

cat.custom.dofile.onReturn = function (context)
    local filename = context.args[1].asString
    local file     = cat.files[filename]
    return file.returns[1]
end
