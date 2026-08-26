---@class Feature.Diagnostic.Define
local M = {}

M.DiagnosticSeverity = ls.spec.DiagnosticSeverity

---@class Feature.Diagnostic.Info
---@field severity string
---@field status string
---@field group string

M.diagnosticDatas  = {}
M.diagnosticGroups = {}

---@param names string[]
---@return fun(info: Feature.Diagnostic.Info)
function M.register(names)
    return function (info)
        for _, name in ipairs(names) do
            M.diagnosticDatas[name] = {
                severity = info.severity,
                status   = info.status,
            }
            local group = M.diagnosticGroups[info.group]
            if not group then
                group = {}
                M.diagnosticGroups[info.group] = group
            end
            group[name] = true
        end
    end
end

---@param name string
---@return string[]
function M.getGroups(name)
    local groups = {}
    for groupName, names in pairs(M.diagnosticGroups) do
        if names[name] then
            groups[#groups+1] = groupName
        end
    end
    return groups
end

M.register {
    'empty-block',
    'unused-local',
    'unused-function',
    'unused-label',
    'unused-vararg',
    'trailing-space',
    'redundant-return',
    'code-after-break',
} {
    group    = 'unused',
    severity = 'Hint',
    status   = 'Opened',
}

M.register {
    'redefined-local',
} {
    group    = 'redefined',
    severity = 'Warning',
    status   = 'Any',
}

M.register {
    'duplicate-index',
} {
    group    = 'duplicate',
    severity = 'Warning',
    status   = 'Any',
}

M.register {
    'duplicate-doc-param',
    'unknown-diag-code',
    'undefined-doc-param',
} {
    group    = 'luadoc',
    severity = 'Warning',
    status   = 'Any',
}

M.register {
    'unbalanced-assignments',
    'redundant-value',
} {
    group    = 'unbalanced',
    severity = 'Warning',
    status   = 'Any',
}

M.register {
    'lowercase-global',
} {
    group    = 'global',
    severity = 'Information',
    status   = 'Any',
}

M.register {
    'count-down-loop',
    'newline-call',
    'newfield-call',
} {
    group    = 'ambiguity',
    severity = 'Warning',
    status   = 'Any',
}

M.register {
    'close-non-object',
} {
    group    = 'strict',
    severity = 'Warning',
    status   = 'Any',
}

M.register {
    'undefined-field',
} {
    group    = 'type-check',
    severity = 'Warning',
    status   = 'Opened',
}

M.register {
    'undefined-global',
} {
    group    = 'global',
    severity = 'Warning',
    status   = 'Any',
}

---@param scope Scope
---@param uri Uri
---@param name string
---@return integer
function M.getSeverity(scope, uri, name)
    local severityConfig = scope.config:get(uri, 'Lua.diagnostics.severity') or {}
    local data = M.diagnosticDatas[name]
    local severity = severityConfig[name] or (data and data.severity) or 'Warning'
    if severity:sub(-1) == '!' then
        return M.DiagnosticSeverity[severity:sub(1, -2)]
    end

    local groupSeverity = scope.config:get(uri, 'Lua.diagnostics.groupSeverity') or {}
    local groupLevel
    for _, groupName in ipairs(M.getGroups(name)) do
        local gseverity = groupSeverity[groupName]
        if gseverity and gseverity ~= 'Fallback' then
            local level = M.DiagnosticSeverity[gseverity]
            if level and (not groupLevel or level < groupLevel) then
                groupLevel = level
            end
        end
    end
    if not groupLevel then
        return M.DiagnosticSeverity[severity]
    end
    return groupLevel
end

---@param scope Scope
---@param uri Uri
---@param name string
---@return string
function M.getFileStatus(scope, uri, name)
    local statusConfig = scope.config:get(uri, 'Lua.diagnostics.neededFileStatus') or {}
    local data = M.diagnosticDatas[name]
    local status = statusConfig[name] or (data and data.status) or 'Any'
    if status:sub(-1) == '!' then
        return status:sub(1, -2)
    end

    local groupFileStatus = scope.config:get(uri, 'Lua.diagnostics.groupFileStatus') or {}
    for _, groupName in ipairs(M.getGroups(name)) do
        local gstatus = groupFileStatus[groupName]
        if gstatus and gstatus ~= 'Fallback' then
            return gstatus
        end
    end
    return status
end

return M
