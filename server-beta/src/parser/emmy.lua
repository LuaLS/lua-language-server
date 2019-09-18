local State
local pushError

local grammar = [[
EmmyLua         <-  ({} '---' EmmyBody {} ShortComment)
                ->  EmmyLua
EmmySp          <-  (!'---@' !'---' Comment / %s / %nl)*
EmmyComments    <-  (EmmyComment (%nl EmmyComMulti / %nl EmmyComSingle)*)
EmmyComment     <-  EmmySp %s*                      {(!%nl .)*}
EmmyComMulti    <-  EmmySp '---|'         {} -> en  {(!%nl .)*}
EmmyComSingle   <-  EmmySp '---' !'@' %s* {} -> ' ' {(!%nl .)*}
EmmyBody        <-  '@class'    %s+ EmmyClass    -> EmmyClass
                /   '@type'     %s+ EmmyType     -> EmmyType
                /   '@alias'    %s+ EmmyAlias    -> EmmyAlias
                /   '@param'    %s+ EmmyParam    -> EmmyParam
                /   '@return'   %s+ EmmyReturn   -> EmmyReturn
                /   '@field'    %s+ EmmyField    -> EmmyField
                /   '@generic'  %s+ EmmyGeneric  -> EmmyGeneric
                /   '@vararg'   %s+ EmmyVararg   -> EmmyVararg
                /   '@language' %s+ EmmyLanguage -> EmmyLanguage
                /   '@see'      %s+ EmmySee      -> EmmySee
                /   '@overload' %s+ EmmyOverLoad -> EmmyOverLoad
                /               %s* EmmyComments -> EmmyComment
                /   EmmyIncomplete

EmmyName        <-  ({} {[a-zA-Z_] [a-zA-Z0-9_]*})
                ->  EmmyName
MustEmmyName    <-  EmmyName / DirtyEmmyName
DirtyEmmyName   <-  {} ->  DirtyEmmyName
EmmyLongName    <-  ({} {(!%nl .)+})
                ->  EmmyName
EmmyIncomplete  <-  MustEmmyName
                ->  EmmyIncomplete

EmmyClass       <-  (MustEmmyName EmmyParentClass?)
EmmyParentClass <-  %s* {} ':' %s* MustEmmyName

EmmyType        <-  EmmyTypeUnits EmmyTypeEnums
EmmyTypeUnits   <-  {|
                        EmmyTypeUnit?
                        (%s* '|' %s* !String EmmyTypeUnit)*
                    |}
EmmyTypeEnums   <-  {| EmmyTypeEnum* |}
EmmyTypeUnit    <-  EmmyFunctionType
                /   EmmyTableType
                /   EmmyArrayType
                /   EmmyCommonType
EmmyCommonType  <-  EmmyName
                ->  EmmyCommonType
EmmyTypeEnum    <-  %s* (%nl %s* '---')? '|'? EmmyEnum
                ->  EmmyTypeEnum
EmmyEnum        <-  %s* {'>'?} %s* String (EmmyEnumComment / (!%nl !'|' .)*)
EmmyEnumComment <-  %s* '#' %s* {(!%nl .)*}

EmmyAlias       <-  MustEmmyName %s* EmmyType EmmyTypeEnum*

EmmyParam       <-  MustEmmyName %s* EmmyType %s* EmmyOption %s* EmmyTypeEnum*
EmmyOption      <-  Table?
                ->  EmmyOption

EmmyReturn      <-  {} %nil     {} Table -> EmmyOption
                /   {} EmmyType {} EmmyOption

EmmyField       <-  (EmmyFieldAccess MustEmmyName %s* EmmyType)
EmmyFieldAccess <-  ({'public'}    Cut %s*)
                /   ({'protected'} Cut %s*)
                /   ({'private'}   Cut %s*)
                /   {} -> 'public'

EmmyGeneric     <-  EmmyGenericBlock
                    (%s* ',' %s* EmmyGenericBlock)*
EmmyGenericBlock<-  (MustEmmyName %s* (':' %s* EmmyType)?)
                ->  EmmyGenericBlock

EmmyVararg      <-  EmmyType

EmmyLanguage    <-  MustEmmyName

EmmyArrayType   <-  ({}    MustEmmyName -> EmmyCommonType {}      '[' DirtyBR)
                ->  EmmyArrayType
                /   ({} PL EmmyCommonType                 DirtyPR '[' DirtyBR)
                ->  EmmyArrayType

EmmyTableType   <-  ({} 'table' Cut '<' %s* EmmyType %s* ',' %s* EmmyType %s* '>' {})
                ->  EmmyTableType

EmmyFunctionType<-  ({} 'fun' Cut %s* EmmyFunctionArgs %s* EmmyFunctionRtns {})
                ->  EmmyFunctionType
EmmyFunctionArgs<-  ('(' %s* EmmyFunctionArg %s* (',' %s* EmmyFunctionArg %s*)* DirtyPR)
                ->  EmmyFunctionArgs
                /  '(' %nil DirtyPR -> None
                /   %nil
EmmyFunctionRtns<-  (':' %s* EmmyType (%s* ',' %s* EmmyType)*)
                ->  EmmyFunctionRtns
                /   %nil
EmmyFunctionArg <-  MustEmmyName %s* ':' %s* EmmyType

EmmySee         <-  {} MustEmmyName %s* '#' %s* MustEmmyName {}
EmmyOverLoad    <-  EmmyFunctionType
]]

local ast = {
    EmmyLua = function (start, emmy, finish)
        emmy.start = start
        emmy.finish = finish - 1
        State.emmy[#State.emmy+1] = emmy
    end,
    EmmyName = function (start, str)
        return {
            type   = 'name',
            start  = start,
            finish = start + #str - 1,
            [1]    = str,
        }
    end,
    DirtyEmmyName = function (pos)
        pushError {
            type = 'MISS_NAME',
            level = 'warning',
            start = pos,
            finish = pos,
        }
        return {
            type   = 'emmyName',
            start  = pos-1,
            finish = pos-1,
            [1]    = ''
        }
    end,
    EmmyClass = function (class, startPos, extends)
        if extends and extends[1] == '' then
            extends.start = startPos
        end
        return {
            type    = 'class',
            class   = class,
            extends = extends,
        }
    end,
    EmmyType = function (types, enums)
        local result = {
            type  = 'type',
            types = types,
            enums = enums,
        }
        return result
    end,
    EmmyCommonType = function (name)
        return {
            type   = 'common',
            start  = name.start,
            finish = name.finish,
            name   = name,
        }
    end,
    EmmyArrayType = function (start, emmy, _, finish)
        emmy.type = 'emmyArrayType'
        emmy.start = start
        emmy.finish = finish - 1
        return emmy
    end,
    EmmyTableType = function (start, keyType, valueType, finish)
        return {
            type = 'emmyTableType',
            start = start,
            finish = finish - 1,
            [1] = keyType,
            [2] = valueType,
        }
    end,
    EmmyFunctionType = function (start, args, returns, finish)
        local result = {
            start = start,
            finish = finish - 1,
            type = 'emmyFunctionType',
            args = args,
            returns = returns,
        }
        return result
    end,
    EmmyFunctionRtns = function (...)
        return {...}
    end,
    EmmyFunctionArgs = function (...)
        local args = {...}
        args[#args] = nil
        return args
    end,
    EmmyAlias = function (name, emmyName, ...)
        return {
            type = 'emmyAlias',
            start = name.start,
            finish = emmyName.finish,
            name,
            emmyName,
            ...
        }
    end,
    EmmyParam = function (argName, emmyName, option, ...)
        local emmy = {
            type = 'emmyParam',
            option = option,
            argName,
            emmyName,
            ...
        }
        emmy.start = emmy[1].start
        emmy.finish = emmy[#emmy].finish
        return emmy
    end,
    EmmyReturn = function (start, type, finish, option)
        local emmy = {
            type = 'emmyReturn',
            option = option,
            start = start,
            finish = finish - 1,
            [1] = type,
        }
        return emmy
    end,
    EmmyField = function (access, fieldName, ...)
        local obj = {
            type = 'emmyField',
            access, fieldName,
            ...
        }
        obj.start = obj[2].start
        obj.finish = obj[3].finish
        return obj
    end,
    EmmyGenericBlock = function (genericName, parentName)
        return {
            start = genericName.start,
            finish = parentName and parentName.finish or genericName.finish,
            genericName,
            parentName,
        }
    end,
    EmmyGeneric = function (...)
        local emmy = {
            type = 'emmyGeneric',
            ...
        }
        emmy.start = emmy[1].start
        emmy.finish = emmy[#emmy].finish
        return emmy
    end,
    EmmyVararg = function (typeName)
        return {
            type = 'emmyVararg',
            start = typeName.start,
            finish = typeName.finish,
            typeName,
        }
    end,
    EmmyLanguage = function (language)
        return {
            type = 'emmyLanguage',
            start = language.start,
            finish = language.finish,
            language,
        }
    end,
    EmmySee = function (start, className, methodName, finish)
        return {
            type = 'emmySee',
            start = start,
            finish = finish - 1,
            className, methodName
        }
    end,
    EmmyOverLoad = function (EmmyFunctionType)
        EmmyFunctionType.type = 'emmyOverLoad'
        return EmmyFunctionType
    end,
    EmmyIncomplete = function (emmyName)
        emmyName.type = 'emmyIncomplete'
        return emmyName
    end,
    EmmyComment = function (...)
        return {
            type = 'emmyComment',
            [1] = table.concat({...}),
        }
    end,
    EmmyOption = function (options)
        if not options or options == '' then
            return nil
        end
        local option = {}
        for _, pair in ipairs(options) do
            if pair.type == 'pair' then
                local key = pair[1]
                local value = pair[2]
                if key.type == 'name' then
                    option[key[1]] = value[1]
                end
            end
        end
        return option
    end,
    EmmyTypeEnum = function (default, enum, comment)
        enum.type = 'enum'
        if default ~= '' then
            enum.default = true
        end
        enum.comment = comment
        return enum
    end,
}

local function init(state)
    State = state
    pushError = state.pushError
end

return {
    grammar = grammar,
    ast = ast,
    init = init,
}
