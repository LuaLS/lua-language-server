local files  = require 'files'
local guide  = require 'parser.guide'
local vm     = require 'vm'
local infer  = require 'core.infer'
local await  = require 'await'
-- local function hasTypeDoc(obj)
--     if obj.type == 'getlocal'
--     and obj.node
--     and obj.node.type == 'local'
--     and obj.node.bindDocs
--     and obj.node.bindDocs[1]
--     and (obj.node.bindDocs[1].type == 'doc.type'
--         or obj.node.bindDocs[1].type == 'doc.param') then
--         return true
--     end
--     return false
-- end
local function hasInferType(obj)

end
local function inTypes(param, args)
    for _, v in ipairs(args) do
        if param[1] == v[1] then
            return true
        end
    end
    return false
end
return function (uri, callback)
    local ast = files.getState(uri)
    if not ast then
        return
    end
    await.delay()
    guide.eachSourceType(ast.ast, 'call', function (source)
        if not source.args then
            return
        end
        local callArgs = source.args
        local callArgsType = {}
        for _, arg in ipairs(callArgs) do
            ---检查字面值类型的参数调用
            if guide.isLiteral(arg) then
                callArgsType[#callArgsType+1] = {
                    [1] = {
                        [1] = arg.type,
                        ['type'] = arg.type,
                    },
                    start = arg.start,
                    finish = arg.finish,
                }
            -- ---检查传入参数有完整信息的情况
            -- elseif hasInferType(arg) then
            --     callArgsType[#callArgsType+1] = {
            --         type = arg.node.bindDocs[1].types,
            --         start = arg.start,
            --         finish = arg.finish,
            --     }
            else
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
        end
        local func = source.node
        local defs = vm.getDefs(func)
        local funcArgsType
        local mark = {}
        local paramType = {}
        ---只检查有emmy注释定义的函数
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
                        ---变长参数不检查
                        elseif arg.name and arg.name[1] == '...' then
                            return
                        elseif arg.type == 'doc.type.arg' then
                            types = arg.extends.types
                        else
                            goto CONTINUE
                        end

                        ---如果是很复杂的type，比如泛型什么的，先不检查
                        if not types[1]
                        or not types[1][1]
                        or types[1].typeGeneric then
                            goto CONTINUE
                        end
                        funcArgsType[#funcArgsType+1] = types
                    end
                end
            else
                goto CONTINUE
            end
            if #funcArgsType == 0 then
                goto CONTINUE
            end
            paramType[#paramType+1] = funcArgsType
            ::CONTINUE::
        end
            ---先遍历实参
            for i, arg in ipairs(callArgsType) do
                local flag = ''
                local messages = {}
                ---遍历形参
                for _, par in ipairs(paramType) do
                    if not par[i] then
                        ---实参过多，由另一个检查来处理，此处跳过
                        goto CONTINUE
                    end
                    for _, param in ipairs(par[i]) do
                        ---如果形参的类型在实参里面
                        if inTypes(param, arg)
                        or param[1] == 'any'
                        or arg.type == 'any' then
                            flag = ''
                            goto HIT
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
                        messages[#messages+1] = message
                    end
                    ::CONTINUE::
                end
                ---都不匹配
                local norepeat = {}
                for _, m in ipairs(messages) do
                    if not norepeat[m] then
                        norepeat[m] = true
                        norepeat[#norepeat+1] = m
                    end
                end
                if #norepeat == 0 then
                    return
                end
                callback{
                    start   = arg.start,
                    finish  = arg.finish,
                    message = table.concat(norepeat, '\n')
                }
                ::HIT::
            end
            ---所有参数都匹配了
    end)

end
