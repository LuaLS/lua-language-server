local snippet = {}

local function add(cate, key, label)
    return function (text)
        if not snippet[cate] then
            snippet[cate] = {}
        end
        if not snippet[cate][key] then
            snippet[cate][key] = {}
        end
        snippet[cate][key][#snippet[cate][key]+1] = {
            label = label,
            text = text,
        }
    end
end

add('key', 'do', 'do .. end') [[
do
    $0
end]]

add('key', 'elseif', 'elseif .. then')
[[elseif ${1:true} then]]

add('key', 'for', 'for .. in') [[
for ${1:key, value} in ${2:pairs(t)} do
    $0
end]]

add('key', 'for', 'for i = ..') [[
for ${1:i} = ${2:1}, ${3:10, 2} do
    $0
end]]

add('key', 'function', 'function ()') [[
function $1(${2:arg1, arg2, arg3})
    $0
end]]

add('key', 'local', 'local function') [[
local function ${1:name}(${2:arg1, arg2, arg3})
    $0
end]]

add('key', 'if', 'if .. then') [[
if ${1:true} then
    $0
end]]

add('key', 'repeat', 'repeat .. until') [[
repeat
    $0
until ${1:true}]]

add('key', 'while', 'while .. do') [[
while ${1:true} do
    $0
end]]

add('key', 'return', 'do return end') 
[[do return ${1:true} end]]

return snippet
