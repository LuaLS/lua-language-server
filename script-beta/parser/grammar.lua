local re = require 'parser.relabel'
local m = require 'lpeglabel'
local emmy = require 'parser.emmy'
local ast = require 'parser.ast'

local scriptBuf = ''
local compiled = {}
local defs = ast.defs

-- goto 可以作为名字，合法性之后处理
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

defs.nl = (m.P'\r\n' + m.S'\r\n')
defs.s  = m.S' \t'
defs.S  = - defs.s
defs.ea = '\a'
defs.eb = '\b'
defs.ef = '\f'
defs.en = '\n'
defs.er = '\r'
defs.et = '\t'
defs.ev = '\v'
defs['nil'] = m.Cp() / function () return nil end
defs['false'] = m.Cp() / function () return false end
defs.NotReserved = function (_, _, str)
    if RESERVED[str] then
        return false
    end
    return true
end
defs.Reserved = function (_, _, str)
    if RESERVED[str] then
        return true
    end
    return false
end
defs.None = function () end
defs.np = m.Cp() / function (n) return n+1 end

m.setmaxstack(1000)

local eof = re.compile '!. / %{SYNTAX_ERROR}'

local function grammar(tag)
    return function (script)
        scriptBuf = script .. '\r\n' .. scriptBuf
        compiled[tag] = re.compile(scriptBuf, defs) * eof
    end
end

local function errorpos(pos, err)
    return {
        type = 'UNKNOWN',
        start = pos or 0,
        finish = pos or 0,
        err = err,
    }
end

grammar 'Comment' [[
Comment         <-  LongComment
                /   '--' ShortComment
LongComment     <-  ('--[' {} {:eq: '='* :} {} '[' 
                    {(!CommentClose .)*}
                    (CommentClose / {}))
                ->  LongComment
                /   (
                    {} '/*' {}
                    (!'*/' .)*
                    {} '*/' {}
                    )
                ->  CLongComment
CommentClose    <-  ']' =eq ']'
ShortComment    <-  (!%nl .)*
]]

grammar 'Sp' [[
Sp  <-  (EmmyLua / Comment / %nl / %s)*
Sps <-  (EmmyLua / Comment / %nl / %s)+

-- 占位
EmmyLua <- !. .
]]

grammar 'Common' [[
Word        <-  [a-zA-Z0-9_]
Cut         <-  !Word
X16         <-  [a-fA-F0-9]
Rest        <-  (!%nl .)*

AND         <-  Sp {'and'}    Cut
BREAK       <-  Sp 'break'    Cut
FALSE       <-  Sp 'false'    Cut
GOTO        <-  Sp 'goto'     Cut
LOCAL       <-  Sp 'local'    Cut
NIL         <-  Sp 'nil'      Cut
NOT         <-  Sp 'not'      Cut
OR          <-  Sp {'or'}     Cut
RETURN      <-  Sp 'return'   Cut
TRUE        <-  Sp 'true'     Cut

DO          <-  Sp {} 'do'       {} Cut
            /   Sp({} 'then'     {} Cut) -> ErrDo
IF          <-  Sp {} 'if'       {} Cut
ELSE        <-  Sp {} 'else'     {} Cut
ELSEIF      <-  Sp {} 'elseif'   {} Cut
END         <-  Sp {} 'end'      {} Cut
FOR         <-  Sp {} 'for'      {} Cut
FUNCTION    <-  Sp {} 'function' {} Cut
IN          <-  Sp {} 'in'       {} Cut
REPEAT      <-  Sp {} 'repeat'   {} Cut
THEN        <-  Sp {} 'then'     {} Cut
            /   Sp({} 'do'       {} Cut) -> ErrThen
UNTIL       <-  Sp {} 'until'    {} Cut
WHILE       <-  Sp {} 'while'    {} Cut


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
            /   ('z' (%nl / %s)*)       -> ''
            /   ({} 'x' {X16 X16})      -> Char16
            /   ([0-9] [0-9]? [0-9]?)   -> Char10
            /   ('u{' {} {Word*} '}')   -> CharUtf8
            -- 错误处理
            /   'x' {}                  -> MissEscX
            /   'u' !'{' {}             -> MissTL
            /   'u{' Word* !'}' {}      -> MissTR
            /   {}                      -> ErrEsc

BOR         <-  Sp {'|'}
BXOR        <-  Sp {'~'} !'='
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
            /   '~' !'='
POWER       <-  Sp {'^'}

BinaryOp    <-( Sp {} {'or'} Cut
            /   Sp {} {'and'} Cut
            /   Sp {} {'<=' / '>=' / '<'!'<' / '>'!'>' / '~=' / '=='}
            /   Sp {} ({} '=' {}) -> ErrEQ
            /   Sp {} ({} '!=' {}) -> ErrUEQ
            /   Sp {} {'|'}
            /   Sp {} {'~'}
            /   Sp {} {'&'}
            /   Sp {} {'<<' / '>>'}
            /   Sp {} {'..'} !'.'
            /   Sp {} {'+' / '-'}
            /   Sp {} {'*' / '//' / '/' / '%'}
            /   Sp {} {'^'}
            )-> BinaryOp
UnaryOp     <-( Sp {} {'not' Cut / '#' / '~' !'=' / '-' !'-'}
            )-> UnaryOp

PL          <-  Sp '('
PR          <-  Sp ')'
BL          <-  Sp '[' !'[' !'='
BR          <-  Sp ']'
TL          <-  Sp '{'
TR          <-  Sp '}'
COMMA       <-  Sp ({} ',')
            ->  COMMA
SEMICOLON   <-  Sp ({} ';')
            ->  SEMICOLON
DOTS        <-  Sp ({} '...')
            ->  DOTS
DOT         <-  Sp ({} '.' !'.')
            ->  DOT
COLON       <-  Sp ({} ':' !':')
            ->  COLON
LABEL       <-  Sp '::'
ASSIGN      <-  Sp '=' !'='
AssignOrEQ  <-  Sp ({} '==' {})
            ->  ErrAssign
            /   Sp '='

DirtyBR     <-  BR     / {} -> MissBR
DirtyTR     <-  TR     / {} -> MissTR
DirtyPR     <-  PR     / {} -> MissPR
DirtyLabel  <-  LABEL  / {} -> MissLabel
NeedEnd     <-  END    / {} -> MissEnd
NeedDo      <-  DO     / {} -> MissDo
NeedAssign  <-  ASSIGN / {} -> MissAssign
NeedComma   <-  COMMA  / {} -> MissComma
NeedIn      <-  IN     / {} -> MissIn
NeedUntil   <-  UNTIL  / {} -> MissUntil
NeedThen    <-  THEN   / {} -> MissThen
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
StringDef   <-  {'"'}
                {~(Esc / !%nl !'"' .)*~} -> 1
                ('"' / {} -> MissQuote1)
            /   {"'"}
                {~(Esc / !%nl !"'" .)*~} -> 1
                ("'" / {} -> MissQuote2)
            /   ('[' {} {:eq: '='* :} {} '[' %nl?
                {(!StringClose .)*} -> 1
                (StringClose / {}))
            ->  LongString
StringClose <-  ']' =eq ']'
]]

grammar 'Number' [[
Number      <-  Sp ({} {NumberDef} {}) -> Number
                NumberSuffix?
                ErrNumber?
NumberDef   <-  Number16 / Number10
NumberSuffix<-  ({} {[uU]? [lL] [lL]})      -> FFINumber
            /   ({} {[iI]})                 -> ImaginaryNumber
ErrNumber   <-  ({} {([0-9a-zA-Z] / '.')+}) -> UnknownSymbol

Number10    <-  Float10 Float10Exp?
            /   Integer10 Float10? Float10Exp?
Integer10   <-  [0-9]+ ('.' [0-9]*)?
Float10     <-  '.' [0-9]+
Float10Exp  <-  [eE] [+-]? [0-9]+
            /   ({} [eE] [+-]? {}) -> MissExponent

Number16    <-  '0' [xX] Float16 Float16Exp?
            /   '0' [xX] Integer16 Float16? Float16Exp?
Integer16   <-  X16+ ('.' X16*)?
            /   ({} {Word*}) -> MustX16
Float16     <-  '.' X16+
            /   '.' ({} {Word*}) -> MustX16
Float16Exp  <-  [pP] [+-]? [0-9]+
            /   ({} [pP] [+-]? {}) -> MissExponent
]]

grammar 'Name' [[
Name        <-  Sp ({} NameBody {})
            ->  Name
NameBody    <-  {[a-zA-Z_] [a-zA-Z0-9_]*}
FreeName    <-  Sp ({} {NameBody=>NotReserved} {})
            ->  Name
KeyWord     <-  Sp NameBody=>Reserved
MustName    <-  Name / DirtyName
DirtyName   <-  {} -> DirtyName
]]

grammar 'Exp' [[
Exp         <-  (UnUnit BinUnit*)
            ->  Binary
BinUnit     <-  (BinaryOp UnUnit?)
            ->  SubBinary
UnUnit      <-  ExpUnit
            /   (UnaryOp+ (ExpUnit / MissExp))
            ->  Unary
ExpUnit     <-  Nil
            /   Boolean
            /   String
            /   Number
            /   Dots
            /   Table
            /   Function
            /   Simple

Simple      <-  {| Prefix (Sp Suffix)* |}
            ->  Simple
Prefix      <-  Sp ({} PL DirtyExp DirtyPR {})
            ->  Paren
            /   Single
Single      <-  FreeName
            ->  Single
Suffix      <-  SuffixWithoutCall
            /   ({} PL SuffixCall DirtyPR {})
            ->  Call
SuffixCall  <-  Sp ({} {| (COMMA / Exp)+ |} {})
            ->  PackExpList
            /   %nil
SuffixWithoutCall
            <-  (DOT (Name / MissField))
            ->  GetField
            /   ({} BL DirtyExp DirtyBR {})
            ->  GetIndex
            /   (COLON (Name / MissMethod) NeedCall)
            ->  GetMethod
            /   ({} {| Table |} {})
            ->  Call
            /   ({} {| String |} {})
            ->  Call
NeedCall    <-  (!(Sp CallStart) {} -> MissPL)?
MissField   <-  {} -> MissField
MissMethod  <-  {} -> MissMethod
CallStart   <-  PL
            /   TL
            /   '"'
            /   "'"
            /   '[' '='* '['

DirtyExp    <-  Exp
            /   {} -> DirtyExp
MaybeExp    <-  Exp / MissExp
MissExp     <-  {} -> MissExp
ExpList     <-  Sp {| MaybeExp (Sp ',' MaybeExp)* |}

Dots        <-  DOTS
            ->  VarArgs

Table       <-  Sp ({} TL {| TableField* |} DirtyTR {})
            ->  Table
TableField  <-  COMMA
            /   SEMICOLON
            /   NewIndex
            /   NewField
            /   Exp
Index       <-  BL DirtyExp DirtyBR
NewIndex    <-  Sp ({} Index NeedAssign DirtyExp {})
            ->  NewIndex
NewField    <-  Sp ({} MustName ASSIGN DirtyExp {})
            ->  NewField

Function    <-  FunctionBody
            ->  Function
FuncArgs    <-  Sp ({} PL {| FuncArg+ |} DirtyPR {})
            ->  FuncArgs
            /   PL DirtyPR %nil 
            /   {} -> MissPL DirtyPR %nil
FuncArg     <-  DOTS
            /   Name
            /   COMMA
FunctionBody<-  FUNCTION FuncArgs
                    {| (!END Action)* |}
                NeedEnd

-- 纯占位，修改了 `relabel.lua` 使重复定义不抛错
Action      <-  !END .
]]

grammar 'Action' [[
Action      <-  Sp (CrtAction / UnkAction)
CrtAction   <-  Semicolon
            /   Do
            /   Break
            /   Return
            /   Label
            /   GoTo
            /   If
            /   For
            /   While
            /   Repeat
            /   NamedFunction
            /   LocalFunction
            /   Local
            /   Set
            /   Call
            /   ExpInAction
UnkAction   <-  ({} {Word+})
            ->  UnknownAction
            /   ({} '//' {} (LongComment / ShortComment))
            ->  CCommentPrefix
            /   ({} {. (!Sps !CrtAction .)*})
            ->  UnknownAction
ExpInAction <-  Sp ({} Exp {})
            ->  ExpInAction

Semicolon   <-  Sp ';'
SimpleList  <-  {| Simple (Sp ',' Simple)* |}

Do          <-  Sp ({} 
                'do' Cut
                    {| (!END Action)* |}
                NeedEnd)
            ->  Do

Break       <-  Sp ({} BREAK {})
            ->  Break

Return      <-  Sp ({} RETURN ReturnExpList {})
            ->  Return
ReturnExpList 
            <-  Sp {| Exp (Sp ',' MaybeExp)* |}
            /   Sp {| !Exp !',' |}
            /   ExpList

Label       <-  Sp ({} LABEL MustName DirtyLabel {})
            ->  Label

GoTo        <-  Sp ({} GOTO MustName {})
            ->  GoTo

If          <-  Sp ({} {| IfHead IfBody* |} NeedEnd)
            ->  If

IfHead      <-  Sp (IfPart     {}) -> IfBlock
            /   Sp (ElseIfPart {}) -> ElseIfBlock
            /   Sp (ElsePart   {}) -> ElseBlock
IfBody      <-  Sp (ElseIfPart {}) -> ElseIfBlock
            /   Sp (ElsePart   {}) -> ElseBlock
IfPart      <-  IF DirtyExp NeedThen
                    {| (!ELSEIF !ELSE !END Action)* |}
ElseIfPart  <-  ELSEIF DirtyExp NeedThen
                    {| (!ELSEIF !ELSE !END Action)* |}
ElsePart    <-  ELSE
                    {| (!ELSEIF !ELSE !END Action)* |}

For         <-  Loop / In

Loop        <-  LoopBody
            ->  Loop
LoopBody    <-  FOR LoopArgs NeedDo
                    {} {| (!END Action)* |}
                NeedEnd
LoopArgs    <-  MustName AssignOrEQ
                ({} {| (COMMA / !DO !END Exp)* |} {})
            ->  PackLoopArgs

In          <-  InBody
            ->  In
InBody      <-  FOR InNameList NeedIn InExpList NeedDo
                    {} {| (!END Action)* |}
                NeedEnd
InNameList  <-  ({} {| (COMMA / !IN !DO !END Name)* |} {})
            ->  PackInNameList
InExpList   <-  ({} {| (COMMA / !DO !DO !END Exp)*  |} {})
            ->  PackInExpList

While       <-  WhileBody
            ->  While
WhileBody   <-  WHILE DirtyExp NeedDo
                    {| (!END Action)* |}
                NeedEnd

Repeat      <-  (RepeatBody {})
            ->  Repeat
RepeatBody  <-  REPEAT
                    {| (!UNTIL Action)* |}
                NeedUntil DirtyExp

LocalAttr   <-  {| (Sp '<' Sp MustName Sp LocalAttrEnd)+ |}
            ->  LocalAttr
LocalAttrEnd<-  '>' / {} -> MissGT
Local       <-  Sp ({} LOCAL LocalNameList ((AssignOrEQ ExpList) / %nil) {})
            ->  Local
Set         <-  Sp ({} SimpleList AssignOrEQ ExpList {})
            ->  Set
LocalNameList
            <-  {| LocalName (Sp ',' LocalName)* |}
LocalName   <-  (MustName LocalAttr?)
            ->  LocalName

Call        <-  Simple
            ->  SimpleCall

LocalFunction
            <-  Sp ({} LOCAL FunctionNamedBody)
            ->  LocalFunction

NamedFunction
            <-  FunctionNamedBody
            ->  NamedFunction
FunctionNamedBody
            <-  FUNCTION FuncName FuncArgs
                    {| (!END Action)* |}
                NeedEnd
FuncName    <-  {| Single (Sp SuffixWithoutCall)* |}
            ->  Simple
            /   {} -> MissName %nil
]]

--grammar 'EmmyLua' (emmy.grammar)

grammar 'Lua' [[
Lua         <-  Head?
                ({} {| Action* |} {}) -> Lua
                Sp
Head        <-  '#' (!%nl .)*
]]

return function (self, lua, mode)
    local gram = compiled[mode] or compiled['Lua']
    local r, _, pos = gram:match(lua)
    if not r then
        local err = errorpos(pos)
        return nil, err
    end

    return r
end
