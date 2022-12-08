---@meta

---
---Allows you to work with fonts.
---
---
---[Open in Browser](https://love2d.org/wiki/love.font)
---
---@class love.font
love.font = {}

---
---Creates a new BMFont Rasterizer.
---
---
---[Open in Browser](https://love2d.org/wiki/love.font.newBMFontRasterizer)
---
---@overload fun(fileName: string, glyphs: string, dpiscale?: number):love.Rasterizer
---@param imageData love.ImageData # The image data containing the drawable pictures of font glyphs.
---@param glyphs string # The sequence of glyphs in the ImageData.
---@param dpiscale? number # DPI scale.
---@return love.Rasterizer rasterizer # The rasterizer.
function love.font.newBMFontRasterizer(imageData, glyphs, dpiscale) end

---
---Creates a new GlyphData.
---
---
---[Open in Browser](https://love2d.org/wiki/love.font.newGlyphData)
---
---@param rasterizer love.Rasterizer # The Rasterizer containing the font.
---@param glyph number # The character code of the glyph.
function love.font.newGlyphData(rasterizer, glyph) end

---
---Creates a new Image Rasterizer.
---
---
---[Open in Browser](https://love2d.org/wiki/love.font.newImageRasterizer)
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
---
---[Open in Browser](https://love2d.org/wiki/love.font.newRasterizer)
---
---@overload fun(data: love.FileData):love.Rasterizer
---@overload fun(size?: number, hinting?: love.HintingMode, dpiscale?: number):love.Rasterizer
---@overload fun(fileName: string, size?: number, hinting?: love.HintingMode, dpiscale?: number):love.Rasterizer
---@overload fun(fileData: love.FileData, size?: number, hinting?: love.HintingMode, dpiscale?: number):love.Rasterizer
---@overload fun(imageData: love.ImageData, glyphs: string, dpiscale?: number):love.Rasterizer
---@overload fun(fileName: string, glyphs: string, dpiscale?: number):love.Rasterizer
---@param filename string # The font file.
---@return love.Rasterizer rasterizer # The rasterizer.
function love.font.newRasterizer(filename) end

---
---Creates a new TrueType Rasterizer.
---
---
---[Open in Browser](https://love2d.org/wiki/love.font.newTrueTypeRasterizer)
---
---@overload fun(fileName: string, size?: number, hinting?: love.HintingMode, dpiscale?: number):love.Rasterizer
---@overload fun(fileData: love.FileData, size?: number, hinting?: love.HintingMode, dpiscale?: number):love.Rasterizer
---@param size? number # The font size.
---@param hinting? love.HintingMode # True Type hinting mode.
---@param dpiscale? number # The font DPI scale.
---@return love.Rasterizer rasterizer # The rasterizer.
function love.font.newTrueTypeRasterizer(size, hinting, dpiscale) end

---
---A GlyphData represents a drawable symbol of a font Rasterizer.
---
---
---[Open in Browser](https://love2d.org/wiki/love.font)
---
---@class love.GlyphData: love.Data, love.Object
local GlyphData = {}

---
---Gets glyph advance.
---
---
---[Open in Browser](https://love2d.org/wiki/GlyphData:getAdvance)
---
---@return number advance # Glyph advance.
function GlyphData:getAdvance() end

---
---Gets glyph bearing.
---
---
---[Open in Browser](https://love2d.org/wiki/GlyphData:getBearing)
---
---@return number bx # Glyph bearing X.
---@return number by # Glyph bearing Y.
function GlyphData:getBearing() end

---
---Gets glyph bounding box.
---
---
---[Open in Browser](https://love2d.org/wiki/GlyphData:getBoundingBox)
---
---@return number x # Glyph position x.
---@return number y # Glyph position y.
---@return number width # Glyph width.
---@return number height # Glyph height.
function GlyphData:getBoundingBox() end

---
---Gets glyph dimensions.
---
---
---[Open in Browser](https://love2d.org/wiki/GlyphData:getDimensions)
---
---@return number width # Glyph width.
---@return number height # Glyph height.
function GlyphData:getDimensions() end

---
---Gets glyph pixel format.
---
---
---[Open in Browser](https://love2d.org/wiki/GlyphData:getFormat)
---
---@return love.PixelFormat format # Glyph pixel format.
function GlyphData:getFormat() end

---
---Gets glyph number.
---
---
---[Open in Browser](https://love2d.org/wiki/GlyphData:getGlyph)
---
---@return number glyph # Glyph number.
function GlyphData:getGlyph() end

---
---Gets glyph string.
---
---
---[Open in Browser](https://love2d.org/wiki/GlyphData:getGlyphString)
---
---@return string glyph # Glyph string.
function GlyphData:getGlyphString() end

---
---Gets glyph height.
---
---
---[Open in Browser](https://love2d.org/wiki/GlyphData:getHeight)
---
---@return number height # Glyph height.
function GlyphData:getHeight() end

---
---Gets glyph width.
---
---
---[Open in Browser](https://love2d.org/wiki/GlyphData:getWidth)
---
---@return number width # Glyph width.
function GlyphData:getWidth() end

---
---A Rasterizer handles font rendering, containing the font data (image or TrueType font) and drawable glyphs.
---
---
---[Open in Browser](https://love2d.org/wiki/love.font)
---
---@class love.Rasterizer: love.Object
local Rasterizer = {}

---
---Gets font advance.
---
---
---[Open in Browser](https://love2d.org/wiki/Rasterizer:getAdvance)
---
---@return number advance # Font advance.
function Rasterizer:getAdvance() end

---
---Gets ascent height.
---
---
---[Open in Browser](https://love2d.org/wiki/Rasterizer:getAscent)
---
---@return number height # Ascent height.
function Rasterizer:getAscent() end

---
---Gets descent height.
---
---
---[Open in Browser](https://love2d.org/wiki/Rasterizer:getDescent)
---
---@return number height # Descent height.
function Rasterizer:getDescent() end

---
---Gets number of glyphs in font.
---
---
---[Open in Browser](https://love2d.org/wiki/Rasterizer:getGlyphCount)
---
---@return number count # Glyphs count.
function Rasterizer:getGlyphCount() end

---
---Gets glyph data of a specified glyph.
---
---
---[Open in Browser](https://love2d.org/wiki/Rasterizer:getGlyphData)
---
---@overload fun(self: love.Rasterizer, glyphNumber: number):love.GlyphData
---@param glyph string # Glyph
---@return love.GlyphData glyphData # Glyph data
function Rasterizer:getGlyphData(glyph) end

---
---Gets font height.
---
---
---[Open in Browser](https://love2d.org/wiki/Rasterizer:getHeight)
---
---@return number height # Font height
function Rasterizer:getHeight() end

---
---Gets line height of a font.
---
---
---[Open in Browser](https://love2d.org/wiki/Rasterizer:getLineHeight)
---
---@return number height # Line height of a font.
function Rasterizer:getLineHeight() end

---
---Checks if font contains specified glyphs.
---
---
---[Open in Browser](https://love2d.org/wiki/Rasterizer:hasGlyphs)
---
---@param glyph1 string|number # Glyph
---@param glyph2 string|number # Glyph
---@vararg string|number # Additional glyphs
---@return boolean hasGlyphs # Whatever font contains specified glyphs.
function Rasterizer:hasGlyphs(glyph1, glyph2, ...) end

---
---True Type hinting mode.
---
---
---[Open in Browser](https://love2d.org/wiki/HintingMode)
---
---@alias love.HintingMode
---
---Default hinting. Should be preferred for typical antialiased fonts.
---
---| "normal"
---
---Results in fuzzier text but can sometimes preserve the original glyph shapes of the text better than normal hinting.
---
---| "light"
---
---Results in aliased / unsmoothed text with either full opacity or completely transparent pixels. Should be used when antialiasing is not desired for the font.
---
---| "mono"
---
---Disables hinting for the font. Results in fuzzier text.
---
---| "none"
