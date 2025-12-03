require 'filesystem.sync'

local function resolve(method, params)
    local f = ls.fs[method]
    if not f then
        return error(('Method "%s" not found'):format(method))
    end
    local result = f(table.unpack(params))
    return result
end

return {
    resolve = resolve,
}
