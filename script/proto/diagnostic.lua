---@class proto.diagnostic
local m = {}

---@alias DiagnosticSeverity
---| 'Hint'
---| 'Information'
---| 'Warning'
---| 'Error'

---@alias DiagnosticNeededFileStatus
---| 'Any'
---| 'Opened'
---| 'None'

---@class proto.diagnostic.info
---@field severity DiagnosticSeverity
---@field status   DiagnosticNeededFileStatus
---@field group    string

m.diagnosticDatas  = {}
m.diagnosticGroups = {}

function m.register(names)
    ---@param info proto.diagnostic.info
    return function (info)
        for _, name in ipairs(names) do
            m.diagnosticDatas[name] = {
                severity = info.severity,
                status   = info.status,
            }
            if not m.diagnosticGroups[info.group] then
                m.diagnosticGroups[info.group] = {}
            end
            m.diagnosticGroups[info.group][name] = true
        end
    end
end

m.register {
    'unused-local',
    'unused-function',
    'unused-label',
    'unused-vararg',
    'trailing-space',
    'redundant-return',
    'empty-block',
    'code-after-break',
} {
    group    = 'unused',
    severity = 'Hint',
    status   = 'Opened',
}

m.register {
    'redundant-value',
    'unbalanced-assignments',
    'redundant-parameter',
    'missing-parameter',
} {
    group    = 'unbalanced',
    severity = 'Warning',
    status   = 'Any',
}

m.register {
    'need-check-nil',
    'undefined-field',
    'cast-local-type',
    'assign-type-mismatch',
    'param-type-mismatch',
    'cast-type-mismatch',
} {
    group    = 'type-check',
    severity = 'Warning',
    status   = 'Opened',
}

m.register {
    'duplicate-doc-alias',
    'undefined-doc-class',
    'undefined-doc-name',
    'circle-doc-class',
    'undefined-doc-param',
    'duplicate-doc-param',
    'doc-field-no-class',
    'duplicate-doc-field',
    'unknown-diag-code',
    'unknown-cast-variable',
    'cast-type-mismatch',
} {
    group    = 'luadoc',
    severity = 'Warning',
    status   = 'Any',
}

m.register {
    'codestyle-check'
} {
    group    = 'codestyle',
    severity = 'Warning',
    status   = 'None',
}

m.register {
    'spell-check'
} {
    group    = 'codestyle',
    severity = 'Information',
    status   = 'None',
}

m.register {
    'newline-call',
    'newfield-call',
    'ambiguity-1',
    'count-down-loop',
    'different-requires',
} {
    group    = 'ambiguity',
    severity = 'Warning',
    status   = 'Any',
}

m.register {
    'await-in-sync',
    'not-yieldable',
} {
    group    = 'await',
    severity = 'Warning',
    status   = 'None',
}

m.register {
    'no-unknown',
} {
    group    = 'no-unknown',
    severity = 'Warning',
    status   = 'None',
}

m.register {
    'redefined-local',
} {
    group    = 'redefined',
    severity = 'Hint',
    status   = 'Opened',
}

m.register {
    'undefined-global',
    'global-in-nil-env',
} {
    group    = 'global',
    severity = 'Warning',
    status   = 'Any',
}

m.register {
    'lowercase-global',
    'undefined-env-child',
} {
    group    = 'global',
    severity = 'Information',
    status   = 'Any',
}

m.register {
    'duplicate-index',
    'duplicate-set-field',
} {
    group    = 'duplicate',
    severity = 'Warning',
    status   = 'Any',
}

m.register {
    'close-non-object',
    'deprecated',
    'discard-returns',
} {
    group    = 'strict',
    severity = 'Warning',
    status   = 'Any',
}

---@return table<string, DiagnosticSeverity>
function m.getDefaultSeverity()
    local severity = {}
    for name, info in pairs(m.diagnosticDatas) do
        severity[name] = info.severity
    end
    return severity
end

---@return table<string, DiagnosticNeededFileStatus>
function m.getDefaultStatus()
    local status = {}
    for name, info in pairs(m.diagnosticDatas) do
        status[name] = info.status
    end
    return status
end

return m
