local m = require 'lpeglabel'

local Sp     = m.S' \t\v\f'
local Nl     = m.P'\r\n' + m.S'\r\n'
local Number = m.R'09'^1
local Word   = m.R('AZ', 'az', '__', '\x80\xff') * m.R('AZ', 'az', '09', '__', '\x80\xff')^0
local Symbol = m.P'=='
            +  m.P'~='
            +  m.P'--'
            -- non-standard:
            +  m.P'<<='
            +  m.P'>>='
            +  m.P'//='
            -- end non-standard
            +  m.P'<<'
            +  m.P'>>'
            +  m.P'<='
            +  m.P'>='
            +  m.P'//'
            +  m.P'...'
            +  m.P'..'
            +  m.P'::'
            -- non-standard:
            +  m.P'!='
            +  m.P'&&'
            +  m.P'||'
            +  m.P'/*'
            +  m.P'*/'
            +  m.P'+='
            +  m.P'-='
            +  m.P'*='
            +  m.P'%='
            +  m.P'&='
            +  m.P'|='
            +  m.P'^='
            +  m.P'/='
            -- end non-standard
            -- singles
            +  m.S'+-*/!#%^&()={}[]|\\\'":;<>,.?~`'
local Unknown = (1 - Number - Word - Symbol - Sp - Nl)^1
local Token   = m.Cp() * m.C(Nl + Number + Word + Symbol + Unknown)

local Parser  = m.Ct((Sp^1 + Token)^0)

return function (lua)
    local results = Parser:match(lua)
    return results
end
