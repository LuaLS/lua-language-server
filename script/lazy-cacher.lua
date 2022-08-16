local fs    = require 'bee.filesystem'

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
            local suc, err = f:write(code)
            if not suc then
                if errorHandle then
                    errorHandle(err)
                end
                return false
            end
            map[id * 2]     = offset
            map[id * 2 + 1] = #code
            return true
        end,
        reader = function(id)
            local offset = map[id * 2]
            local len    = map[id * 2 + 1]
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
            os.remove(path)
        end,
    }
end
