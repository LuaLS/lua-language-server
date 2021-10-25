---@meta

---
---Allows you to work with fonts.
---
---@class love.font
love.font = {}

---
---Creates a new BMFont Rasterizer.
---
---@overload fun(fileName: string, glyphs: string, dpiscale: number):love.Rasterizer
---@param imageData love.ImageData # The image data containing the drawable pictures of font glyphs.
---@param glyphs string # The sequence of glyphs in the ImageData.
---@param dpiscale? number # DPI scale.
---@return love.Rasterizer rasterizer # The rasterizer.
function love.font.newBMFontRasterizer(imageData, glyphs, dpiscale) end

---
---Creates a new GlyphData.
---
---@param rasterizer love.Rasterizer # The Rasterizer containing the font.
---@param glyph number # The character code of the glyph.
function love.font.newGlyphData(rasterizer, glyph) end

---
---Creates a new Image Rasterizer.
---
---@param imageData love.ImageData # Font image data.
---@param glyphs string # String containing font glyphs.
---@param extraSpacing? number # Font extra spacing.
---@param dpiscale? number # Font DPI scale.
---@return love.Rasterizer rasterizer # The rasterizer.
function love.font.newImageRasterizer(imageData, glyphs, extraSpacing, dpiscale) end

---
---Creates a new Rasterizer.
---
---@overload fun(data: love.FileData):love.Rasterizer
---@overload fun(size: number, hinting: love.HintingMode, dpiscale: number):love.Rasterizer
---@overload fun(fileName: string, size: number, hinting: love.HintingMode, dpiscale: number):love.Rasterizer
---@overload fun(fileData: love.FileData, size: number, hinting: love.HintingMode, dpiscale: number):love.Rasterizer
---@overload fun(imageData: love.ImageData, glyphs: string, dpiscale: number):love.Rasterizer
---@overload fun(fileName: string, glyphs: string, dpiscale: number):love.Rasterizer
---@param filename string # The font file.
---@return love.Rasterizer rasterizer # The rasterizer.
function love.font.newRasterizer(filename) end

---
---Creates a new TrueType Rasterizer.
---
---@overload fun(fileName: string, size: number, hinting: love.HintingMode, dpiscale: number):love.Rasterizer
---@overload fun(fileData: love.FileData, size: number, hinting: love.HintingMode, dpiscale: number):love.Rasterizer
---@param size? number # The font size.
---@param hinting? love.HintingMode # True Type hinting mode.
---@param dpiscale? number # The font DPI scale.
---@return love.Rasterizer rasterizer # The rasterizer.
function love.font.newTrueTypeRasterizer(size, hinting, dpiscale) end

---
---A GlyphData represents a drawable symbol of a font Rasterizer.
---
---@class love.GlyphData: love.Data, love.Object
local GlyphData = {}

---
---Gets glyph advance.
---
---@return number advance # Glyph advance.
function GlyphData:getAdvance() end

---
---Gets glyph bearing.
---
---@return number bx # Glyph bearing X.
---@return number by # Glyph bearing Y.
function GlyphData:getBearing() end

---
---Gets glyph bounding box.
---
---@return number x # Glyph position x.
---@return number y # Glyph position y.
---@return number width # Glyph width.
---@return number height # Glyph height.
function GlyphData:getBoundingBox() end

---
---Gets glyph dimensions.
---
---@return number width # Glyph width.
---@return number height # Glyph height.
function GlyphData:getDimensions() end

---
---Gets glyph pixel format.
---
---@return love.PixelFormat format # Glyph pixel format.
function GlyphData:getFormat() end

---
---Gets glyph number.
---
---@return number glyph # Glyph number.
function GlyphData:getGlyph() end

---
---Gets glyph string.
---
---@return string glyph # Glyph string.
function GlyphData:getGlyphString() end

---
---Gets glyph height.
---
---@return number height # Glyph height.
function GlyphData:getHeight() end

---
---Gets glyph width.
---
---@return number width # Glyph width.
function GlyphData:getWidth() end

---
---A Rasterizer handles font rendering, containing the font data (image or TrueType font) and drawable glyphs.
---
---@class love.Rasterizer: love.Object
local Rasterizer = {}

---
---Gets font advance.
---
---@return number advance # Font advance.
function Rasterizer:getAdvance() end

---
---Gets ascent height.
---
---@return number height # Ascent height.
function Rasterizer:getAscent() end

---
---Gets descent height.
---
---@return number height # Descent height.
function Rasterizer:getDescent() end

---
---Gets number of glyphs in font.
---
---@return number count # Glyphs count.
function Rasterizer:getGlyphCount() end

---
---Gets glyph data of a specified glyph.
---
---@overload fun(glyphNumber: number):love.GlyphData
---@param glyph string # Glyph
---@return love.GlyphData glyphData # Glyph data
function Rasterizer:getGlyphData(glyph) end

---
---Gets font height.
---
---@return number height # Font height
function Rasterizer:getHeight() end

---
---Gets line height of a font.
---
---@return number height # Line height of a font.
function Rasterizer:getLineHeight() end

---
---Checks if font contains specified glyphs.
---
---@param glyph1 string|number # Glyph
---@param glyph2 string|number # Glyph
---@return boolean hasGlyphs # Whatever font contains specified glyphs.
function Rasterizer:hasGlyphs(glyph1, glyph2) end

---
---True Type hinting mode.
---
---@class love.HintingMode
---
---Default hinting. Should be preferred for typical antialiased fonts.
---
---@field normal integer
---
---Results in fuzzier text but can sometimes preserve the original glyph shapes of the text better than normal hinting.
---
---@field light integer
---
---Results in aliased / unsmoothed text with either full opacity or completely transparent pixels. Should be used when antialiasing is not desired for the font.
---
---@field mono integer
---
---Disables hinting for the font. Results in fuzzier text.
---
---@field none integer
