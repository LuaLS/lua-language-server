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
}

return function (vm)
    local result = {}
    vm:eachSource(function (source)
        local tp = source.type
        local data = foldingType[tp]
        if not data then
            return
        end
        if data[1] == 'region' then
            local start  = source.start
            local finish = source.finish
            if data[2] == 'until' then
                if #source > 0 then
                    finish = source[#source].finish
                else
                    finish = start + #'repeat'
                end
                finish = vm.text:find('until', finish, true) or finish
            end
            result[#result+1] = {
                start  = start,
                finish = finish,
                kind   = data[1],
            }
            if tp == 'if' then
                for i = 2, #source do
                    local block = source[i]
                    local nblock = source[i+1]
                    result[#result+1] = {
                        start  = block.start,
                        finish = nblock and nblock.start or finish,
                        kind   = data[1],
                    }
                end
            end
        end
    end)
    if #result == 0 then
        return nil
    end
    return result
end
