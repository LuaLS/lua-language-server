local re = require 'parser.relabel'
local m = require 'lpeglabel'
local calcline = require 'parser.calcline'


local scriptBuf = ''
local compiled = {}
local parser

local RESERVED = {
    ['and']      = true,
    ['break']    = true,
    ['do']       = true,
    ['else']     = true,
    ['elseif']   = true,
    ['end']      = true,
    ['false']    = true,
    ['for']      = true,
    ['function'] = true,
    ['goto']     = true,
    ['if']       = true,
    ['in']       = true,
    ['local']    = true,
    ['nil']      = true,
    ['not']      = true,
    ['or']       = true,
    ['repeat']   = true,
    ['return']   = true,
    ['then']     = true,
    ['true']     = true,
    ['until']    = true,
    ['while']    = true,
}

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
defs.NotReserved = function (_, _, str)
    if RESERVED[str] then
        return false
    end
    return true, str
end

defs.first = function (first, ...)
    return first
end
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
    return {
        lua = lua,
        pos = pos,
        err = err,
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

AND         <-  Sp {'and'}    Cut
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
OR          <-  Sp {'or'}     Cut
REPEAT      <-  Sp 'repeat'   Cut
RETURN      <-  Sp 'return'   Cut
THEN        <-  Sp 'then'     Cut
TRUE        <-  Sp 'true'     Cut
UNTIL       <-  Sp 'until'    Cut
WHILE       <-  Sp 'while'    Cut

Esc         <-  '\' -> ''
                EChar
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
            /   ('z' (%nl / %s)*)     -> ''
            /   ('x' {X16 X16})       -> Char16
            /   ([0-9] [0-9]? [0-9]?) -> Char10
            /   ('u{' {X16^+1^-6} '}')-> CharUtf8

Comp        <-  Sp {CompList}
CompList    <-  '<='
            /   '>='
            /   '<'
            /   '>'
            /   '~='
            /   '=='
BOR         <-  Sp {'|'}
BXOR        <-  Sp {'~'}
BAND        <-  Sp {'&'}
Bshift      <-  Sp {BshiftList}
BshiftList  <-  '<<'
            /   '>>'
Concat      <-  Sp {'..'}
Adds        <-  Sp {AddsList}
AddsList    <-  '+'
            /   '-'
Muls        <-  Sp {MulsList}
MulsList    <-  '*'
            /   '//'
            /   '/'
            /   '%'
Unary       <-  Sp {} {UnaryList}
UnaryList   <-  NOT
            /   '#'
            /   '-'
            /   '~'
POWER       <-  Sp {'^'}

PL          <-  Sp '('
PR          <-  Sp ')'
BL          <-  Sp '['
BR          <-  Sp ']'
TL          <-  Sp '{'
TR          <-  Sp '}'
COMMA       <-  Sp ','
SEMICOLON   <-  Sp ';'
DOTS        <-  Sp ({} '...') -> DOTS
DOT         <-  Sp '.' !'.'
COLON       <-  Sp ({} ':' !':') -> COLON
LABEL       <-  Sp '::'
ASSIGN      <-  Sp '='

Nothing     <-  {} -> Nothing

TOCLOSE     <-  Sp '*toclose'
]]

grammar 'Nil' [[
Nil         <-  Sp ({} -> Nil) NIL
]]

grammar 'Boolean' [[
Boolean     <-  Sp ({} -> True)  TRUE
            /   Sp ({} -> False) FALSE
]]

grammar 'String' [[
String      <-  Sp ({} StringDef {})
            ->  String
StringDef   <-  '"' {~(Esc / !%nl !'"' .)*~} -> first (%nl / '"'?)
            /   "'" {~(Esc / !%nl !"'" .)*~} -> first (%nl / "'"?)
            /   '[' {:eq: '='* :} '[' {(!StringClose .)*} -> first StringClose
StringClose <-  ']' =eq ']'
]]

grammar 'Number' [[
Number      <-  Sp ({} {NumberDef} {}) -> Number
NumberDef   <-  Number16 / Number10

Number10    <-  Integer10 Float10
Integer10   <-  '0' / [1-9] [0-9]*
Float10     <-  ('.' [0-9]*)? ([eE] [+-]? [1-9]? [0-9]*)?

Number16    <-  Integer16 Float16
Integer16   <-  '0' [xX] X16*
Float16     <-  ('.' X16*)? ([pP] [+-]? [1-9]? [0-9]*)?
]]

grammar 'Name' [[
Name        <-  Sp ({} NameBody {})
            ->  Name
NameBody    <-  ([a-zA-Z_] [a-zA-Z0-9_]*)
            =>  NotReserved
MustName    <-  Name / DirtyName
DirtyName   <-  {} -> DirtyName
]]

grammar 'Exp' [[
Exp         <-  ExpOr
ExpOr       <-  (ExpAnd     (OR     ExpAnd)*)     -> Binary
ExpAnd      <-  (ExpCompare (AND    ExpCompare)*) -> Binary
ExpCompare  <-  (ExpBor     (Comp   ExpBor)*)     -> Binary
ExpBor      <-  (ExpBxor    (BOR    ExpBxor)*)    -> Binary
ExpBxor     <-  (ExpBand    (BXOR   ExpBand)*)    -> Binary
ExpBand     <-  (ExpBshift  (BAND   ExpBshift)*)  -> Binary
ExpBshift   <-  (ExpConcat  (Bshift ExpConcat)*)  -> Binary
ExpConcat   <-  (ExpAdds    (Concat ExpConcat)*)  -> Binary
ExpAdds     <-  (ExpMuls    (Adds   ExpMuls)*)    -> Binary
ExpMuls     <-  (ExpUnary   (Muls   ExpUnary)*)   -> Binary
ExpUnary    <-  (           (Unary+ (ExpPower / DirtyName)))
            ->  Unary
            /   ExpPower
ExpPower    <-  (ExpUnit    (POWER  ExpUnary)*)   -> Binary
ExpUnit     <-  Nil
            /   Boolean
            /   String
            /   Number
            /   DOTS
            /   Table
            /   Function
            /   Simple

Simple      <-  (Prefix (Suffix)*)
            ->  Simple
Prefix      <-  PL Exp PR
            /   Name
Suffix      <-  DOT MustName
            /   COLON MustName
            /   Sp ({} Table {}) -> Call
            /   Sp ({} String {}) -> Call
            /   BL DirtyExp -> Index BR?
            /   Sp ({} PL ExpList (PR / Sp) {}) -> Call

DirtyExp    <-  Exp / DirtyName
ExpList     <-  (COMMA DirtyExp)+
            ->  List
            /   (Exp (COMMA DirtyExp)*)?
            ->  List
NameList    <-  (COMMA MustName)+
            ->  List
            /   (Name (COMMA MustName)*)?
            ->  List

ArgList     <-  (COMMA AfterArg)+
            ->  List
            /   (FirstArg (COMMA AfterArg)*)?
            ->  List
FirstArg    <-  DOTS
            /   Name
AfterArg    <-  DOTS
            /   MustName


Table       <-  Sp ({} TL TableFields TR? {})
            ->  Table
TableFields <-  TableSep (TableSep? TableField)+ TableSep?
            /   (TableField (TableSep? TableField)* TableSep?)?
            ->  TableFields
TableSep    <-  COMMA / SEMICOLON
TableField  <-  NewIndex / NewField / Exp
NewIndex    <-  (BL DirtyExp BR ASSIGN DirtyExp)
            ->  NewIndex
NewField    <-  (MustName ASSIGN DirtyExp)
            ->  NewField

Function    <-  Sp ({} FunctionBody {})
            ->  Function
FunctionBody<-  FUNCTION FuncName PL ArgList PR
                    Action*
                END?
            /   FUNCTION FuncName PL ArgList PR?
                    Action*
                END?
            /   FUNCTION FuncName Nothing
                    Action*
                END?
FuncName    <-  (Name? (FuncSuffix)*)
            ->  Simple
FuncSuffix  <-  DOT MustName
            /   COLON MustName

-- 纯占位，修改了 `relabel.lua` 使重复定义不抛错
Action      <-  !END .
]]

grammar 'Action' [[
Action      <-  SEMICOLON
            /   Do
            /   Break
            /   Return
            /   Label
            /   GoTo
            /   If
            /   For
            /   While
            /   Repeat
            /   Function
            /   LocalFunction
            /   Local
            /   Set
            /   Call
            /   Exp

SimpleList  <-  (Simple (COMMA Simple)*)
            ->  List

Do          <-  Sp ({} DO DoBody END? {})
            ->  Do
DoBody      <-  Action*
            ->  DoBody

Break       <-  BREAK
            ->  Break

Return      <-  RETURN ExpList?
            ->  Return

Label       <-  LABEL MustName -> Label LABEL

GoTo        <-  GOTO MustName -> GoTo

If          <-  Sp ({} IfBody {})
            ->  If
IfHead      <-  (IfPart     -> IfBlock)
            /   (ElseIfPart -> ElseIfBlock)
            /   (ElsePart   -> ElseBlock)
IfBody      <-  IfHead
                (ElseIfPart -> ElseIfBlock)*
                (ElsePart   -> ElseBlock)?
                END?
IfPart      <-  IF Exp THEN
                    {} (!ELSEIF !ELSE Action)* {}
            /   IF DirtyExp THEN
                    {} (!ELSEIF !ELSE Action)* {}
            /   IF DirtyExp
                    {}         {}
ElseIfPart  <-  ELSEIF Exp THEN
                    {} (!ELSE !ELSEIF Action)* {}
            /   ELSEIF DirtyExp THEN
                    {} (!ELSE !ELSEIF Action)* {}
            /   ELSEIF DirtyExp
                    {}         {}
ElsePart    <-  ELSE
                    {} Action* {}

For         <-  Loop / In
            /   FOR

Loop        <-  Sp ({} LoopBody {})
            ->  Loop
LoopBody    <-  FOR LoopStart LoopFinish LoopStep DO?
                    Action*
                END?
LoopStart   <-  MustName ASSIGN DirtyExp
LoopFinish  <-  COMMA? Exp
            /   COMMA? DirtyName
LoopStep    <-  COMMA  DirtyExp
            /   COMMA? Exp
            /   Nothing

In          <-  Sp ({} InBody {})
            ->  In
InBody      <-  FOR NameList IN? ExpList DO?
                    Action*
                END?

While       <-  Sp ({} WhileBody {})
            ->  While
WhileBody   <-  WHILE Exp DO
                    Action*
                END?

Repeat      <-  Sp ({} RepeatBody {})
            ->  Repeat
RepeatBody  <-  REPEAT
                    Action*
                UNTIL Exp

Local       <-  (LOCAL TOCLOSE? NameList (ASSIGN ExpList)?)
            ->  Local
Set         <-  (SimpleList ASSIGN ExpList)
            ->  Set

Call        <-  Simple

LocalFunction
            <-  Sp ({} LOCAL FunctionBody {})
            ->  LocalFunction
]]

grammar 'Lua' [[
Lua         <-  (Sp Action)* -> Lua Sp
]]

return function (lua, mode, parser_)
    parser = parser_ or {}
    local gram = compiled[mode] or compiled['Lua']
    local r, e, pos = gram:match(lua)
    if not r then
        local err = errorpos(lua, pos, e)
        return nil, err
    end

    return r
end
