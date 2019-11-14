local foldingType = {
    ['function']      = {'region', 'end',  },
    ['localfunction'] = {'region', 'end',  },
    ['do']            = {'region', 'end',  },
    ['if']            = {'region', 'end',  },
    ['loop']          = {'region', 'end',  },
    ['in']            = {'region', 'end',  },
    ['while']         = {'region', 'end',  },
    ['repeat']        = {'region', 'until',},
    ['table']         = {'region', '}',    },
    ['string']        = {'regtion', ']',   },
}

return function (vm, comments)
    local result = {}
    vm:eachSource(function (source)
        local tp = source.type
        local data = foldingType[tp]
        if not data then
            return
        end
        local start  = source.start
        local finish = source.finish
        if tp == 'repeat' then
            if #source > 0 then
                finish = source[#source].finish
            else
                finish = start + #'repeat'
            end
            finish = vm.text:find('until', finish, true) or finish
            result[#result+1] = {
                start  = start,
                finish = finish,
                kind   = data[1],
            }
        elseif tp == 'if' then
            for i = 1, #source do
                local block = source[i]
                local nblock = source[i+1]
                result[#result+1] = {
                    start  = block.start,
                    finish = nblock and nblock.start or finish,
                    kind   = data[1],
                }
            end
        elseif tp == 'string' then
            result[#result+1] = {
                start  = start,
                finish = finish,
                kind   = data[1],
            }
        elseif data[1] == 'region' then
            result[#result+1] = {
                start  = start,
                finish = finish,
                kind   = data[1],
            }
        end
    end)
    if comments then
        for _, comment in ipairs(comments) do
            result[#result+1] = {
                start  = comment.start,
                finish = comment.finish,
                kind   = 'comment',
            }
        end
    end
    if #result == 0 then
        return nil
    end
    return result
end
