root = arg[0] .. '\\..'
package.path = package.path .. ';' .. root .. '\\src\\?.lua'
                            .. ';' .. root .. '\\src\\?\\init.lua'
