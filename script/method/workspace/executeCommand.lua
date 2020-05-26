local fs = require 'bee.filesystem'
local json = require 'json'
local config = require 'config'
local rpc = require 'rpc'
local lang = require 'language'
local platform = require 'bee.platform'

local command = {}

local function isContainPos(obj, start, finish)
    if obj.start <= start and obj.finish >= finish then
        return true
    end
    return false
end

local function isInString(vm, start, finish)
    return vm:eachSource(function (source)
        if source.type == 'string' and isContainPos(source, start, finish) then
            return true
        end
    end)
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

--- @param lsp LSP
--- @param data table
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

    local vscodePath
    local mode
    local ws
    if data.uri then
        ws = lsp:findWorkspaceFor(data.uri)
    end
    if ws then
        vscodePath = ws.root / '.vscode'
        mode = 'workspace'
    else
        if platform.OS == 'Windows' then
            vscodePath = fs.path(os.getenv 'USERPROFILE') / 'AppData' / 'Roaming' / 'Code' / 'User'
        else
            vscodePath = fs.path(os.getenv 'HOME') / '.vscode-server' / 'data' / 'Machine'
        end
        mode = 'user'
        if not fs.exists(vscodePath) then
            rpc:notify('window/showMessage', {
                type = 3,
                message = lang.script.MWS_UCONFIG_FAILED,
            })
            return
        end
    end

    local settingBuf = io.load(vscodePath / 'settings.json')
    if not settingBuf then
        fs.create_directories(vscodePath)
    end

    local setting = json.decode(settingBuf or '', true) or {}
    local key = 'Lua.' .. table.concat(data.key, '.')
    local attr = setting[key]

    if data.action == 'add' then
        if attr == nil then
            attr = {}
        elseif type(attr) == 'string' then
            attr = {}
            for str in attr:gmatch '[^;]+' do
                attr[#attr+1] = str
            end
        elseif type(attr) == 'table' then
        else
            return
        end

        attr[#attr+1] = data.value
        setting[key] = attr
    elseif data.action == 'set' then
        setting[key] = data.value
    end

    io.save(vscodePath / 'settings.json', json.encode(setting) .. '\r\n')

    if mode == 'workspace' then
        rpc:notify('window/showMessage', {
            type = 3,
            message = lang.script.MWS_WCONFIG_UPDATED,
        })
    elseif mode == 'user' then
        rpc:notify('window/showMessage', {
            type = 3,
            message = lang.script.MWS_UCONFIG_UPDATED,
        })
    end
end

--- @param lsp LSP
--- @param data table
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
        label = lang.script.COMMAND_REMOVE_SPACE,
        edit = {
            changes = {
                [uri] = textEdit,
            }
        },
    })
end

local opMap = {
    ['+']  = true,
    ['-']  = true,
    ['*']  = true,
    ['/']  = true,
    ['//'] = true,
    ['^']  = true,
    ['<<'] = true,
    ['>>'] = true,
    ['&']  = true,
    ['|']  = true,
    ['~']  = true,
    ['..'] = true,
}

local literalMap = {
    ['number']  = true,
    ['boolean'] = true,
    ['string']  = true,
    ['table']   = true,
}

--- @param lsp LSP
--- @param data table
function command.solve(lsp, data)
    local uri = data.uri
    local vm, lines = lsp:getVM(uri)
    if not vm then
        return
    end

    local start = lines:position(data.range.start.line + 1, data.range.start.character + 1)
    local finish = lines:position(data.range['end'].line + 1, data.range['end'].character)

    local result = vm:eachSource(function (source)
        if not isContainPos(source, start, finish) then
            return
        end
        if source.op ~= 'or' then
            return
        end
        local first  = source[1]
        local second = source[2]
        -- (a + b) or 0 --> a + (b or 0)
        do
            if opMap[first.op]
                and first.type ~= 'unary'
                and not second.op
                and literalMap[second.type]
            then
                return {
                    start = source[1][2].start,
                    finish = source[2].finish,
                }
            end
        end
        -- a or (b + c) --> (a or b) + c
        do
            if opMap[second.op]
                and second.type ~= 'unary'
                and not first.op
                and literalMap[second[1].type]
            then
                return {
                    start = source[1].start,
                    finish = source[2][1].finish,
                }
            end
        end
    end)

    if not result then
        return
    end

    rpc:request('workspace/applyEdit', {
        label = lang.script.COMMAND_ADD_BRACKETS,
        edit = {
            changes = {
                [uri] = {
                    {
                        range = posToRange(lines, result.start, result.start - 1),
                        newText = '(',
                    },
                    {
                        range = posToRange(lines, result.finish + 1, result.finish),
                        newText = ')',
                    },
                }
            }
        },
    })
end

--- @param lsp LSP
--- @param params table
return function (lsp, params)
    local name = params.command
    if not command[name] then
        return
    end
    local result = command[name](lsp, params.arguments[1])
    return result
end
