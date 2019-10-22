local m = {}

function m:eachDef(source, callback)
    self:eachDef(source.loc, callback)
end

function m:eachRef(source, callback)
    self:eachRef(source.loc, callback)
end

function m:eachField(source, key, callback)
    self:eachField(source.loc, key, callback)
end

function m:eachValue(source, callback)
    self:eachValue(source.loc, callback)
end

return m
