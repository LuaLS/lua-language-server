local files  = require 'files'
local guide  = require 'parser.guide'
local vm     = require 'vm'
local infer  = require 'core.infer'
local await  = require 'await'
local hasVarargs

local function inTypes(param, args)
    for _, v in ipairs(args) do
        if param[1] == v[1] then
            return true
        elseif param[1] == 'number'
        and v[1] == 'integer' then
            return true
        end
    end
    return false
end

local function excludeSituations(types)
    if not types[1]
    or not types[1][1]
    or types[1].typeGeneric then
        return true
    end
    return false
end

local function getInfoFromDefs(defs)
    local paramsTypes = {}
    local funcArgsType
    local mark = {}
    for _, def in ipairs(defs) do
        funcArgsType = {}
        if def.value then
            def = def.value
        end
        if mark[def] then
            goto CONTINUE
        end
        mark[def] = true

        if def.type == 'function'
        or def.type == 'doc.type.function' then
            if def.args then
                for _, arg in ipairs(def.args) do
                    local types
                    if arg.docParam and arg.docParam.extends then
                        types = arg.docParam.extends.types
                    ---变长参数
                    elseif arg.name and arg.name[1] == '...' then
                        types = {
                            [1] = {
                                [1] = '...',
                                type = 'varargs'
                            }
                        }
                    elseif arg.type == 'doc.type.arg' then
                        types = arg.extends.types
                    else
                        goto CONTINUE
                    end
                    ---如果是很复杂的type，比如泛型什么的，先不检查
                    if excludeSituations(types) then
                        goto CONTINUE
                    end
                    funcArgsType[#funcArgsType+1] = types
                end
            end
            if #funcArgsType > 0 then
                paramsTypes[#paramsTypes+1] = funcArgsType
            end
        end
        ::CONTINUE::
    end
    return paramsTypes
end

local function matchParams(paramsTypes, i, arg)
    local flag = ''
    local messages = {}
    for _, paramTypes in ipairs(paramsTypes) do
        if not paramTypes[i] then
            goto CONTINUE
        end
        for _, param in ipairs(paramTypes[i]) do
            ---如果形参的类型在实参里面
            if inTypes(param, arg)
            or param[1] == 'any'
            or arg.type == 'any' then
                flag = ''
                return true
            elseif param[1] == '...' then
                hasVarargs = true
                return true
            else
                flag = flag ..' ' .. param[1]
            end
        end
        if flag ~= '' then
            local argm = '[ '
            for _, v in ipairs(arg) do
                argm = argm .. v[1]..' '
            end
            argm = argm .. ']'
            local message = 'Argument of type in '..argm..' is not assignable to parameter of type in ['..flag..' ]'
            if not messages[message] then
                messages[message] = true
                messages[#messages+1] = message
            end
        end
        ::CONTINUE::
    end
    return false, messages
end
return function (uri, callback)
    local ast = files.getState(uri)
    if not ast then
        return
    end
    guide.eachSourceType(ast.ast, 'call', function (source)
        if not source.args then
            return
        end
        await.delay()
        local callArgs = source.args
        local callArgsType = {}
        for _, arg in ipairs(callArgs) do
            local infers = infer.searchInfers(arg)
            if infers['_G'] or infer['_ENV'] then
                infers['_G'] = nil
                infers['_ENV'] = nil
                infers['table'] = true
            end
            local types = {}
            for k in pairs(infers) do
                if k then
                    types[#types+1] = {
                        [1] = k,
                        type = k
                    }
                end
            end
            if #types < 1 then
                return
            end
            types.start = arg.start
            types.finish = arg.finish
            callArgsType[#callArgsType+1] = types
        end
        local func = source.node
        local defs = vm.getDefs(func)
        ---只检查有emmy注释定义的函数
        local paramsTypes = getInfoFromDefs(defs)
        ---遍历实参
        for i, arg in ipairs(callArgsType) do
            ---遍历形参
            hasVarargs = false
            local match, messages = matchParams(paramsTypes, i, arg)
            if hasVarargs then
                return
            end
            ---都不匹配
            if not match then
                if #messages > 0 then
                    callback{
                        start   = arg.start,
                        finish  = arg.finish,
                        message = table.concat(messages, '\n')
                    }
                end
            end
        end
        ---所有参数都匹配了
    end)

end
