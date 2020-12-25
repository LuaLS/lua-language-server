local originTracy

local function enable()
    if not originTracy then
        local suc = pcall(require, 'luatracy')
        if suc then
            originTracy = tracy
        else
            originTracy = {
                ZoneBeginN = function (info) end,
                ZoneEnd    = function () end,
            }
        end
    end
    tracy = originTracy
end

local function disable()
    tracy = {
        ZoneBeginN = function (info) end,
        ZoneEnd    = function () end,
    }
end

disable()

return {
    enable  = enable,
    disable = disable,
}
