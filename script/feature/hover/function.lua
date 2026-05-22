---@param viewData Node.Function.ViewData
---@return string
local function buildName(viewData)
    return viewData.name
end

---@param viewData Node.Function.ViewData
---@return string
local function buildTypeParams(viewData)
    return viewData.typeParamPart
end

---@param viewData Node.Function.ViewData
---@return string
local function buildArgs(viewData)
    return viewData.paramPart
end

---@param viewData Node.Function.ViewData
---@return string
local function buildReturns(viewData)
    if #viewData.returns == 0 then
        return ''
    end
    local buf = { '' }
    for i, ret in ipairs(viewData.returns) do
        if i == 1 then
            buf[#buf+1] = '  -> ' .. ret
        elseif i < 10 then
            buf[#buf+1] = '  {}. {}' % { i, ret }
        else
            buf[#buf+1] = '  {} {}' % { i, ret }
        end
    end

    return table.concat(buf, '\n')
end

---从 Node 中找到第一个有名字的 function，返回其名字字符串，否则返回 ''
---@param node Node
---@return string
local function resolveFuncName(node)
    local name = ''
    node:each('function', function (f)
        ---@cast f Node.Function
        if name ~= '' then return end
        local viewData = f:makeView(ls.node.viewer { preferMethod = true })
        if viewData.name ~= '' then
            name = viewData.name
        end
    end)
    return name
end

ls.feature.provider.hover(function (param, action)
    local snode = param.vm:getNode(param.source)
    if not snode then
        return
    end

    snode = snode:simplify()

    -- 调用上下文：当 hover 在调用表达式的 head 上时，根据实参匹配最优 overload
    local source = param.source
    if  source.parent
    and source.parent.kind == 'call'
    and source.parent.node == source
    then
        local fcallNode = param.vm:getNode(source.parent)
        if fcallNode and fcallNode.kind == 'fcall' then
            ---@cast fcallNode Node.FCall
            local matchedFuncs = fcallNode.matchedFuncs
            if #matchedFuncs > 0 then
                local varName = resolveFuncName(snode)
                for _, node in ipairs(matchedFuncs) do
                    local viewData = node:makeView(ls.node.viewer {
                        preferMethod = true,
                        noFunctionDetail = true,
                    })
                    if viewData.name == '' and varName ~= '' then
                        viewData.name = varName
                    end
                    local label = '{async}function {name}{typeParams}({args}){returns}' % {
                        async      = viewData.async ~= '' and 'async ' or '',
                        name       = buildName(viewData),
                        typeParams = buildTypeParams(viewData),
                        args       = buildArgs(viewData),
                        returns    = buildReturns(viewData),
                    }
                    action.push {
                        label = label,
                    }
                end
                return
            end
        end
    end

    -- 默认路径：展示所有函数签名
    snode:each('function', function (node)
        ---@cast node Node.Function
        if node:isDummy() then
            return
        end

        local viewData = node:makeView(ls.node.viewer {
            preferMethod = true,
            noFunctionDetail = true,
        })
        local label = '{async}function {name}{typeParams}({args}){returns}' % {
            async      = viewData.async ~= '' and 'async ' or '',
            name       = buildName(viewData),
            typeParams = buildTypeParams(viewData),
            args       = buildArgs(viewData),
            returns    = buildReturns(viewData),
        }

        action.push {
            label = label,
        }
    end)
end)
