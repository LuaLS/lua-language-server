---@meta

---
---Provides functionality for creating and transforming data.
---
---@class love.data
love.data = {}

---
---Compresses a string or data using a specific compression algorithm.
---
---@overload fun(container: love.ContainerType, format: love.CompressedDataFormat, data: love.Data, level: number):love.CompressedData|string
---@param container love.ContainerType # What type to return the compressed data as.
---@param format love.CompressedDataFormat # The format to use when compressing the string.
---@param rawstring string # The raw (un-compressed) string to compress.
---@param level? number # The level of compression to use, between 0 and 9. -1 indicates the default level. The meaning of this argument depends on the compression format being used.
---@return love.CompressedData|string compressedData # CompressedData/string which contains the compressed version of rawstring.
function love.data.compress(container, format, rawstring, level) end

---
---Decode Data or a string from any of the EncodeFormats to Data or string.
---
---@overload fun(container: love.ContainerType, format: love.EncodeFormat, sourceData: love.Data):love.ByteData|string
---@param container love.ContainerType # What type to return the decoded data as.
---@param format love.EncodeFormat # The format of the input data.
---@param sourceString string # The raw (encoded) data to decode.
---@return love.ByteData|string decoded # ByteData/string which contains the decoded version of source.
function love.data.decode(container, format, sourceString) end

---
---Decompresses a CompressedData or previously compressed string or Data object.
---
---@overload fun(container: love.ContainerType, format: love.CompressedDataFormat, compressedString: string):love.Data|string
---@overload fun(container: love.ContainerType, format: love.CompressedDataFormat, data: love.Data):love.Data|string
---@param container love.ContainerType # What type to return the decompressed data as.
---@param compressedData love.CompressedData # The compressed data to decompress.
---@return love.Data|string decompressedData # Data/string containing the raw decompressed data.
function love.data.decompress(container, compressedData) end

---
---Encode Data or a string to a Data or string in one of the EncodeFormats.
---
---@overload fun(container: love.ContainerType, format: love.EncodeFormat, sourceData: love.Data, linelength: number):love.ByteData|string
---@param container love.ContainerType # What type to return the encoded data as.
---@param format love.EncodeFormat # The format of the output data.
---@param sourceString string # The raw data to encode.
---@param linelength? number # The maximum line length of the output. Only supported for base64, ignored if 0.
---@return love.ByteData|string encoded # ByteData/string which contains the encoded version of source.
function love.data.encode(container, format, sourceString, linelength) end

---
---Gets the size in bytes that a given format used with love.data.pack will use.
---
---This function behaves the same as Lua 5.3's string.packsize.
---
---@param format string # A string determining how the values are packed. Follows the rules of Lua 5.3's string.pack format strings.
---@return number size # The size in bytes that the packed data will use.
function love.data.getPackedSize(format) end

---
---Compute the message digest of a string using a specified hash algorithm.
---
---@overload fun(hashFunction: love.HashFunction, data: love.Data):string
---@param hashFunction love.HashFunction # Hash algorithm to use.
---@param string string # String to hash.
---@return string rawdigest # Raw message digest string.
function love.data.hash(hashFunction, string) end

---
---Creates a new Data object containing arbitrary bytes.
---
---Data:getPointer along with LuaJIT's FFI can be used to manipulate the contents of the ByteData object after it has been created.
---
---@overload fun(Data: love.Data, offset: number, size: number):love.ByteData
---@overload fun(size: number):love.ByteData
---@param datastring string # The byte string to copy.
---@return love.ByteData bytedata # The new Data object.
function love.data.newByteData(datastring) end

---
---Creates a new Data referencing a subsection of an existing Data object.
---
---@param data love.Data # The Data object to reference.
---@param offset number # The offset of the subsection to reference, in bytes.
---@param size number # The size in bytes of the subsection to reference.
---@return love.Data view # The new Data view.
function love.data.newDataView(data, offset, size) end

---
---Packs (serializes) simple Lua values.
---
---This function behaves the same as Lua 5.3's string.pack.
---
---@param container love.ContainerType # What type to return the encoded data as.
---@param format string # A string determining how the values are packed. Follows the rules of Lua 5.3's string.pack format strings.
---@param v1 number|boolean|string # The first value (number, boolean, or string) to serialize.
---@return love.Data|string data # Data/string which contains the serialized data.
function love.data.pack(container, format, v1) end

---
---Unpacks (deserializes) a byte-string or Data into simple Lua values.
---
---This function behaves the same as Lua 5.3's string.unpack.
---
---@overload fun(format: string, data: love.Data, pos: number):number|boolean|string, number|boolean|string, number
---@param format string # A string determining how the values were packed. Follows the rules of Lua 5.3's string.pack format strings.
---@param datastring string # A string containing the packed (serialized) data.
---@param pos? number # Where to start reading in the string. Negative values can be used to read relative from the end of the string.
---@return number|boolean|string v1 # The first value (number, boolean, or string) that was unpacked.
---@return number index # The index of the first unread byte in the data string.
function love.data.unpack(format, datastring, pos) end

---
---Data object containing arbitrary bytes in an contiguous memory.
---
---There are currently no LÖVE functions provided for manipulating the contents of a ByteData, but Data:getPointer can be used with LuaJIT's FFI to access and write to the contents directly.
---
---@class love.ByteData: love.Object, love.Data
local ByteData = {}

---
---Represents byte data compressed using a specific algorithm.
---
---love.data.decompress can be used to de-compress the data (or love.math.decompress in 0.10.2 or earlier).
---
---@class love.CompressedData: love.Data, love.Object
local CompressedData = {}

---
---Gets the compression format of the CompressedData.
---
---@return love.CompressedDataFormat format # The format of the CompressedData.
function CompressedData:getFormat() end

---
---Compressed data formats.
---
---@class love.CompressedDataFormat
---
---The LZ4 compression format. Compresses and decompresses very quickly, but the compression ratio is not the best. LZ4-HC is used when compression level 9 is specified. Some benchmarks are available here.
---
---@field lz4 integer
---
---The zlib format is DEFLATE-compressed data with a small bit of header data. Compresses relatively slowly and decompresses moderately quickly, and has a decent compression ratio.
---
---@field zlib integer
---
---The gzip format is DEFLATE-compressed data with a slightly larger header than zlib. Since it uses DEFLATE it has the same compression characteristics as the zlib format.
---
---@field gzip integer
---
---Raw DEFLATE-compressed data (no header).
---
---@field deflate integer

---
---Return type of various data-returning functions.
---
---@class love.ContainerType
---
---Return type is ByteData.
---
---@field data integer
---
---Return type is string.
---
---@field string integer

---
---Encoding format used to encode or decode data.
---
---@class love.EncodeFormat
---
---Encode/decode data as base64 binary-to-text encoding.
---
---@field base64 integer
---
---Encode/decode data as hexadecimal string.
---
---@field hex integer

---
---Hash algorithm of love.data.hash.
---
---@class love.HashFunction
---
---MD5 hash algorithm (16 bytes).
---
---@field md5 integer
---
---SHA1 hash algorithm (20 bytes).
---
---@field sha1 integer
---
---SHA2 hash algorithm with message digest size of 224 bits (28 bytes).
---
---@field sha224 integer
---
---SHA2 hash algorithm with message digest size of 256 bits (32 bytes).
---
---@field sha256 integer
---
---SHA2 hash algorithm with message digest size of 384 bits (48 bytes).
---
---@field sha384 integer
---
---SHA2 hash algorithm with message digest size of 512 bits (64 bytes).
---
---@field sha512 integer
