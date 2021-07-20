---@class love.font
love.font = {}

---
---Creates a new BMFont Rasterizer.
---
---@param imageData ImageData # The image data containing the drawable pictures of font glyphs.
---@param glyphs string # The sequence of glyphs in the ImageData.
---@param dpiscale number # DPI scale.
---@return Rasterizer rasterizer # The rasterizer.
function love.font.newBMFontRasterizer(imageData, glyphs, dpiscale) end

---
---Creates a new GlyphData.
---
---@param rasterizer Rasterizer # The Rasterizer containing the font.
---@param glyph number # The character code of the glyph.
function love.font.newGlyphData(rasterizer, glyph) end

---
---Creates a new Image Rasterizer.
---
---@param imageData ImageData # Font image data.
---@param glyphs string # String containing font glyphs.
---@param extraSpacing number # Font extra spacing.
---@param dpiscale number # Font DPI scale.
---@return Rasterizer rasterizer # The rasterizer.
function love.font.newImageRasterizer(imageData, glyphs, extraSpacing, dpiscale) end

---
---Creates a new Rasterizer.
---
---@param filename string # The font file.
---@return Rasterizer rasterizer # The rasterizer.
function love.font.newRasterizer(filename) end

---
---Creates a new TrueType Rasterizer.
---
---@param size number # The font size.
---@param hinting HintingMode # True Type hinting mode.
---@param dpiscale number # The font DPI scale.
---@return Rasterizer rasterizer # The rasterizer.
function love.font.newTrueTypeRasterizer(size, hinting, dpiscale) end
