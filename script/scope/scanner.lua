---@class Scope.Scanner
local M = Class 'Scope.Scanner'

---@class Scope.ScannerOptions
---@field getChilds? fun(uri: Uri): Uri[]|nil
---@field getType? fun(uri: Uri):('file'|'directory'|nil)
---@field followSymlink? boolean
---@field patterns? string[]

---@param root Uri
---@param options? Scope.ScannerOptions
---@return Uri[]
function M:scan(root, options)
    local getChilds = options and options.getChilds
                    or ls.fs.getChilds
    local getType   = options and options.getType
    if not getType then
        if options and options.followSymlink then
            getType = ls.fs.getTypeWithSymlink
        else
            getType = ls.fs.getType
        end
    end
    local patterns = options and options.patterns or {}

    local results = {}

    ---@param path Uri
    local function scan(path)
        local ftype = getType(path)
        if ftype == 'file' then
            results[#results+1] = path
            return
        end
        if ftype == 'directory' then
            local childs = getChilds(path)
            if not childs then
                return
            end
            for _, child in ipairs(childs) do
                scan(child)
            end
        end
    end

    scan(root)

    return results
end

---@return Scope.Scanner
function ls.scope.createScanner()
    return New 'Scope.Scanner' ()
end
