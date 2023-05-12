local cdriver = {}

local cpp = require("plugins.ffi.c-parser.cpp")
local c99 = require("plugins.ffi.c-parser.c99")
local ctypes = require("plugins.ffi.c-parser.ctypes")
local cdefines = require("plugins.ffi.c-parser.cdefines")

function cdriver.process_file(filename)
    local ctx, err = cpp.parse_file(filename)
    if not ctx then
        return nil, "failed preprocessing '"..filename.."': " .. err
    end

    local srccode = table.concat(ctx.output, "\n").." $EOF$"

    local res, err, line, col, fragment = c99.match_language_grammar(srccode)
    if not res then
        return nil, ("failed parsing: %s:%d:%d: %s\n%s"):format(filename, line, col, err, fragment)
    end

    local ffi_types, err = ctypes.register_types(res)
    if not ffi_types then
        return nil, err
    end

    cdefines.register_defines(ffi_types, ctx.defines)

    return ffi_types
end

function cdriver.process_context(context)
    local ctx, err = cpp.parse_context(context)
    if not ctx then
        return nil, "failed preprocessing '"..context.."': " .. err
    end

    local srccode = table.concat(ctx.output, "\n").." $EOF$"

    local res, err, line, col, fragment = c99.match_language_grammar(srccode)
    if not res then
        return nil, ("failed parsing: %s:%d:%d: %s\n%s"):format(context, line, col, err, fragment)
    end

    local ffi_types, err = ctypes.register_types(res)
    if not ffi_types then
        return nil, err
    end

    cdefines.register_defines(ffi_types, ctx.defines)

    return ffi_types
end

return cdriver
