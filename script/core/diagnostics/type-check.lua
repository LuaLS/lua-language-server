local files  = require 'files'
local guide  = require 'parser.guide'
local vm     = require 'vm'

local function hasTypeDoc(obj)
    if obj.type == 'getlocal'
    and obj.node
    and obj.node.type == 'local'
    and obj.node.bindDocs
    and obj.node.bindDocs[1]
    and obj.node.bindDocs[1].type == 'doc.type' then
        return true
    end
    return false
end
local function inTypes(param, args)
    for _, v in ipairs(args.type) do
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
                    type = {
                        [1] = {
                            [1] = arg.type,
                            ['type'] = arg.type,
                        }
                    },
                    start = arg.start,
                    finish = arg.finish,
                }
            ---检查传入参数有完整信息的情况
            elseif hasTypeDoc(arg) then
                callArgsType[#callArgsType+1] = {
                    type = arg.node.bindDocs[1].types,
                    start = arg.start,
                    finish = arg.finish,
                }
            else
                return
            end
        end
        local func = source.node
        local defs = vm.getDefs(func)
        local funcArgsType = {}
        ---只检查有emmy注释定义的函数
        ---获取函数定义的参数信息时，遇到一个定义就停止获取
        for _, def in ipairs(defs) do
            if def.value then
                def = def.value
            end
            if def.type == 'function' then
                if def.args then
                    for _, arg in ipairs(def.args) do
                        if arg.docParam and arg.docParam.extends then
                            ---如果是很复杂的type，比如泛型什么的，先不检查
                            if not arg.docParam.extends.types[1][1]
                            or arg.docParam.extends.types[1].typeGeneric then
                                return
                            end
                            funcArgsType[#funcArgsType+1] = arg.docParam.extends.types
                        else
                            funcArgsType = {}
                        end
                    end
                end
                break
            end
        end
        if #funcArgsType == 0 then
            return
        end
        local message = ''
        ---先遍历实参
        for i, arg in ipairs(callArgsType) do
            if not funcArgsType[i] then
                ---由另一个检查来处理
                -- message = 'too many call args'
                -- callback{
                --     start   = arg.start,
                --     finish  = arg.finish,
                --     message = message
                -- }
                return
            end
            local flag = ''
            ---遍历形参
            for _, tp in ipairs(funcArgsType[i]) do
                ---如果形参的类型在实参里面
                if inTypes(tp, arg)
                or tp[1] == 'any'
                or arg.type == 'any' then
                    flag = ''
                    break
                else
                    flag = flag ..' ' .. tp[1]
                end
            end
            if flag ~= '' then
                local argm = '[ '
                for _, v in ipairs(arg.type) do
                    argm = argm .. v[1]..' '
                end
                argm = argm .. ']'
                message = 'callArg: '..argm..' has no type belong to ['..flag..' ]'
                callback{
                    start   = arg.start,
                    finish  = arg.finish,
                    message = message
                }
                return
            end
        end
    end)

end
