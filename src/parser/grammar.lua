local re = require 'parser.relabel'
local m = require 'lpeglabel'
local calcline = require 'parser.calcline'

local scriptBuf = ''
local compiled = {}
local parser

local defs = setmetatable({}, {__index = function (self, key)
    self[key] = function (...)
        if parser[key] then
            return parser[key](...)
        end
    end
    return self[key]
end})

defs.nl = (m.P'\r\n' + m.S'\r\n') / function ()
    if parser.nl then
        return parser.nl()
    end
end
defs.s  = m.S' \t'
defs.S  = - defs.s
defs.ea = '\a'
defs.eb = '\b'
defs.ef = '\f'
defs.en = '\n'
defs.er = '\r'
defs.et = '\t'
defs.ev = '\v'
local eof = re.compile '!. / %{SYNTAX_ERROR}'

local function grammar(tag)
    return function (script)
        scriptBuf = script .. '\r\n' .. scriptBuf
        compiled[tag] = re.compile(scriptBuf, defs) * eof
    end
end

local labels = {

}

local function errorpos(lua, pos, err)
    local row, col = calcline.rowcol(lua, pos)
    local str = calcline.line(lua, row)
    return {
        lua = lua,
        line = row,
        pos = col,
        err = err,
        code = str,
        level = 'error',
    }
end

grammar 'Comment' [[
Comment         <-  '--' (LongComment / ShortComment)
LongComment     <-  '[' {:eq: '='* :} '[' CommentClose
CommentClose    <-  ']' =eq ']' / . CommentClose
ShortComment    <-  (!%nl .)*
]]

grammar 'Sp' [[
Sp  <-  (Comment / %nl / %s)*
]]

grammar 'Common' [[
Cut         <-  ![a-zA-Z0-9_]
X16         <-  [a-fA-F0-9]

AND         <-  Sp 'and'      Cut
BREAK       <-  Sp 'break'    Cut
DO          <-  Sp 'do'       Cut
ELSE        <-  Sp 'else'     Cut
ELSEIF      <-  Sp 'elseif'   Cut
END         <-  Sp 'end'      Cut
FALSE       <-  Sp 'false'    Cut
FOR         <-  Sp 'for'      Cut
FUNCTION    <-  Sp 'function' Cut
GOTO        <-  Sp 'goto'     Cut
IF          <-  Sp 'if'       Cut
IN          <-  Sp 'in'       Cut
LOCAL       <-  Sp 'local'    Cut
NIL         <-  Sp 'nil'      Cut
NOT         <-  Sp 'not'      Cut
OR          <-  Sp 'or'       Cut
REPEAT      <-  Sp 'repeat'   Cut
RETURN      <-  Sp 'return'   Cut
THEN        <-  Sp 'then'     Cut
TRUE        <-  Sp 'true'     Cut
UNTIL       <-  Sp 'until'    Cut
WHILE       <-  Sp 'while'    Cut

Esc         <-  '\' EChar
EChar       <-  'a' -> ea
            /   'b' -> eb
            /   'f' -> ef
            /   'n' -> en
            /   'r' -> er
            /   't' -> et
            /   'v' -> ev
            /   '\'
            /   '"'
            /   "'"
            /   %nl
            /   'z' (%nl / %s)* -> ''
            /   'x' X16 X16
            /   [0-9] [0-9]? [0-9]?
            /   'u{' X16^+1^-6 '}'

Comp        <-  Sp CompList
CompList    <-  '<='
            /   '>='
            /   '<'
            /   '>'
            /   '~='
            /   '=='
BOR         <-  Sp '|'
BXOR        <-  Sp '~'
BAND        <-  Sp '&'
Bshift      <-  Sp BshiftList
BshiftList  <-  '<<'
            /   '>>'
Concat      <-  Sp '..'
Adds        <-  Sp AddsList
AddsList    <-  '+'
            /   '-'
Muls        <-  Sp MulsList
MulsList    <-  '*'
            /   '//'
            /   '/'
            /   '%'
Unary       <-  Sp UnaryList
UnaryList   <-  'not'
            /   '#'
            /   '-'
            /   '~'
POWER       <-  Sp '^'

PL          <-  Sp '('
PR          <-  Sp ')'
BL          <-  Sp '['
BR          <-  Sp ']'
TL          <-  Sp '{'
TR          <-  Sp '}'
COMMA       <-  Sp ','
SEMICOLON   <-  Sp ';'
DOTS        <-  Sp '...'
DOT         <-  Sp '.'
COLON       <-  Sp ':'
LABEL       <-  Sp '::'
ASSIGN      <-  Sp '='
]]

grammar 'Nil' [[
Nil         <-  NIL
]]

grammar 'Boolean' [[
Boolean     <-  TRUE
            /   FALSE
]]

grammar 'String' [[
String      <-  Sp StringDef
StringDef   <-  '"' (Esc / !%nl !'"' .)* '"'
            /   "'" (Esc / !%nl !"'" .)* "'"
            /   '[' {:eq: '='* :} '[' StringClose
StringClose <-  ']' =eq ']' / . StringClose
]]

grammar 'Number' [[
Number      <-  Sp NumberDef
NumberDef   <-  Number16 / Number10

Number10    <-  Integer10 Float10
Integer10   <-  '0' / [1-9] [0-9]*
Float10     <-  ('.' [0-9]*)? ([eE] [+-]? [1-9]? [0-9]*)?

Number16    <-  Integer16 Float16
Integer16   <-  '0' [xX] X16*
Float16     <-  ('.' X16*)? ([pP] [+-]? [1-9]? [0-9]*)?
]]

grammar 'Name' [[
Name        <-  Sp ({} {[a-zA-Z_] [a-zA-Z0-9_]*}) -> Name
]]

grammar 'Exp' [[
Exp         <-  ExpOr
ExpOr       <-  ExpAnd     (OR     ExpAnd)*
ExpAnd      <-  ExpCompare (AND    ExpCompare)*
ExpCompare  <-  ExpBor     (Comp   ExpBor)*
ExpBor      <-  ExpBxor    (BOR    ExpBxor)*
ExpBxor     <-  ExpBand    (BXOR   ExpBand)*
ExpBand     <-  ExpBshift  (BAND   ExpBshift)*
ExpBshift   <-  ExpConcat  (Bshift ExpConcat)*
ExpConcat   <-  ExpAdds    (Concat ExpAdds)*
ExpAdds     <-  ExpMuls    (Adds   ExpMuls)*
ExpMuls     <-  ExpUnary   (Muls   ExpUnary)*
ExpUnary    <-             (Unary  ExpPower)
            /                      ExpPower
ExpPower    <-  ExpUnit    (POWER  ExpUnit)*
ExpUnit     <-  Nil
            /   Boolean
            /   String
            /   Number
            /   DOTS
            /   Table
            /   Function
            /   Simple

Simple      <-  Prefix (Suffix)*
Prefix      <-  PL Exp PR
            /   Name
Suffix      <-  DOT Name
            /   COLON Name
            /   Table
            /   String
            /   BL Exp BR
            /   PL ArgList? PR

ArgList     <-  Arg (COMMA Arg)*
Arg         <-  DOTS
            /   Exp

Table       <-  TL TableFields? TR
TableFields <-  TableField (TableSep TableField)* TableSep?
TableSep    <-  COMMA / SEMICOLON
TableField  <-  NewIndex / NewField / Exp
NewIndex    <-  BL Exp BR ASSIGN Exp
NewField    <-  Name ASSIGN Exp

Function    <-  {|
                FUNCTION FuncName? PL ArgList? PR
                    (!END Action)*
                END
                |}
            ->  Function
FuncName    <-  {:name: {| Name (FuncSuffix)* |} :}
FuncSuffix  <-  DOT Name
            /   COLON Name

-- 纯占位，修改了 `relabel.lua` 使重复定义不抛错
Action      <-  !. .
]]

grammar 'Action' [[
Action      <-  SEMICOLON / Do / Break / Return / Label / GoTo / If / For / While / Repeat / Set / Local / Function / Call

ExpList     <-  Exp (COMMA Exp)*

Do          <-  DO (!END Action)* END

Break       <-  BREAK

Return      <-  RETURN ExpList?

Label       <-  LABEL Name LABEL

GoTo        <-  GOTO Name

If          <-  IfPart
                ElseIfPart*
                ElsePart?
                END
IfPart      <-  IF Exp THEN
                    (!ELSEIF !ELSE !END Action)*
ElseIfPart  <-  ELSEIF Exp THEN
                    (!ELSE !END Action)*
ElsePart    <-  ELSE
                    (!END Action)*

For         <-  Loop / In
Loop        <-  FOR LoopStart LoopFinish LoopStep? DO
                    (!END Action)*
                END
LoopStart   <-  Name ASSIGN Exp
LoopFinish  <-  COMMA Exp
LoopStep    <-  COMMA Exp

In          <-  FOR NameList IN ExpList DO
                    (!END Action)*
                END
NameList    <-  Name (COMMA Name)*

While       <-  WHILE Exp DO
                    (!END Action)*
                END

Repeat      <-  REPEAT
                    (!UNTIL Action)*
                UNTIL Exp

Set         <-  (LOCAL !FUNCTION Name ASSIGN Exp)
            ->  LocalSet
            /   Simple     ASSIGN Exp

Local       <-  LOCAL Function
            ->  LocalFunction
            /   LOCAL Name
            ->  LocalVar

Call        <-  Prefix (Suffix)*
]]

grammar 'Lua' [[
Lua         <-  (Sp Action)* Sp
]]

return function (lua, mode, parser_)
    parser = parser_ or {}
    mode = mode or 'lua'
    local r, e, pos = compiled[mode]:match(lua)
    if not r then
        local err = errorpos(lua, pos, e)
        return nil, err
    end

    return r
end
