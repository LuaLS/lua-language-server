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
    local buf = {}
    for i, ret in ipairs(viewData.returns) do
        if i == 1 then
            buf[i] = '  -> ' .. ret
        elseif i < 10 then
            buf[i] = '  {}. {}' % { i, ret }
        else
            buf[i] = '  {} {}' % { i, ret }
        end
    end

    return table.concat(buf, '\n')
end

ls.feature.provider.hover(function (param, action)
    local snode = param.vm:getNode(param.source)
    if not snode then
        return
    end

    snode:each('function', function (node)
        ---@cast node Node.Function
        if node:isDummy() then
            return
        end

        local viewData = node:makeView(ls.node.viewer {
            preferMethod = true,
        })
        local label = 'function {name}{typeParams}({args}){returns}' % {
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
