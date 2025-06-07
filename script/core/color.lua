local files = require "files"
local guide = require "parser.guide"

---@enum (key) ColorMode
local colorPattern = {
    argb8   = "^%x%x%x%x%x%x%x%x$",
    hexrgb6 = "^#%x%x%x%x%x%x$",
    rgb6    = "^%x%x%x%x%x%x$",
}

---@param source parser.object
---@return ColorMode | false
local function getColorMode(source)
    ---@type string
    local text = source[1]

    for k,v in pairs(colorPattern) do
        if text:match(v) then
            return k
        end
    end

    return false
end

local textToColor = {}

---@param colorText string
---@return Color
function textToColor.argb8(colorText)
    return {
        alpha = tonumber(colorText:sub(1, 2), 16) / 255,
        red   = tonumber(colorText:sub(3, 4), 16) / 255,
        green = tonumber(colorText:sub(5, 6), 16) / 255,
        blue  = tonumber(colorText:sub(7, 8), 16) / 255,
    }
end

---@param colorText string
---@return Color
function textToColor.hexrgb6(colorText)
    return {
        alpha = 1,
        red   = tonumber(colorText:sub(2, 3), 16) / 255,
        green = tonumber(colorText:sub(4, 5), 16) / 255,
        blue  = tonumber(colorText:sub(6, 7), 16) / 255,
    }
end

---@param colorText string
---@return Color
function textToColor.rgb6(colorText)
    return {
        alpha = 1,
        red   = tonumber(colorText:sub(1, 2), 16) / 255,
        green = tonumber(colorText:sub(3, 4), 16) / 255,
        blue  = tonumber(colorText:sub(5, 6), 16) / 255,
    }
end

---@param color Color
---@return string
local function colorToText(color)
    return string.format('%02X%02X%02X%02X'
        , math.floor(color.alpha * 255)
        , math.floor(color.red   * 255)
        , math.floor(color.green * 255)
        , math.floor(color.blue  * 255)
    )
end

---@class Color
---@field red number
---@field green number
---@field blue number
---@field alpha number

---@class ColorValue
---@field color Color
---@field start integer
---@field finish integer

---@async
local function colors(uri)
    local state = files.getState(uri)
    local text  = files.getText(uri)
    if not state or not text then
        return nil
    end
    ---@type ColorValue[]
    local colorValues = {}

    guide.eachSource(state.ast, function (source) ---@async
        if source.type == 'string' then
            local colorMode = getColorMode(source)
            if colorMode then
                ---@type string
                local colorText = source[1]
                local color = textToColor[colorMode](colorText)

                colorValues[#colorValues+1] = {
                    start  = source.start + 1,
                    finish = source.finish - 1,
                    color  = color,
                }
            end
        end
    end)
    return colorValues
end

return {
    colors = colors,
    colorToText = colorToText
}
