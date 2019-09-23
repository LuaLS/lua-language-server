local m = {}
m.type = 'workspace'

function m.init(name, uri)
    m.name = name
    m.uri  = uri
end

return m
