-- $Id: re.lua,v 1.44 2013/03/26 20:11:40 roberto Exp $

-- imported functions and modules
local tonumber, type, print, error = tonumber, type, print, error
local pcall = pcall
local setmetatable = setmetatable
local tinsert, concat = table.insert, table.concat
local rep = string.rep
local m = require"lpeglabel"

-- 'm' will be used to parse expressions, and 'mm' will be used to
-- create expressions; that is, 're' runs on 'm', creating patterns
-- on 'mm'
local mm = m

-- pattern's metatable
local mt = getmetatable(mm.P(0))



-- No more global accesses after this point
_ENV = nil


local any = m.P(1)


local errinfo = {
  NoPatt = "no pattern found",
  ExtraChars = "unexpected characters after the pattern",

  ExpPatt1 = "expected a pattern after '/'",

  ExpPatt2 = "expected a pattern after '&'",
  ExpPatt3 = "expected a pattern after '!'",

  ExpPatt4 = "expected a pattern after '('",
  ExpPatt5 = "expected a pattern after ':'",
  ExpPatt6 = "expected a pattern after '{~'",
  ExpPatt7 = "expected a pattern after '{|'",

  ExpPatt8 = "expected a pattern after '<-'",

  ExpPattOrClose = "expected a pattern or closing '}' after '{'",

  ExpNumName = "expected a number, '+', '-' or a name (no space) after '^'",
  ExpCap = "expected a string, number, '{}' or name after '->'",

  ExpName1 = "expected the name of a rule after '=>'",
  ExpName2 = "expected the name of a rule after '=' (no space)",
  ExpName3 = "expected the name of a rule after '<' (no space)",

  ExpLab1 = "expected a label after '{'",

  ExpNameOrLab = "expected a name or label after '%' (no space)",

  ExpItem = "expected at least one item after '[' or '^'",

  MisClose1 = "missing closing ')'",
  MisClose2 = "missing closing ':}'",
  MisClose3 = "missing closing '~}'",
  MisClose4 = "missing closing '|}'",
  MisClose5 = "missing closing '}'",  -- for the captures

  MisClose6 = "missing closing '>'",
  MisClose7 = "missing closing '}'",  -- for the labels

  MisClose8 = "missing closing ']'",

  MisTerm1 = "missing terminating single quote",
  MisTerm2 = "missing terminating double quote",
}

local function expect (pattern, label)
  return pattern + m.T(label)
end


-- Pre-defined names
local Predef = { nl = m.P"\n" }


local mem
local fmem
local gmem


local function updatelocale ()
  mm.locale(Predef)
  Predef.a = Predef.alpha
  Predef.c = Predef.cntrl
  Predef.d = Predef.digit
  Predef.g = Predef.graph
  Predef.l = Predef.lower
  Predef.p = Predef.punct
  Predef.s = Predef.space
  Predef.u = Predef.upper
  Predef.w = Predef.alnum
  Predef.x = Predef.xdigit
  Predef.A = any - Predef.a
  Predef.C = any - Predef.c
  Predef.D = any - Predef.d
  Predef.G = any - Predef.g
  Predef.L = any - Predef.l
  Predef.P = any - Predef.p
  Predef.S = any - Predef.s
  Predef.U = any - Predef.u
  Predef.W = any - Predef.w
  Predef.X = any - Predef.x
  mem = {}    -- restart memoization
  fmem = {}
  gmem = {}
  local mt = {__mode = "v"}
  setmetatable(mem, mt)
  setmetatable(fmem, mt)
  setmetatable(gmem, mt)
end


updatelocale()



local I = m.P(function (s,i) print(i, s:sub(1, i-1)); return i end)


local function getdef (id, defs)
  local c = defs and defs[id]
  if not c then
    error("undefined name: " .. id)
  end
  return c
end


local function mult (p, n)
  local np = mm.P(true)
  while n >= 1 do
    if n%2 >= 1 then np = np * p end
    p = p * p
    n = n/2
  end
  return np
end

local function equalcap (s, i, c)
  if type(c) ~= "string" then return nil end
  local e = #c + i
  if s:sub(i, e - 1) == c then return e else return nil end
end


local S = (Predef.space + "--" * (any - Predef.nl)^0)^0

local name = m.C(m.R("AZ", "az", "__") * m.R("AZ", "az", "__", "09")^0)

local arrow = S * "<-"

-- a defined name only have meaning in a given environment
local Def = name * m.Carg(1)

local num = m.C(m.R"09"^1) * S / tonumber

local String = "'" * m.C((any - "'" - m.P"\n")^0) * expect("'", "MisTerm1")
             + '"' * m.C((any - '"' - m.P"\n")^0) * expect('"', "MisTerm2")


local defined = "%" * Def / function (c,Defs)
  local cat =  Defs and Defs[c] or Predef[c]
  if not cat then
    error("name '" .. c .. "' undefined")
  end
  return cat
end

local Range = m.Cs(any * (m.P"-"/"") * (any - "]")) / mm.R

local item = defined + Range + m.C(any - m.P"\n")

local Class =
    "["
  * (m.C(m.P"^"^-1))    -- optional complement symbol
  * m.Cf(expect(item, "ExpItem") * (item - "]")^0, mt.__add)
    / function (c, p) return c == "^" and any - p or p end
  * expect("]", "MisClose8")

local function adddef (t, k, exp)
  if t[k] then
    -- TODO 改了一下这里的代码，重复定义不会抛错
    --error("'"..k.."' already defined as a rule")
  else
    t[k] = exp
  end
  return t
end

local function firstdef (n, r) return adddef({n}, n, r) end


local function NT (n, b)
  if not b then
    error("rule '"..n.."' used outside a grammar")
  else return mm.V(n)
  end
end


local exp = m.P{ "Exp",
  Exp = S * ( m.V"Grammar"
              + m.Cf(m.V"Seq" * (S * "/" * expect(S * m.V"Seq", "ExpPatt1"))^0, mt.__add) );
  Seq = m.Cf(m.Cc(m.P"") * m.V"Prefix" * (S * m.V"Prefix")^0, mt.__mul);
  Prefix = "&" * expect(S * m.V"Prefix", "ExpPatt2") / mt.__len
         + "!" * expect(S * m.V"Prefix", "ExpPatt3") / mt.__unm
         + m.V"Suffix";
  Suffix = m.Cf(m.V"Primary" *
          ( S * ( m.P"+" * m.Cc(1, mt.__pow)
                + m.P"*" * m.Cc(0, mt.__pow)
                + m.P"?" * m.Cc(-1, mt.__pow)
                + "^" * expect( m.Cg(num * m.Cc(mult))
                              + m.Cg(m.C(m.S"+-" * m.R"09"^1) * m.Cc(mt.__pow)
                              + name * m.Cc"lab"
                              ),
                          "ExpNumName")
                + "->" * expect(S * ( m.Cg((String + num) * m.Cc(mt.__div))
                                    + m.P"{}" * m.Cc(nil, m.Ct)
                                    + m.Cg(Def / getdef * m.Cc(mt.__div))
                                    ),
                           "ExpCap")
                + "=>" * expect(S * m.Cg(Def / getdef * m.Cc(m.Cmt)),
                           "ExpName1")
                )
          )^0, function (a,b,f) if f == "lab" then return a + mm.T(b) else return f(a,b) end end );
  Primary = "(" * expect(m.V"Exp", "ExpPatt4") * expect(S * ")", "MisClose1")
          + String / mm.P
          + Class
          + defined
          + "%" * expect(m.P"{", "ExpNameOrLab")
            * expect(S * m.V"Label", "ExpLab1")
            * expect(S * "}", "MisClose7") / mm.T
          + "{:" * (name * ":" + m.Cc(nil)) * expect(m.V"Exp", "ExpPatt5")
            * expect(S * ":}", "MisClose2")
            / function (n, p) return mm.Cg(p, n) end
          + "=" * expect(name, "ExpName2")
            / function (n) return mm.Cmt(mm.Cb(n), equalcap) end
          + m.P"{}" / mm.Cp
          + "{~" * expect(m.V"Exp", "ExpPatt6")
            * expect(S * "~}", "MisClose3") / mm.Cs
          + "{|" * expect(m.V"Exp", "ExpPatt7")
            * expect(S * "|}", "MisClose4") / mm.Ct
          + "{" * expect(m.V"Exp", "ExpPattOrClose")
            * expect(S * "}", "MisClose5") / mm.C
          + m.P"." * m.Cc(any)
          + (name * -arrow + "<" * expect(name, "ExpName3")
             * expect(">", "MisClose6")) * m.Cb("G") / NT;
  Label = num + name;
  Definition = name * arrow * expect(m.V"Exp", "ExpPatt8");
  Grammar = m.Cg(m.Cc(true), "G")
            * m.Cf(m.V"Definition" / firstdef * (S * m.Cg(m.V"Definition"))^0,
                adddef) / mm.P;
}

local pattern = S * m.Cg(m.Cc(false), "G") * expect(exp, "NoPatt") / mm.P
                * S * expect(-any, "ExtraChars")

local function lineno (s, i)
  if i == 1 then return 1, 1 end
  local adjustment = 0
  -- report the current line if at end of line, not the next
  if s:sub(i,i) == '\n' then
    i = i-1
    adjustment = 1
  end
  local rest, num = s:sub(1,i):gsub("[^\n]*\n", "")
  local r = #rest
  return 1 + num, (r ~= 0 and r or 1) + adjustment
end

local function calcline (s, i)
  if i == 1 then return 1, 1 end
  local rest, line = s:sub(1,i):gsub("[^\n]*\n", "")
  local col = #rest
  return 1 + line, col ~= 0 and col or 1
end


local function splitlines(str)
  local t = {}
  local function helper(line) tinsert(t, line) return "" end
  helper((str:gsub("(.-)\r?\n", helper)))
  return t
end

local function compile (p, defs)
  if mm.type(p) == "pattern" then return p end   -- already compiled
  p = p .. " " -- for better reporting of column numbers in errors when at EOF
  local ok, cp, label, poserr = pcall(function() return pattern:match(p, 1, defs) end)
  if not ok and cp then
    if type(cp) == "string" then
      cp = cp:gsub("^[^:]+:[^:]+: ", "")
    end
    error(cp, 3)
  end
  if not cp then
    local lines = splitlines(p)
    local line, col = lineno(p, poserr)
    local err = {}
    tinsert(err, "L" .. line .. ":C" .. col .. ": " .. errinfo[label])
    tinsert(err, lines[line])
    tinsert(err, rep(" ", col-1) .. "^")
    error("syntax error(s) in pattern\n" .. concat(err, "\n"), 3)
  end
  return cp
end

local function match (s, p, i)
  local cp = mem[p]
  if not cp then
    cp = compile(p)
    mem[p] = cp
  end
  return cp:match(s, i or 1)
end

local function find (s, p, i)
  local cp = fmem[p]
  if not cp then
    cp = compile(p) / 0
    cp = mm.P{ mm.Cp() * cp * mm.Cp() + 1 * mm.V(1) }
    fmem[p] = cp
  end
  local i, e = cp:match(s, i or 1)
  if i then return i, e - 1
  else return i
  end
end

local function gsub (s, p, rep)
  local g = gmem[p] or {}   -- ensure gmem[p] is not collected while here
  gmem[p] = g
  local cp = g[rep]
  if not cp then
    cp = compile(p)
    cp = mm.Cs((cp / rep + 1)^0)
    g[rep] = cp
  end
  return cp:match(s)
end


-- exported names
local re = {
  compile = compile,
  match = match,
  find = find,
  gsub = gsub,
  updatelocale = updatelocale,
	calcline = calcline
}

return re
