local methods = {}


---@param std 'stdin' | 'stdout' |'stderr'
---@param ... any
---@return string?
function methods.read(std, ...)
    return io[std]:read(...)
end

---@param std 'stdin' | 'stdout' |'stderr'
---@param ... string | number
---@return boolean
function methods.write(std, ...)
    if io[std]:write(...) then
        return true
    else
        return false
    end
end

return {
    resolve = function (method, params)
        return methods[method](table.unpack(params))
    end,
}
