local suc = pcall(require, 'luatracy')
local originTracy = tracy

local function enable()
    if not suc then
        return
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
