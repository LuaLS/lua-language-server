local fs = require 'bee.filesystem'
local json = require 'json'
local config = require 'config'
local rpc = require 'rpc'

local command = {}

local function isContainPos(obj, start, finish)
    if obj.start <= start and obj.finish + 1 >= finish then
        return true
    end
    return false
end

local function isInString(vm, start, finish)
    for _, source in ipairs(vm.sources) do
        if source.type == 'string' and isContainPos(source, start, finish) then
            return true
        end
    end
    return false
end

local function posToRange(lines, start, finish)
    local start_row,  start_col  = lines:rowcol(start)
    local finish_row, finish_col = lines:rowcol(finish)
    return {
        start = {
            line = start_row - 1,
            character = start_col - 1,
        },
        ['end'] = {
            line = finish_row - 1,
            character = finish_col,
        },
    }
end

function command.config(lsp, data)
    local def = config.config
    for _, k in ipairs(data.key) do
        def = def[k]
        if not def then
            return
        end
    end
    if data.action == 'add' then
        if type(def) ~= 'table' then
            return
        end
    end

    local vscodePath = lsp.workspace.root / '.vscode'
    local settingBuf = io.load(vscodePath / 'settings.json')
    if not settingBuf then
        fs.create_directories(vscodePath)
    end

    local setting = json.decode(settingBuf, true) or {}
    local key = 'Lua.' .. table.concat(data.key, '.')
    local attr = setting[key]

    if data.action == 'add' then
        if attr == nil then
            attr = {}
        elseif type(attr) == 'string' then
            attr = {attr}
        elseif type(attr) == 'table' then
        else
            return
        end

        attr[#attr+1] = data.value
        setting[key] = attr
    end

    io.save(vscodePath / 'settings.json', json.encode(setting) .. '\r\n')
end

function command.removeSpace(lsp, data)
    local uri = data.uri
    local vm, lines = lsp:getVM(uri)
    if not vm then
        return
    end

    local textEdit = {}
    for i = 1, #lines do
        local line = lines:line(i)
        local pos = line:find '[ \t]+$'
        if pos then
            local start, finish = lines:range(i)
            start = start + pos - 1
            if isInString(vm, start, finish) then
                goto NEXT_LINE
            end
            textEdit[#textEdit+1] = {
                range = posToRange(lines, start, finish),
                newText = '',
            }
            goto NEXT_LINE
        end

        ::NEXT_LINE::
    end

    if #textEdit == 0 then
        return
    end

    rpc:request('workspace/applyEdit', {
        label = '清除所有后置空格',
        edit = {
            changes = {
                [uri] = textEdit,
            }
        },
    })
end

return function (lsp, params)
    local name = params.command
    if not command[name] then
        return
    end
    local result = command[name](lsp, params.arguments[1])
    return result
end
