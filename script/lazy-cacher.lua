local fs = require 'bee.filesystem'

---@param path string
---@param errorHandle? fun(string)
---@return table?
return function (path, errorHandle)
    fs.create_directories(fs.path(path):parent_path())
    local f, err = io.open(path, 'a+b')
    if not f then
        if errorHandle then
            errorHandle(err)
        end
        return nil
    end
    local size, err = f:seek('end')
    if not size then
        if errorHandle then
            errorHandle(err)
        end
        return nil
    end
    local map = {}
    return {
        writter = function(id, code)
            local offset, err = f:seek('end')
            if not offset then
                if errorHandle then
                    errorHandle(err)
                end
                return false
            end
            if not code then
                map[id] = nil
                return true
            end
            if #code > 1000000 then
                return false
            end
            local suc, err = f:write(code)
            if not suc then
                if errorHandle then
                    errorHandle(err)
                end
                return false
            end
            map[id] = offset * 1000000 + #code
            return true
        end,
        reader = function(id)
            if not map[id] then
                return nil
            end
            local offset = map[id] // 1000000
            local len    = map[id] %  1000000
            local _, err = f:seek('set', offset)
            if err then
                if errorHandle then
                    errorHandle(err)
                end
                return nil
            end
            local code = f:read(len)
            return code
        end,
        dispose = function ()
            f:close()
            fs.remove(fs.path(path))
        end,
    }
end
