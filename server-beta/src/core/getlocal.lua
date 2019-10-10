local m = {}

function m:def(source, callback)
    self:eachDef(source.loc, callback)
end

function m:ref(source, callback)
    self:eachRef(source.loc, callback)
end

function m:field(source, key, callback)
    self:eachField(source.loc, key, callback)
end

return m
