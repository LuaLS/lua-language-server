local args = ...

require 'utility'
local fs = require 'bee.filesystem'
local root = fs.absolute(fs.path(args.root))

local function glob_compile(pattern)
    return ("^%s$"):format(pattern:gsub("[%^%$%(%)%%%.%[%]%+%-%?]", "%%%0"):gsub("%*", ".*"))
end
local function glob_match(pattern, target)
    return target:match(pattern) ~= nil
end

local function accept_path(t, path)
    if t[path:string()] then
        return
    end
    t[#t+1] = path:string()
    t[path:string()] = #t
end
local function expand_dir(t, pattern, dir)
    if not fs.exists(dir) then
        return
    end
    for file in dir:list_directory() do
        if fs.is_directory(file) then
            expand_dir(t, pattern, file)
        else
            if glob_match(pattern, file:filename():string():lower()) then
                accept_path(t, file)
            end
        end
    end
end
local function expand_path(t, root, source)
    if source:sub(1, 1) == '/' then
        source = source:sub(2)
    end
    local path = root / source
    if source:find("*", 1, true) == nil then
        accept_path(t, path)
        return
    end
    local filename = path:filename():string():lower()
    local pattern = glob_compile(filename)
    expand_dir(t, pattern, path:parent_path())
end
local function get_sources(root, sources)
    local result = {}
    local ignore = {}
    for _, source in ipairs(sources) do
        if source:sub(1,1) ~= "!" then
            expand_path(result, root, source)
        else
            expand_path(ignore, root, source:sub(2))
        end
    end
    for _, path in ipairs(ignore) do
        local pos = result[path]
        if pos then
            result[pos] = result[#result]
            result[result[pos]] = pos
            result[path] = nil
            result[#result] = nil
        end
    end
    return result
end

local function computePath()
    local ignore = { '.git' }


    for name in pairs(args.ignore) do
        ignore[#ignore+1] = name:lower()
    end

    return get_sources(root, ignore)
end

local ignored = computePath()

for path in io.scan(root, ignored) do
    if path:extension():string() == '.lua' then
        local buf = io.load(path)
        if buf then
            OUT:push {
                path = fs.absolute(path):string(),
                buf = buf,
            }
        end
    end
end

OUT:push 'ok'
