local Method = {}

function Method:initialize(params)
    self._inited = true
    return self:_callback('initialize', params)
end

return Method
