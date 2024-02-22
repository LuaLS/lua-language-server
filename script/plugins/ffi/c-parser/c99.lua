-- C99 grammar written in lpeg.re.
-- Adapted and translated from plain LPeg grammar for C99
-- written by Wesley Smith https://github.com/Flymir/ceg
--
-- Copyright (c) 2009 Wesley Smith
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.

-- Reference used in the original and in this implementation:
-- http://www.open-std.org/JTC1/SC22/wg14/www/docs/n1124.pdf

local c99 = {}

local re = require("parser.relabel")
local typed = require("plugins.ffi.c-parser.typed")

local defs = {}


c99.tracing = false

defs["trace"] = function(s, i)
    if c99.tracing then
        --local location = require("titan-compiler.location")
        --local line, col = location.get_line_number(s, i)
        --print("TRACE", line, col, "[[" ..s:sub(i, i+ 256):gsub("\n.*", "") .. "]]")
    end
    return true
end

local typedefs = {}

local function elem(xs, e)
    for _, x in ipairs(xs) do
        if e == x then
            return true
        end
    end
    return false
end

defs["decl_func"] = typed("string, number, table -> boolean, Decl", function(_, _, decl)
    typed.set_type(decl, "Decl")
    return true, decl
end)

defs["decl_ids"] = typed("string, number, table -> boolean, Decl?", function(_, _, decl)
    -- store typedef
    if elem(decl.spec, "typedef") then
        if not (decl.ids and decl.ids[1] and decl.ids[1].decl) then
            return true
        end
        for _, id in ipairs(decl.ids) do
            local name = id.decl.name or id.decl.declarator.name
            if name then
                typedefs[name] = true
            end
        end
    end
    typed.set_type(decl, "Decl")
    return true, decl
end)

defs["is_typedef"] = function(_, _, id)
    --print("is " .. id .. " a typedef? " .. tostring(not not typedefs[id]))
    return typedefs[id], typedefs[id] and id
end

defs["empty_table"] = function()
    return true, {}
end

-- Flatten nested expression tables
defs["nest_exp"] = typed("string, number, {Exp} -> boolean, Exp", function(_, _, exp)
    typed.set_type(exp, "Exp")
    if not exp.op then
        return true, exp[1]
    end
    return true, exp
end)

-- Primary expression tables
defs["prim_exp"] = typed("string, number, {string} -> boolean, Exp", function(_, _, exp)
    typed.set_type(exp, "Exp")
    return true, exp
end)

-- Type tables
defs["type_exp"] = typed("string, number, table -> boolean, Exp", function(_, _, exp)
    typed.check(exp[1], "Type")
    typed.set_type(exp, "Exp")
    return true, exp
end)

-- Types
defs["type"] = typed("string, number, table -> boolean, Type", function(_, _, typ)
    typed.set_type(typ, "Type")
    return true, typ
end)

defs["join"] = typed("string, number, {array} -> boolean, array", function(_, _, xss)
    -- xss[1] .. xss[2]
    if xss[2] then
        table.move(xss[2], 1, #xss[2], #xss[1] + 1, xss[1])
    end
    return true, xss[1] or {}
end)

defs["postfix"] = typed("string, number, table -> boolean, table", function(_, _, pf)
    typed.check(pf[1], "Exp")
    if pf.postfix ~= "" then
        pf[1].postfix = pf.postfix
    end
    return true, pf[1]
end)

defs["litstruct"] = typed("string, number, number -> boolean, string", function(_, _, _)
    return true, "litstruct"
end)

--==============================================================================
-- Lexical Rules (used in both preprocessing and language processing)
--==============================================================================

local lexical_rules = [[--lpeg.re

TRACE <- ({} => trace)

empty <- ("" => empty_table)

--------------------------------------------------------------------------------
-- Identifiers

IDENTIFIER <- { identifierNondigit (identifierNondigit / [0-9])* } _
identifierNondigit <- [a-zA-Z_]
                    / universalCharacterName

identifierList <- {| IDENTIFIER ("," _ IDENTIFIER)* |}

--------------------------------------------------------------------------------
-- Universal Character Names

universalCharacterName <- "\u" hexQuad
                        / "\U" hexQuad hexQuad
hexQuad <- hexDigit^4

--------------------------------------------------------------------------------
-- String Literals

STRING_LITERAL <- { ('"' / 'L"') sChar* '"' } _

sChar <- (!["\%nl] .) / escapeSequence

--------------------------------------------------------------------------------
-- Escape Sequences

escapeSequence <- simpleEscapeSequence
                / octalEscapeSequence
                / hexEscapeSequence
                / universalCharacterName

simpleEscapeSequence <- "\" ['"?\abfnrtv]

octalEscapeSequence <- "\" [0-7] [0-7]^-2

hexEscapeSequence <- "\x" hexDigit+

--------------------------------------------------------------------------------
-- Constants

INTEGER_CONSTANT <- { ( hexConstant integerSuffix?
                    / octalConstant integerSuffix?
                    / decimalConstant integerSuffix?
                    ) } _

decimalConstant <- [1-9] digit*
octalConstant <- "0" [0-7]*
hexConstant <- ("0x" / "0X") hexDigit+

digit <- [0-9]
hexDigit <- [0-9a-fA-F]

integerSuffix <- unsignedSuffix longLongSuffix
               / unsignedSuffix longSuffix?
               / longLongSuffix unsignedSuffix?
               / longSuffix unsignedSuffix?

unsignedSuffix <- [uU]
longSuffix <- [lL]
longLongSuffix <- "ll" / "LL"

FLOATING_CONSTANT <- { ( decimalFloatingConstant
                       / hexFloatingConstant
                       ) } _

decimalFloatingConstant <- fractionalConstant exponentPart? floatingSuffix?
                         / digit+ exponentPart floatingSuffix?

hexFloatingConstant <- ("0x" / "0X" ) ( hexFractionalConstant binaryExponentPart floatingSuffix?
                                      /  hexDigit+ binaryExponentPart floatingSuffix? )

fractionalConstant <- digit* "." digit+
                    / digit "."

exponentPart <- [eE] [-+]? digit+

hexFractionalConstant <- hexDigit+? "." hexDigit+
                       / hexDigit+ "."

binaryExponentPart <- [pP] digit+

floatingSuffix <- [flFL]

CHARACTER_CONSTANT <- { ("'" / "L'") cChar+ "'" } _

cChar <- (!['\%nl] .) / escapeSequence

enumerationConstant <- IDENTIFIER

]]

local common_expression_rules = [[--lpeg.re

--------------------------------------------------------------------------------
-- Common Expression Rules

multiplicativeExpression <- {| castExpression           ({:op: [*/%]                     :} _ castExpression                        )* |} => nest_exp
additiveExpression       <- {| multiplicativeExpression ({:op: [-+]                      :} _ multiplicativeExpression              )* |} => nest_exp
shiftExpression          <- {| additiveExpression       ({:op: ("<<" / ">>")             :} _ additiveExpression                    )* |} => nest_exp
relationalExpression     <- {| shiftExpression          ({:op: (">=" / "<=" / "<" / ">") :} _ shiftExpression                       )* |} => nest_exp
equalityExpression       <- {| relationalExpression     ({:op: ("==" / "!=")             :} _ relationalExpression                  )* |} => nest_exp
bandExpression           <- {| equalityExpression       ({:op: "&"                       :} _ equalityExpression                    )* |} => nest_exp
bxorExpression           <- {| bandExpression           ({:op: "^"                       :} _ bandExpression                        )* |} => nest_exp
borExpression            <- {| bxorExpression           ({:op: "|"                       :} _ bxorExpression                        )* |} => nest_exp
andExpression            <- {| borExpression            ({:op: "&&"                      :} _ borExpression                         )* |} => nest_exp
orExpression             <- {| andExpression            ({:op: "||"                      :} _ andExpression                         )* |} => nest_exp
conditionalExpression    <- {| orExpression             ({:op: "?"                       :} _ expression ":" _ conditionalExpression)? |} => nest_exp

constantExpression <- conditionalExpression

]]

--==============================================================================
-- Language Rules (Phrase Structure Grammar)
--==============================================================================

local language_rules = [[--lpeg.re

--------------------------------------------------------------------------------
-- External Definitions

translationUnit <- %s* {| externalDeclaration* |} "$EOF$"

externalDeclaration <- functionDefinition
                     / declaration

functionDefinition <- {| {:spec: {| declarationSpecifier+ |} :} {:func: declarator :} {:decls: declaration* :} {:code: compoundStatement :} |} => decl_func

--------------------------------------------------------------------------------
-- Declarations

declaration <- {| gccExtensionSpecifier? {:spec: {| declarationSpecifier+ |} :} ({:ids: initDeclarationList :})? gccExtensionSpecifier* ";" _ |} => decl_ids

declarationSpecifier <- storageClassSpecifier
                      / typeSpecifier
                      / typeQualifier
                      / functionSpecifier

initDeclarationList <- {| initDeclarator ("," _ initDeclarator)* |}

initDeclarator <- {| {:decl: declarator :} ("=" _ {:value: initializer :} )? |}

gccExtensionSpecifier <- "__attribute__" _ "(" _ "(" _ gccAttributeList ")" _ ")" _
                       / gccAsm
                       / clangAsm
                       / "__DARWIN_ALIAS_STARTING_MAC_1060" _ "(" _ clangAsm ")" _
                       / "__AVAILABILITY_INTERNAL" [a-zA-Z0-9_]+ _ ("(" _ STRING_LITERAL ")" _ )?

gccAsm <- "__asm__" _ "(" _ (STRING_LITERAL / ":" _ / expression)+ ")" _

clangAsm <- "__asm" _ "(" _ (STRING_LITERAL / ":" _ / expression)+ ")" _

gccAttributeList <- {| gccAttributeItem ("," _ gccAttributeItem )* |}

gccAttributeItem <- clangAsm
                  / IDENTIFIER ("(" _ (expression ("," _ expression)*)? ")" _)?
                  / ""

storageClassSpecifier <- { "typedef"  } _
                       / { "extern"   } _
                       / { "static"   } _
                       / { "auto"     } _
                       / { "register" } _

typeSpecifier <- typedefName
               / { "void"     } _
               / { "bool"     } _
               / { "char"     } _
               / { "short"    } _
               / { "int"      } _
               / { "long"     } _
               / { "float"    } _
               / { "double"   } _
               / { "signed"   } _
               / { "__signed"   } _
               / { "__signed__"   } _
               / { "unsigned" } _
               / { "ptrdiff_t" } _
               / { "size_t" } _
               / { "ssize_t" } _
               / { "wchar_t" } _
               / { "int8_t" } _
               / { "int16_t" } _
               / { "int32_t" } _
               / { "int64_t" } _ 
               / { "uint8_t" } _
               / { "uint16_t" } _
               / { "uint32_t" } _
               / { "uint64_t" } _
               / { "intptr_t" } _
               / { "uintptr_t" } _
               / { "__int8" } _
               / { "__int16" } _
               / { "__int32" } _
               / { "__int64" } _ 
               / { "_Bool"    } _
               / { "_Complex" } _
               / { "complex" } _
               / { "__complex" } _
               / { "__complex__" } _
               / { "__ptr32" } _
               / { "__ptr64" } _
               / structOrUnionSpecifier
               / enumSpecifier

typeQualifier <- { "const"    } _
               / { "restrict" } _
               / { "volatile" } _

functionSpecifier <- { "inline" } _

structOrUnionSpecifier <- {| {:type: structOrUnion :} ({:id: IDENTIFIER :})? "{" _ {:fields: {| structDeclaration+ |} :}? "}" _ |}
                        / {| {:type: structOrUnion :}  {:id: IDENTIFIER :}                                                     |}

structOrUnion <- { "struct" } _
               / { "union"  } _

anonymousUnion <- {| {:type: {| {:type: { "union" } :} _ "{" _ {:fields: {| structDeclaration+ |} :}? "}" _ |} :} |} ";" _

structDeclaration <- anonymousUnion
                   / {| {:type: {| specifierQualifier+ |} :} {:ids: structDeclaratorList :} |} ";" _

specifierQualifier <- typeSpecifier
                    / typeQualifier

structDeclaratorList <- {| structDeclarator ("," _ structDeclarator)* |}

structDeclarator <- declarator? ":" _ constantExpression
                  / declarator

enumSpecifier <- {| {:type: enum :} ({:id: IDENTIFIER :})? "{" _ {:values: enumeratorList :}? ("," _)? "}" _ |}
               / {| {:type: enum :}  {:id: IDENTIFIER :}                                                          |}

enum <- { "enum" } _

enumeratorList <- {| enumerator ("," _ enumerator)* |}

enumerator <- {| {:id: enumerationConstant :} ("=" _ {:value: constantExpression :})? |}

declarator <- {| pointer? directDeclarator |}

directDeclarator <- {:name: IDENTIFIER :} ddRec
                  / "(" _ {:declarator: declarator :} ")" _ ddRec
ddRec <- "[" _ {| {:idx: typeQualifier* assignmentExpression?          :} |} "]" _ ddRec
       / "[" _ {| {:idx: { "static" } _ typeQualifier* assignmentExpression :} |} "]" _ ddRec
       / "[" _ {| {:idx: typeQualifier+ { "static" } _ assignmentExpression :} |} "]" _ ddRec
       / "[" _ {| {:idx: typeQualifier* { "*" } _                           :} |} "]" _ ddRec
       / "(" _ {:params: parameterTypeList / empty :} ")" _ ddRec
       / "(" _ {:params: identifierList / empty :} ")" _ ddRec
       / ""

pointer <- {| ({ "*"/"^" } _ typeQualifier*)+ |}

parameterTypeList <- {| parameterList "," _ {| { "..." } |} _ |} => join
                   / parameterList

parameterList <- {| parameterDeclaration ("," _ parameterDeclaration)* |}

parameterDeclaration <- {| {:param: {| {:type: {| declarationSpecifier+ |} :} {:id: (declarator / abstractDeclarator?) :} |} :} |}

typeName <- {| specifierQualifier+ abstractDeclarator? |} => type

abstractDeclarator <- pointer? directAbstractDeclarator
                    / pointer

directAbstractDeclarator <- ("(" _ abstractDeclarator ")" _) directAbstractDeclarator2*
                          / directAbstractDeclarator2+
directAbstractDeclarator2 <- "[" _ assignmentExpression? "]" _
                           / "[" _ "*" _ "]" _
                           / "(" _ (parameterTypeList / empty) ")" _

typedefName <- IDENTIFIER => is_typedef

initializer <- assignmentExpression
             / "{" _ initializerList ("," _)? "}" _

initializerList <- {| initializerList2 ("," _ initializerList2)* |}
initializerList2 <- designation? initializer

designation <- designator+ "=" _

designator <- "[" _ constantExpression "]" _
            / "." _ IDENTIFIER

--------------------------------------------------------------------------------
-- Statements

statement <- labeledStatement
           / compoundStatement
           / expressionStatement
           / selectionStatement
           / iterationStatement
           / jumpStatement
           / gccAsm ";" _

labeledStatement <- IDENTIFIER ":" _ statement
                  / "case" _ constantExpression ":" _ statement
                  / "default" _ ":" _ statement

compoundStatement <- "{" _ blockItem+ "}" _

blockItem <- declaration
           / statement

expressionStatement <- expression? ";" _

selectionStatement <- "if" _ "(" _ expression ")" _ statement "else" _ statement
                    / "if" _ "(" _ expression ")" _ statement
                    / "switch" _ "(" _ expression ")" _ statement

iterationStatement <- "while" _ "(" _ expression ")" _ statement
                    / "do" _ statement "while" _ "(" _ expression ")" _ ";" _
                    / "for" _ "(" _ expression? ";" _ expression? ";" _ expression? ")" _ statement
                    / "for" _ "(" _ declaration expression? ";" _ expression? ")" _ statement

jumpStatement <- "goto" _ IDENTIFIER ";" _
               / "continue" _ ";" _
               / "break" _ ";" _
               / "return" _ expression? ";" _

--------------------------------------------------------------------------------
-- Advanced Language Expression Rules
-- (which require type names)

postfixExpression <- {| {:op: {} => litstruct :} "(" _ {:struct: typeName :} ")" _ "{" _ {:vals: initializerList :} ("," _)? "}" _ peRec |} => nest_exp
                   / {| primaryExpression {:postfix: peRec :} |} => postfix

sizeofOrPostfixExpression <- {| {:op: "sizeof" :} _ "(" _ typeName ")" _ |} => type_exp
                           / {| {:op: "sizeof" :} _ unaryExpression |} => nest_exp
                           / postfixExpression

castExpression <- {| "(" _ typeName ")" _ castExpression |} => type_exp
                / unaryExpression

]]

--==============================================================================
-- Language Expression Rules
--==============================================================================

local language_expression_rules = [[--lpeg.re

--------------------------------------------------------------------------------
-- Language Expression Rules
-- (rules which differ from preprocessing stage)

expression <- {| assignmentExpression ({:op: "," :} _ assignmentExpression)* |} => nest_exp

constant <- ( FLOATING_CONSTANT
            / INTEGER_CONSTANT
            / CHARACTER_CONSTANT
            / enumerationConstant
            )

primaryExpression <- {| constant |} => prim_exp
                   / {| IDENTIFIER |} => prim_exp
                   / {| STRING_LITERAL+ |} => prim_exp
                   / "(" _ expression ")" _

peRec <- {| "[" _ {:idx: expression :} "]" _ peRec |}
       / {| "(" _ {:args: argumentExpressionList / empty :} ")"  _ peRec |}
       / {| "." _ {:dot: IDENTIFIER :} peRec |}
       / {| "->" _ {:arrow: IDENTIFIER :} peRec |}
       / {| "++" _ peRec |}
       / {| "--" _ peRec |}
       / ""

argumentExpressionList <- {| assignmentExpression ("," _ assignmentExpression)* |}

unaryExpression <- {| {:op: prefixOp :} unaryExpression     |} => nest_exp
                 / {| {:op: unaryOperator :} castExpression  |} => nest_exp
                 / sizeofOrPostfixExpression

prefixOp <- { "++" } _
          / { "--" } _

unaryOperator <- { [-+~!*&] } _

assignmentExpression <- unaryExpression assignmentOperator assignmentExpression
                      / conditionalExpression

assignmentOperator <- "=" _
                    / "*=" _
                    / "/=" _
                    / "%=" _
                    / "+=" _
                    / "-=" _
                    / "<<=" _
                    / ">>=" _
                    / "&=" _
                    / "^=" _
                    / "|=" _

--------------------------------------------------------------------------------
-- Language whitespace

_ <- %s+
S <- %s+

]]

local simplified_language_expression_rules = [[--lpeg.re

--------------------------------------------------------------------------------
-- Simplified Language Expression Rules
-- (versions that do not require knowledge of type names)

postfixExpression <- {| primaryExpression {:postfix: peRec :} |} => postfix

sizeofOrPostfixExpression <- postfixExpression

castExpression <- unaryExpression

]]

--==============================================================================
-- Preprocessing Rules
--==============================================================================

local preprocessing_rules = [[--lpeg.re

preprocessingLine <- _ ( "#" _ directive _
                       / "#" _ preprocessingTokenList? {| _ |} -- non-directive, ignore
                       / preprocessingTokenList
                       / empty
                       )

preprocessingTokenList <- {| (preprocessingToken _)+ |}

directive <- {| {:directive: "if"      :} S {:exp: preprocessingTokenList :} |}
           / {| {:directive: "ifdef"   :} S {:id: IDENTIFIER :} |}
           / {| {:directive: "ifndef"  :} S {:id: IDENTIFIER :} |}
           / {| {:directive: "elif"    :} S {:exp: preprocessingTokenList :} |}
           / {| {:directive: "else"    :} |}
           / {| {:directive: "endif"   :} |}
           / {| {:directive: "include" :} S {:exp: headerName :} |}
           / {| {:directive: "define"  :} S {:id: IDENTIFIER :} "(" _ {:args: defineArgList :} _ ")" _ {:repl: replacementList :} |}
           / {| {:directive: "define"  :} S {:id: IDENTIFIER :} _ {:repl: replacementList :} |}
           / {| {:directive: "undef"   :} S {:id: IDENTIFIER :} |}
           / {| {:directive: "line"    :} S {:line: preprocessingTokenList :} |}
           / {| {:directive: "error"   :} S {:error: preprocessingTokenList / empty :} |}
           / {| {:directive: "error"   :} |}
           / {| {:directive: "pragma"  :} S {:pragma: preprocessingTokenList / empty :} |}
           / gccDirective
           / ""

gccDirective <- {| {:directive: "include_next" :} S {:exp: headerName :} |}
              / {| {:directive: "warning" :} S {:exp: preprocessingTokenList / empty :} |}

defineArgList <- {| { "..." } |}
               / {| identifierList _ "," _ {| { "..." } |} |} => join
               / identifierList
               / empty

replacementList <- {| (preprocessingToken _)* |}

preprocessingToken <- preprocessingNumber
                    / CHARACTER_CONSTANT
                    / STRING_LITERAL
                    / punctuator
                    / IDENTIFIER

headerName <- {| {:mode: "<" -> "system" :} { (![%nl>] .)+ } ">" |}
            / {| {:mode: '"' -> "quote" :} { (![%nl"] .)+ } '"' |}
            / {| IDENTIFIER |} -- macro

preprocessingNumber <- { ("."? digit) ( digit
                                      / [eEpP] [-+]
                                      / identifierNondigit
                                      / "."
                                      )* }

punctuator <- { digraphs / '...' / '<<=' / '>>=' /
                '##' / '<<' / '>>' / '->' / '++' / '--' / '&&' / '||' / '<=' / '>=' /
                '==' / '!=' / '*=' / '/=' / '%=' / '+=' / '-=' / '&=' / '^=' / '|=' /
                '#' / '[' / ']' / '(' / ')' / '{' / '}' / '.' / '&' /
                '*' / '+' / '-' / '~' / '!' / '/' / '%' / '<' / '>' /
                '^' / '|' / '?' / ':' / ';' / ',' / '=' }

digraphs <- '%:%:' -> "##"
          / '%:' -> "#"
          / '<:' -> "["
          / ':>' -> "]"
          / '<%' -> "{"
          / '%>' -> "}"

--------------------------------------------------------------------------------
-- Preprocessing whitespace

_ <- %s*
S <- %s+

]]

--==============================================================================
-- Preprocessing Expression Rules
--==============================================================================

local preprocessing_expression_rules = [[--lpeg.re

--------------------------------------------------------------------------------
-- Preprocessing Expression Rules
-- (rules which differ from language processing stage)

expression <- constantExpression

constant <- FLOATING_CONSTANT
          / INTEGER_CONSTANT
          / CHARACTER_CONSTANT

primaryExpression <- {| IDENTIFIER |} => prim_exp
                   / {| constant |} => prim_exp
                   / "(" _ expression _ ")" _

postfixExpression <- primaryExpression peRec
peRec <- "(" _ (argumentExpressionList / empty) ")" _ peRec
       / ""

argumentExpressionList <- {| expression ("," _ expression )* |}

unaryExpression <- {| {:op: unaryOperator :} unaryExpression |} => nest_exp
                 / primaryExpression

unaryOperator <- { [-+~!] } _
               / { "defined" } _

castExpression <- unaryExpression

--------------------------------------------------------------------------------
-- Preprocessing expression whitespace

_ <- %s*
S <- %s+

]]

local preprocessing_grammar = re.compile(
    preprocessing_rules ..
    lexical_rules, defs)

local preprocessing_expression_grammar = re.compile(
    preprocessing_expression_rules ..
    lexical_rules ..
    common_expression_rules, defs)

local language_expression_grammar = re.compile(
    language_expression_rules ..
    simplified_language_expression_rules ..
    lexical_rules ..
    common_expression_rules, defs)

local language_grammar = re.compile(
    language_rules ..
    language_expression_rules ..
    lexical_rules ..
    common_expression_rules, defs)

local function match(grammar, subject)
    local res, err, pos = grammar:match(subject)
    if res == nil then
        local l, c = re.calcline(subject, pos)
        local fragment = subject:sub(pos, pos+20)
        return res, err, l, c, fragment
    end
    return res
end

function c99.match_language_grammar(subject)
    typedefs = {}
    return match(language_grammar, subject)
end

function c99.match_language_expression_grammar(subject)
    return match(language_expression_grammar, subject)
end

function c99.match_preprocessing_grammar(subject)
    return match(preprocessing_grammar, subject)
end

function c99.match_preprocessing_expression_grammar(subject)
    return match(preprocessing_expression_grammar, subject)
end

return c99
