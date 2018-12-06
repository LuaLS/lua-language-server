local DiagnosticSeverity = {
    Error       = 1,
    Warning     = 2,
    Information = 3,
    Hint        = 4,
}

--[[
/**
 * Represents a related message and source code location for a diagnostic. This should be
 * used to point to code locations that cause or related to a diagnostics, e.g when duplicating
 * a symbol in a scope.
 */
export interface DiagnosticRelatedInformation {
    /**
     * The location of this related diagnostic information.
     */
    location: Location;

    /**
     * The message of this related diagnostic information.
     */
    message: string;
}
]]--

return function (ast, results)
    local diagnostics = {}

    diagnostics[1] = {
        range = {
            start = {
                line = 0,
                character = 0,
            },
            ['end'] = {
                line = 0,
                character = 10,
            },
        },
        severity = DiagnosticSeverity.Warning,
        code = 'I am code',
        source = 'I am source',
        message = 'I am message',
        relatedInformation = nil,
    }

    return diagnostics
end
