function OnRequirePath(literal, raw)
    if type(literal) == 'string' then
        return literal
    end
    return raw:match '[^%.]+$'
end
