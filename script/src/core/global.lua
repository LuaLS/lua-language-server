local mt = {}
mt.__index = mt

function mt:markSet(uri)
    if not uri then
        return
    end
    self.set[uri] = true
end

function mt:markGet(uri)
    if not uri then
        return
    end
    self.get[uri] = true
end

function mt:clearGlobal(uri)
    self.set[uri] = nil
    self.get[uri] = nil
end

function mt:getAllUris()
    local uris = {}
    for uri in pairs(self.set) do
        uris[#uris+1] = uri
    end
    for uri in pairs(self.get) do
        if not self.set[uri] then
            uris[#uris+1] = uri
        end
    end
    return uris
end

function mt:hasSetGlobal(uri)
    return self.set[uri] ~= nil
end

function mt:remove()
end

return function (lsp)
    return setmetatable({
        get = {},
        set = {},
        lsp = lsp,
    }, mt)
end
