local stringify; do
    local level
    local buffer
    local visited
    local putValue

    local escape_char = {
        ["\\"..string.byte "\a"] = "\\".."a",
        ["\\"..string.byte "\b"] = "\\".."b",
        ["\\"..string.byte "\f"] = "\\".."f",
        ["\\"..string.byte "\n"] = "\\".."n",
        ["\\"..string.byte "\r"] = "\\".."r",
        ["\\"..string.byte "\t"] = "\\".."t",
        ["\\"..string.byte "\v"] = "\\".."v",
        ["\\"..string.byte "\\"] = "\\".."\\",
        ["\\"..string.byte "\""] = "\\".."\"",
    }

    local function quoted(s)
        return ("%q"):format(s):sub(2, -2):gsub("\\[1-9][0-9]?", escape_char):gsub("\\\n", "\\n")
    end

    local function isIdentifier(str)
        return type(str) == "string" and str:match "^[_%a][_%a%d]*$"
    end

    local typeOrders = {
        ["number"] = 1,
        ["boolean"] = 2,
        ["string"] = 3,
        ["table"] = 4,
        ["function"] = 5,
        ["userdata"] = 6,
        ["thread"] = 7,
        ["nil"] = 8,
    }

    local function sortKeys(a, b)
        local ta, tb = type(a), type(b)
        if ta == tb then
            if ta == "string" or ta == "number" then
                return a < b
            end
            return false
        end
        return typeOrders[ta] < typeOrders[tb]
    end

    local function getLength(t)
        local length = 1
        while rawget(t, length) ~= nil do
            length = length + 1
        end
        return length - 1
    end

    local function puts(v)
        buffer[#buffer+1] = v
    end

    local function down(f)
        level = level + 1
        f()
        level = level - 1
    end

    local function tabify()
        puts "\n"
        puts(string.rep("  ", level))
    end

    local function alreadyVisited(t)
        local v = visited[t]
        if not v then
            visited[t] = true
        end
        return v
    end

    local function putKey(k)
        if isIdentifier(k) then return puts(k) end
        puts "["
        putValue(k)
        puts "]"
    end

    local function putTable(t)
        if alreadyVisited(t) then
            puts "<table>"
            return
        end
        local keys = {}
        local length = getLength(t)
        for k in next, t do
            if math.type(k) ~= "integer" or k < 1 or k > length then
                keys[#keys+1] = k
            end
        end
        table.sort(keys, sortKeys)
        local mt = getmetatable(t)
        puts "{"
        down(function ()
            local first = true
            for i = 1, length do
                if not first then puts "," end
                puts " "
                putValue(rawget(t, i))
                first = false
            end
            for _, k in ipairs(keys) do
                if not first then puts "," end
                tabify()
                putKey(k)
                puts " = "
                putValue(rawget(t, k))
                first = false
            end
            if type(mt) == "table" then
                if not first then puts "," end
                tabify()
                puts "<metatable> = "
                putValue(mt)
            end
        end)
        if #keys > 0 or type(mt) == "table" then
            tabify()
        elseif length > 0 then
            puts " "
        end
        puts "}"
    end

    local function putTostring(v)
        puts "<"
        puts(tostring(v))
        puts ">"
    end

    local function putUserdata(u)
        local mt = debug.getmetatable(u)
        if mt and mt.__tostring then
            puts "<userdata:"
            puts(tostring(u))
            puts ">"
        else
            putTostring(u)
        end
    end

    local function putThread(t)
        putTostring(t)
    end

    local function putFunction(f)
        local info = debug.getinfo(f, "S")
        local type = info.source:sub(1, 1)
        if type == "@" then
            puts "<function:"
            puts(info.source:sub(2))
            puts ">"
        elseif type == "=" then
            putTostring(f)
        else
            puts "<function:"
            if #info.source > 64 then
                puts(info.source:sub(1, 64))
                puts "..."
            else
                puts(info.source)
            end
            puts ">"
        end
    end

    function putValue(v)
        local tv = type(v)
        if tv == "string" then
            puts(quoted(v))
        elseif tv == "number" or tv == "boolean" or tv == "nil" then
            puts(tostring(v))
        elseif tv == "table" then
            putTable(v)
        elseif tv == "userdata" then
            putUserdata(v)
        elseif tv == "function" then
            putFunction(v)
        else
            assert(tv == "thread")
            putThread(v)
        end
    end

    function stringify(root)
        level   = 0
        buffer  = {}
        visited = {}
        putValue(root)
        return table.concat(buffer)
    end
end

local undump_script = [[
local unpack_buf = ""
local unpack_pos = 1
local function unpack_setpos(...)
    unpack_pos = select(-1, ...)
    return ...
end
local function unpack(fmt)
    return unpack_setpos(fmt:unpack(unpack_buf, unpack_pos))
end

local function LoadByte()
    return unpack "B"
end

local function LoadNumber()
    return unpack "n"
end

local function LoadCharN(n)
    return unpack("c" .. tostring(n))
end

local undump53; do
    local function LoadInt()
        return unpack "i"
    end

    local function LoadInteger()
        return unpack "j"
    end

    local function LoadString()
        local size = LoadByte()
        if size == 0xFF then
            size = unpack "T"
        end
        if size == 0 then
            return nil
        end
        return LoadCharN(size - 1)
    end

    local LoadFunction

    local function LoadCode(f)
        f.sizecode = LoadInt()
        f.code = {}
        for i = 1, f.sizecode do
            f.code[i] = unpack "i4"
        end
    end

    local function LoadConstants(f)
        local function makevariant(t, v) return t | (v << 4) end
        local LUA_TNIL     = 0
        local LUA_TBOOLEAN = 1
        local LUA_TNUMBER  = 3
        local LUA_TSTRING  = 4
        local LUA_TNUMFLT  = makevariant(LUA_TNUMBER, 0)
        local LUA_TNUMINT  = makevariant(LUA_TNUMBER, 1)
        local LUA_TSHRSTR  = makevariant(LUA_TSTRING, 0)
        local LUA_TLNGSTR  = makevariant(LUA_TSTRING, 1)
        f.sizek            = LoadInt()
        f.k                = {}
        for i = 1, f.sizek do
            local t = LoadByte()
            if t == LUA_TNIL then
            elseif t == LUA_TBOOLEAN then
                f.k[i] = LoadByte()
            elseif t == LUA_TNUMFLT then
                f.k[i] = LoadNumber()
            elseif t == LUA_TNUMINT then
                f.k[i] = LoadInteger()
            elseif t == LUA_TSHRSTR then
                f.k[i] = LoadString()
            elseif t == LUA_TLNGSTR then
                f.k[i] = LoadString()
            else
                error(string.format("unknown constant type: <%d, %d>", t >> 4, t & 0xf))
            end
        end
    end

    local function LoadUpvalues(f)
        f.sizeupvalues = LoadInt()
        f.upvalues = {}
        for i = 1, f.sizeupvalues do
            f.upvalues[i] = {}
            f.upvalues[i].instack = LoadByte()
            f.upvalues[i].idx = LoadByte()
        end
    end

    local function LoadProtos(f)
        f.sizep = LoadInt()
        f.p = {}
        for i = 1, f.sizep do
            f.p[i] = {}
            LoadFunction(f.p[i], f.source)
        end
    end

    local function LoadDebug(f)
        f.sizelineinfo = LoadInt()
        f.lineinfo = {}
        for i = 1, f.sizelineinfo do
            f.lineinfo[i] = LoadInt()
        end
        f.sizelocvars = LoadInt()
        f.locvars = {}
        for i = 1, f.sizelocvars do
            f.locvars[i] = {}
            f.locvars[i].varname = LoadString()
            f.locvars[i].startpc = LoadInt()
            f.locvars[i].endpc = LoadInt()
        end
        local n = LoadInt()
        if n ~= 0 then
            n = f.sizeupvalues
        end
        for i = 1, n do
            f.upvalues[i].name = LoadString()
        end
    end

    function LoadFunction(f, psource)
        f.source = LoadString()
        if not f.source then
            f.source = psource
        end
        f.linedefined = LoadInt()
        f.lastlinedefined = LoadInt()
        f.numparams = LoadByte()
        f.is_vararg = LoadByte()
        f.maxstacksize = LoadByte()
        LoadCode(f)
        LoadConstants(f)
        LoadUpvalues(f)
        LoadProtos(f)
        LoadDebug(f)
        return f
    end

    local function CheckHeader()
        local LUAC_INT = 0x5678
        local LUAC_NUM = 370.5
        -- int
        assert(string.packsize "i" == LoadByte())
        -- size_t
        assert(string.packsize "T" == LoadByte())
        -- Instruction
        assert(string.packsize "i4" == LoadByte())
        -- lua_Integer
        assert(string.packsize "j" == LoadByte())
        -- lua_Number
        assert(string.packsize "n" == LoadByte())
        assert(LoadInteger() == LUAC_INT)
        assert(LoadNumber() == LUAC_NUM)
    end

    function undump53(cl)
        CheckHeader()
        cl.nupvalues = LoadByte()
        cl.f = {}
        LoadFunction(cl.f, nil)
    end
end

local undump54; do
    local function LoadInteger()
        return unpack "j"
    end

    local function LoadUnsigned(limit)
        local b
        local x = 0
        limit = limit >> 7
        repeat
            b = LoadByte()
            if x > limit then
                error("integer overflow")
            end
            x = (x << 7) | (b & 0x7f)
        until ((b & 0x80) ~= 0)
        return x
    end

    local function LoadInt()
        return LoadUnsigned(0x7fffffff)
    end

    local function LoadString()
        local size = LoadUnsigned(math.maxinteger)
        if size == 0 then
            return nil
        end
        return LoadCharN(size - 1)
    end

    local LoadFunction

    local function LoadCode(f)
        f.sizecode = LoadInt()
        f.code = {}
        for i = 1, f.sizecode do
            f.code[i] = unpack "i4"
        end
    end

    local function LoadConstants(f)
        local function makevariant(t, v) return t | (v << 4) end
        local LUA_TNIL     = 0
        local LUA_TBOOLEAN = 1
        local LUA_TNUMBER  = 3
        local LUA_TSTRING  = 4
        local LUA_VNIL     = makevariant(LUA_TNIL, 0)
        local LUA_VFALSE   = makevariant(LUA_TBOOLEAN, 0)
        local LUA_VTRUE    = makevariant(LUA_TBOOLEAN, 1)
        local LUA_VNUMINT  = makevariant(LUA_TNUMBER, 0)
        local LUA_VNUMFLT  = makevariant(LUA_TNUMBER, 1)
        local LUA_VSHRSTR  = makevariant(LUA_TSTRING, 0)
        local LUA_VLNGSTR  = makevariant(LUA_TSTRING, 1)
        f.sizek            = LoadInt()
        f.k                = {}
        for i = 1, f.sizek do
            local t = LoadByte()
            if t == LUA_VNIL then
            elseif t == LUA_VTRUE then
                f.k[i] = true
            elseif t == LUA_VFALSE then
                f.k[i] = false
            elseif t == LUA_VNUMFLT then
                f.k[i] = LoadNumber()
            elseif t == LUA_VNUMINT then
                f.k[i] = LoadInteger()
            elseif t == LUA_VSHRSTR or t == LUA_VLNGSTR then
                f.k[i] = LoadString()
            else
                error(string.format("unknown constant type: <%d, %d>", t >> 4, t & 0xf))
            end
        end
    end

    local function LoadUpvalues(f)
        f.sizeupvalues = LoadInt()
        f.upvalues = {}
        for i = 1, f.sizeupvalues do
            f.upvalues[i] = {}
            f.upvalues[i].instack = LoadByte()
            f.upvalues[i].idx = LoadByte()
            f.upvalues[i].kind = LoadByte()
        end
    end

    local function LoadProtos(f)
        f.sizep = LoadInt()
        f.p = {}
        for i = 1, f.sizep do
            f.p[i] = {}
            LoadFunction(f.p[i], f.source)
        end
    end

    local function LoadDebug(f)
        f.sizelineinfo = LoadInt()
        f.lineinfo = {}
        for i = 1, f.sizelineinfo do
            f.lineinfo[i] = unpack "b"
        end
        f.sizeabslineinfo = LoadInt()
        f.abslineinfo = {}
        for i = 1, f.sizeabslineinfo do
            f.abslineinfo[i] = {}
            f.abslineinfo[i].pc = LoadInt()
            f.abslineinfo[i].line = LoadInt()
        end
        f.sizelocvars = LoadInt()
        f.locvars = {}
        for i = 1, f.sizelocvars do
            f.locvars[i] = {}
            f.locvars[i].varname = LoadString()
            f.locvars[i].startpc = LoadInt()
            f.locvars[i].endpc = LoadInt()
        end
        local n = LoadInt()
        if n ~= 0 then
            n = f.sizeupvalues
        end
        for i = 1, n do
            f.upvalues[i].name = LoadString()
        end
    end

    function LoadFunction(f, psource)
        f.source = LoadString()
        if not f.source then
            f.source = psource
        end
        f.linedefined = LoadInt()
        f.lastlinedefined = LoadInt()
        f.numparams = LoadByte()
        f.is_vararg = LoadByte()
        f.maxstacksize = LoadByte()
        LoadCode(f)
        LoadConstants(f)
        LoadUpvalues(f)
        LoadProtos(f)
        LoadDebug(f)
        return f
    end

    local function CheckHeader()
        local LUAC_INT = 0x5678
        local LUAC_NUM = 370.5
        -- Instruction
        assert(string.packsize "i4" == LoadByte())
        -- lua_Integer
        assert(string.packsize "j" == LoadByte())
        -- lua_Number
        assert(string.packsize "n" == LoadByte())
        assert(LoadInteger() == LUAC_INT)
        assert(LoadNumber() == LUAC_NUM)
    end

    function undump54(cl)
        CheckHeader()
        cl.nupvalues = LoadByte()
        cl.f = {}
        LoadFunction(cl.f, nil)
    end
end

local undump55; do
    local cached = {}

    local function LoadAlign(align)
        local padding = align - (unpack_pos - 1) % align
        if padding < align then
            unpack_pos = unpack_pos + padding
            assert((unpack_pos - 1) % align == 0)
        end
    end

    local function LoadUnsigned(limit)
        local b
        local x = 0
        limit = limit >> 7
        repeat
            b = LoadByte()
            if x > limit then
                error("integer overflow")
            end
            x = (x << 7) | (b & 0x7f)
        until ((b & 0x80) == 0)
        return x
    end

    local function LoadInteger()
        local cx = LoadUnsigned(math.maxinteger)
        if (cx & 1) ~= 0 then
            return ~(cx >> 1)
        else
            return cx >> 1
        end
    end

    local function LoadInt()
        return LoadUnsigned(0x7fffffff)
    end

    local function LoadString()
        local size = LoadUnsigned(math.maxinteger)
        if size == 0 then
            local idx = LoadUnsigned(math.maxinteger)
            if idx == 0 then
                return nil
            end
            if not cached[idx] then
                error("invalid string index")
            end
            return cached[idx]
        end
        local str = LoadCharN(size)
        cached[#cached + 1] = str
        return str
    end

    local LoadFunction

    local function LoadCode(f)
        f.sizecode = LoadInt()
        LoadAlign(4)
        f.code = {}
        for i = 1, f.sizecode do
            f.code[i] = unpack "i4"
        end
    end

    local function LoadConstants(f)
        local function makevariant(t, v) return t | (v << 4) end
        local LUA_TNIL     = 0
        local LUA_TBOOLEAN = 1
        local LUA_TNUMBER  = 3
        local LUA_TSTRING  = 4
        local LUA_VNIL     = makevariant(LUA_TNIL, 0)
        local LUA_VFALSE   = makevariant(LUA_TBOOLEAN, 0)
        local LUA_VTRUE    = makevariant(LUA_TBOOLEAN, 1)
        local LUA_VNUMINT  = makevariant(LUA_TNUMBER, 0)
        local LUA_VNUMFLT  = makevariant(LUA_TNUMBER, 1)
        local LUA_VSHRSTR  = makevariant(LUA_TSTRING, 0)
        local LUA_VLNGSTR  = makevariant(LUA_TSTRING, 1)
        f.sizek            = LoadInt()
        f.k                = {}
        for i = 1, f.sizek do
            local t = LoadByte()
            if t == LUA_VNIL then
            elseif t == LUA_VTRUE then
                f.k[i] = true
            elseif t == LUA_VFALSE then
                f.k[i] = false
            elseif t == LUA_VNUMFLT then
                f.k[i] = LoadNumber()
            elseif t == LUA_VNUMINT then
                f.k[i] = LoadInteger()
            elseif t == LUA_VSHRSTR or t == LUA_VLNGSTR then
                f.k[i] = LoadString()
            else
                error(string.format("unknown constant type: <%d, %d>", t >> 4, t & 0xf))
            end
        end
    end

    local function LoadUpvalues(f)
        f.sizeupvalues = LoadInt()
        f.upvalues = {}
        for i = 1, f.sizeupvalues do
            f.upvalues[i] = {}
            f.upvalues[i].instack = LoadByte()
            f.upvalues[i].idx = LoadByte()
            f.upvalues[i].kind = LoadByte()
        end
    end

    local function LoadProtos(f)
        f.sizep = LoadInt()
        f.p = {}
        for i = 1, f.sizep do
            f.p[i] = {}
            LoadFunction(f.p[i], f.source)
        end
    end

    local function LoadDebug(f)
        f.sizelineinfo = LoadInt()
        f.lineinfo = {}
        for i = 1, f.sizelineinfo do
            f.lineinfo[i] = unpack "b"
        end
        f.sizeabslineinfo = LoadInt()
        f.abslineinfo = {}
        if f.sizeabslineinfo > 0 then
            LoadAlign(4)
            for i = 1, f.sizeabslineinfo do
                f.abslineinfo[i] = {}
                f.abslineinfo[i].pc = unpack "i"
                f.abslineinfo[i].line = unpack "i"
            end
        end
        f.sizelocvars = LoadInt()
        f.locvars = {}
        for i = 1, f.sizelocvars do
            f.locvars[i] = {}
            f.locvars[i].varname = LoadString()
            f.locvars[i].startpc = LoadInt()
            f.locvars[i].endpc = LoadInt()
        end
        local n = LoadInt()
        if n ~= 0 then
            n = f.sizeupvalues
        end
        for i = 1, n do
            f.upvalues[i].name = LoadString()
        end
    end

    function LoadFunction(f, psource)
        f.linedefined = LoadInt()
        f.lastlinedefined = LoadInt()
        f.numparams = LoadByte()
        f.is_vararg = LoadByte() & 3
        f.maxstacksize = LoadByte()
        LoadCode(f)
        LoadConstants(f)
        LoadUpvalues(f)
        LoadProtos(f)
        f.source = LoadString()
        if not f.source then
            f.source = psource
        end
        LoadDebug(f)
        return f
    end

    local function CheckHeader()
        local LUAC_INT = -0x5678
        local LUAC_INST = 0x12345678
        local LUAC_NUM = -370.5
        assert(string.packsize "i" == LoadByte())
        assert(unpack "i" == LUAC_INT)
        assert(string.packsize "i4" == LoadByte())
        assert(unpack "i4" == LUAC_INST)
        assert(string.packsize "j" == LoadByte())
        assert(unpack "j" == LUAC_INT)
        assert(string.packsize "n" == LoadByte())
        assert(unpack "n" == LUAC_NUM)
    end

    function undump55(cl)
        CheckHeader()
        cl.nupvalues = LoadByte()
        cl.f = {}
        LoadFunction(cl.f, nil)
    end
end

return function(bytes)
    unpack_pos = 1
    unpack_buf = bytes
    assert(LoadCharN(4) == "\x1bLua")
    local Version = LoadByte()
    assert(LoadByte() == 0)
    assert(LoadCharN(6) == "\x19\x93\r\n\x1a\n")
    local cl = {}
    if Version == 0x53 then
        undump53(cl)
    elseif Version == 0x54 then
        undump54(cl)
    elseif Version == 0x55 then
        undump55(cl)
    else
        error(("unknown lua version: 0x%x"):format(Version))
    end
    assert(unpack_pos == #unpack_buf + 1)
    assert(cl.nupvalues == cl.f.sizeupvalues)
    return cl, Version
end
]]

local coverage = {}; do
    local include = {}
    local undump
    local enable = false

    local function nextline(proto, abs, currentline, pc)
        local line = proto.lineinfo[pc]
        if line == -128 then
            return assert(abs[pc - 1])
        else
            return currentline + line
        end
    end

    local function calc_actives_55(proto, actives)
        local currentline = proto.linedefined
        local abs = {}
        for _, line in ipairs(proto.abslineinfo) do
            abs[line.pc] = line.line
        end
        local start = 1
        if proto.is_vararg > 0 then
            local OP_VARARGPREP = 83
            assert(proto.code[1] % 128 == OP_VARARGPREP)
            currentline = nextline(proto, abs, currentline, 1)
            start = 2
        end
        for pc = start, #proto.lineinfo do
            currentline = nextline(proto, abs, currentline, pc)
            actives[currentline] = true
        end
        for i = 1, proto.sizep do
            calc_actives_55(proto.p[i], actives)
        end
    end

    local function calc_actives_54(proto, actives)
        local currentline = proto.linedefined
        local abs = {}
        for _, line in ipairs(proto.abslineinfo) do
            abs[line.pc] = line.line
        end
        local start = 1
        if proto.is_vararg > 0 then
            local OP_VARARGPREP = 81
            assert(proto.code[1] % 128 == OP_VARARGPREP)
            currentline = nextline(proto, abs, currentline, 1)
            start = 2
        end
        for pc = start, #proto.lineinfo do
            currentline = nextline(proto, abs, currentline, pc)
            actives[currentline] = true
        end
        for i = 1, proto.sizep do
            calc_actives_54(proto.p[i], actives)
        end
    end

    local function calc_actives_53(proto, actives)
        for _, line in ipairs(proto.lineinfo) do
            actives[line] = true
        end
        for i = 1, proto.sizep do
            calc_actives_53(proto.p[i], actives)
        end
    end

    local function get_actives(source)
        local prefix = source:sub(1, 1)
        if prefix == "=" then
            return {}
        end
        if prefix == "@" then
            local f = assert(io.open(source:sub(2)))
            source = f:read "a"
            f:close()
        end
        local cl, version = undump(string.dump(assert(load(source))))
        local actives = {}
        if version >= 0x55 then
            calc_actives_55(cl.f, actives)
        elseif version == 0x54 then
            calc_actives_54(cl.f, actives)
        else
            calc_actives_53(cl.f, actives)
        end
        return actives
    end

    local function sortpairs(t)
        local sort = {}
        for k in pairs(t) do
            sort[#sort+1] = k
        end
        table.sort(sort)
        local n = 1
        return function ()
            local k = sort[n]
            if k == nil then
                return
            end
            n = n + 1
            return k, t[k]
        end
    end

    local function debug_hook(_, lineno)
        local file = include[debug.getinfo(2, "S").source]
        if file then
            file[lineno] = true
        end
    end

    function coverage.start()
        enable = true
        undump = assert(load(undump_script))()
        debug.sethook(debug_hook, "l")
    end

    function coverage.include(name)
        if not enable then
            return
        end
        local path = assert(package.searchpath(name, package.path))
        local f = assert(loadfile(path))
        local source = debug.getinfo(f, "S").source
        if include[source] then
            include[source].name = name
        else
            include[source] = { name = name }
        end
    end

    function coverage.stop()
        if not enable then
            return
        end
        debug.sethook()
    end

    function coverage.print_result()
        if not enable then
            return
        end
        local str = {}
        for source, file in sortpairs(include) do
            local actives = get_actives(source)
            local max = 0
            for i in pairs(actives) do
                if i > max then max = i end
            end
            local total = 0
            local pass = 0
            local status = {}
            local lines = {}
            for i = 1, max do
                if not actives[i] then
                    status[#status+1] = "."
                elseif file[i] then
                    total = total + 1
                    pass = pass + 1
                    status[#status+1] = "."
                else
                    total = total + 1
                    status[#status+1] = "X"
                    lines[#lines+1] = tostring(i)
                end
            end
            str[#str+1] = string.format("coverage: %02.02f%% (%d/%d) module `%s`", pass / total * 100, pass, total, file.name)
            if #lines > 0 then
                str[#str+1] = table.concat(lines, " ")
                str[#str+1] = table.concat(status)
            end
        end
        print(table.concat(str, "\n"))
    end
end

local m = {}

local function split(str)
    local r = {}
    str:gsub("[^\n]+", function (w) r[#r+1] = w end)
    return r
end

local sourcename = debug.getinfo(1, "S").source:match "[/\\]([^/\\]*)%.lua$"
local sourcepatt = "[/\\]"..sourcename.."%.lua:%d+: "
local function pretty_trace(funcName, stackTrace)
    local function isInternalLine(s)
        return s:find(sourcepatt) ~= nil
    end
    local lst = split(stackTrace)
    local n = #lst
    local first, last = n, n
    for i = 2, n do
        if not isInternalLine(lst[i]) then
            first = i
            break
        end
    end
    for i = first + 1, n do
        if isInternalLine(lst[i]) then
            last = i - 1
            break
        end
    end
    lst[first - 1] = lst[1]
    local trace = table.concat(lst, "\n", first - 1, last)
    trace = trace:gsub("in (%a+) 'methodInstance'", "in %1 '"..funcName.."'")
    return trace
end

local function recursion_get(t, actual)
    local subtable = t[actual]
    if not subtable then
        subtable = {}
        t[actual] = subtable
    end
    return subtable
end

local equals_value

local function equals_table(actual, expected, recursions)
    local actual_n = 0
    for k, v in pairs(actual) do
        if not equals_value(v, expected[k], recursions) then
            return false
        end
        actual_n = actual_n + 1
    end
    local expected_n = 0
    for _ in pairs(expected) do
        expected_n = expected_n + 1
    end
    if actual_n ~= expected_n then
        return false
    end
    return equals_value(getmetatable(actual), getmetatable(expected), recursions)
end

function equals_value(actual, expected, recursions)
    if actual == expected then
        return true
    end
    if type(actual) ~= type(expected) then
        return false
    end
    if type(actual) ~= "table" then
        return actual == expected
    end
    local subtable = recursion_get(recursions, actual)
    local previous = subtable[expected]
    if previous ~= nil then
        return previous
    end
    subtable[expected] = true
    local ok = equals_table(actual, expected, recursions)
    subtable[expected] = ok
    return ok
end

local function equals(actual, expected)
    local recursions = {}
    return equals_value(actual, expected, recursions)
end

local function failure(...)
    error(string.format(...), 3)
end

function m.equals(actual, expected)
    return equals(actual, expected)
end

function m.failure(...)
    failure(...)
end

function m.assertEquals(actual, expected, errmsg)
    if not equals(actual, expected) then
        failure("expected: %s, actual: %s.%s", stringify(expected), stringify(actual), errmsg or "")
    end
end

function m.assertNotEquals(actual, expected, errmsg)
    if equals(actual, expected) then
        failure("Received the not expected value: %s.%s", stringify(actual), errmsg or "")
    end
end

function m.assertFailed(expected_errmsg, actual, actual_errmsg)
    if actual ~= nil then
        failure("No failed but expected errmsg: %s", stringify(expected_errmsg))
    end
    if not equals(actual_errmsg, expected_errmsg) then
        failure("expected errmsg: %s, actual errmsg: %s.", stringify(expected_errmsg), stringify(actual_errmsg))
    end
end

function m.assertError(f, ...)
    if pcall(f, ...) then
        failure("Expected an error when calling function but no error generated")
    end
end

function m.assertErrorMsgEquals(expectedMsg, func, ...)
    local success, actualMsg = pcall(func, ...)
    if success then
        failure("No error generated when calling function but expected error: %s", stringify(expectedMsg))
    end
    m.assertEquals(actualMsg, expectedMsg)
end

for _, name in ipairs { "Nil", "Number", "String", "Table", "Boolean", "Function", "Userdata", "Thread" } do
    local typeExpected = name:lower()
    m["assertIs"..name] = function (value, errmsg)
        if type(value) ~= typeExpected then
            failure("expected: a %s value, actual: type %s, value %s. (%s)", typeExpected, type(value), stringify(value), errmsg or "")
        end
        return value
    end
end

local function parseCmdLine(cmdLine)
    local result = {}
    local i = 1
    while i <= #cmdLine do
        local cmdArg = cmdLine[i]
        if cmdArg:sub(1, 1) == "-" then
            if cmdArg == "--verbose" or cmdArg == "-v" then
                result.verbosity = true
            elseif cmdArg == "--shuffle" or cmdArg == "-s" then
                result.shuffle = true
            elseif cmdArg == "--coverage" or cmdArg == "-c" then
                result.coverage = true
            elseif cmdArg == "--list" or cmdArg == "-l" then
                result.list = true
            elseif cmdArg == "--touch" then
                i = i + 1
                result.touch = cmdLine[i]
            else
                error("Unknown option: "..cmdArg)
            end
        else
            result[#result+1] = cmdArg
        end
        i = i + 1
    end
    return result
end
local options = parseCmdLine(rawget(_G, "arg") or {})
local marks = {}
local output = io.stdout

local _XPASS_ = "XPASS"
local _IGNORE_ = "IGNORE"
local _SKIP_ = "SKIP"

local function setMark(name, v)
    local className, methodName = name:match "^([^.]+)%.([^.]+)$"
    if className and methodName then
        local classMark = marks[className]
        if classMark == nil then
            marks[className] = { [methodName] = v }
        else
            classMark[methodName] = v
        end
        return
    end
    className = name:match "^[^.]+$"
    if className then
        local classMark = marks[className]
        if classMark == nil then
            marks[className] = { v }
        else
            classMark[1] = v
        end
        return
    end
    error("invalid test name: "..name)
end

local function getMark(className, methodName)
    local classMark = marks[className]
    if classMark == nil then
        return _XPASS_
    end
    if classMark[methodName] then
        return classMark[methodName]
    end
    return classMark[1] or _XPASS_
end

local function printTestName(name)
    if options.verbosity then
        output:write("    ", name, " ... ")
        output:flush()
    end
end

local function printTestSuccess()
    if options.verbosity then
        output:write("Ok\n")
    else
        output:write(".")
    end
    output:flush()
end

local function printTestFailed(errmsg)
    if options.verbosity then
        output:write("FAIL\n", errmsg, "\n")
    else
        output:write("F")
    end
    output:flush()
end

local function printTestSkipped()
    if options.verbosity then
        output:write("Skipped\n")
    else
        output:write(".")
    end
    output:flush()
end

local function print(msg)
    if msg then
        output:write(msg, "\n")
    else
        output:write("\n")
    end
end

local function errorHandler(e)
    return { msg = e, trace = string.sub(debug.traceback("", 3), 2) }
end

local function execFunction(failures, name, classInstance, methodInstance, mark)
    if mark == _IGNORE_ then
        return
    end
    printTestName(name)
    if mark == _SKIP_ then
        printTestSkipped()
        return
    end
    local ok, err = xpcall(function () methodInstance(classInstance) end, errorHandler)
    if ok then
        printTestSuccess()
        return true
    else
        if type(err) == "string" then
            err = { msg = err, name = name, trace = "" }
        else
            ---@cast err -nil
            err.name = name
            err.trace = pretty_trace(name, err.trace)
            if type(err.msg) ~= "string" then
                err.msg = stringify(err.msg)
            end
        end
        failures[#failures+1] = err
        printTestFailed(err.msg)
    end
end

local function matchPattern(expr, patterns)
    for _, pattern in ipairs(patterns) do
        if expr:find(pattern) then
            return true
        end
    end
end

local function randomizeTable(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        if i ~= j then
            t[i], t[j] = t[j], t[i]
        end
    end
end

local function selectList(instanceSet)
    local lst = {}
    for _, className in ipairs(instanceSet) do
        local instance = instanceSet[className]
        for _, methodName in ipairs(instance) do
            local mark = getMark(className, methodName)
            lst[#lst+1] = { m.format(className, methodName), instance, instance[methodName], mark }
        end
    end
    if options.shuffle then
        randomizeTable(lst)
    end
    local patterns = options
    if #patterns == 0 then
        return lst
    end
    local includedPattern, excludedPattern = {}, {}
    for _, pattern in ipairs(patterns) do
        if pattern:sub(1, 1) == "~" then
            excludedPattern[#excludedPattern+1] = pattern:sub(2)
        else
            includedPattern[#includedPattern+1] = pattern
        end
    end
    if #includedPattern ~= 0 then
        for _, v in ipairs(lst) do
            local expr = v[1]
            if not matchPattern(expr, includedPattern) or matchPattern(expr, excludedPattern) then
                v[4] = _IGNORE_
            end
        end
    else
        for _, v in ipairs(lst) do
            local expr = v[1]
            if matchPattern(expr, excludedPattern) then
                v[4] = _IGNORE_
            end
        end
    end
    return lst
end

local function showList(selected)
    for _, v in ipairs(selected) do
        local name = v[1]
        print(name)
    end
    return true
end

local instanceSet = {}

function m.test(name)
    if instanceSet[name] then
        return instanceSet[name]
    end
    local instance = setmetatable({}, {
        __newindex = function (self, k, v)
            if type(v) == "function" then
                rawset(self, #self + 1, k)
            end
            rawset(self, k, v)
        end
    })
    instanceSet[name] = instance
    instanceSet[#instanceSet+1] = name
    return instance
end

function m.format(className, methodName)
    return className.."."..methodName
end

local function touch(file)
    local isWindowsShell; do
        if options.shell then
            isWindowsShell = options.shell ~= "sh"
        else
            local isWindows = package.config:sub(1, 1) == "\\"
            local isMingw = os.getenv "MSYSTEM" ~= nil
            isWindowsShell = (isWindows) and (not isMingw)
        end
    end
    if isWindowsShell then
        os.execute("type nul > "..file)
    else
        os.execute("touch "..file)
    end
end

function m.run()
    local selected = selectList(instanceSet)
    if options.list then
        return showList(selected)
    end
    if options.verbosity then
        print("Started on "..os.date())
    end
    local successes = 0
    local failures = {}
    collectgarbage "collect"
    local startTime = os.clock()
    for _, v in ipairs(selected) do
        local name, instance, methodInstance, mark = v[1], v[2], v[3], v[4]
        if execFunction(failures, name, instance, methodInstance, mark) then
            successes = successes + 1
        end
    end
    local duration = os.clock() - startTime
    coverage.stop()
    if options.verbosity then
        print("=========================================================")
    else
        print()
    end
    if #failures ~= 0 then
        print("Failed tests:")
        print("-------------")
        for i, err in ipairs(failures) do
            print(i..") "..err.name)
            print(err.msg)
            print(err.trace)
            print()
        end
    end
    coverage.print_result()
    local skipped = #selected - successes - #failures
    if skipped <= 0 then
        print(string.format("Ran %d tests in %0.3f seconds, %d successes, %d failures", #selected, duration, successes, #failures))
    else
        print(string.format("Ran %d tests in %0.3f seconds, %d successes, %d failures, %d skipped", #selected, duration, successes, #failures, skipped))
    end
    if #failures == 0 then
        print("OK")
        if options.touch then
            touch(options.touch)
        end
        return 0
    end
    return 1
end

function m.skip(name)
    setMark(name, _SKIP_)
end

function m.moduleCoverage(name)
    coverage.include(name)
end

m.options = options
m.stringify = stringify

if options.coverage then
    local major, minor = _VERSION:match "Lua (%d)%.(%d)"
    if major == "5" then
        if minor == "3" or minor == "4" or minor == "5" then
            coverage.start()
        end
    end
end

return m
