---@meta

---@class cc.FileUtils 
local FileUtils={ }
cc.FileUtils=FileUtils




---*  Returns the fullpath for a given filename.<br>
---* First it will try to get a new filename from the "filenameLookup" dictionary.<br>
---* If a new filename can't be found on the dictionary, it will use the original filename.<br>
---* Then it will try to obtain the full path of the filename using the FileUtils search rules: resolutions, and search paths.<br>
---* The file search is based on the array element order of search paths and resolution directories.<br>
---* For instance:<br>
---* We set two elements("/mnt/sdcard/", "internal_dir/") to search paths vector by setSearchPaths,<br>
---* and set three elements("resources-ipadhd/", "resources-ipad/", "resources-iphonehd")<br>
---* to resolutions vector by setSearchResolutionsOrder. The "internal_dir" is relative to "Resources/".<br>
---* If we have a file named 'sprite.png', the mapping in fileLookup dictionary contains `key: sprite.png -> value: sprite.pvr.gz`.<br>
---* Firstly, it will replace 'sprite.png' with 'sprite.pvr.gz', then searching the file sprite.pvr.gz as follows:<br>
---* /mnt/sdcard/resources-ipadhd/sprite.pvr.gz      (if not found, search next)<br>
---* /mnt/sdcard/resources-ipad/sprite.pvr.gz        (if not found, search next)<br>
---* /mnt/sdcard/resources-iphonehd/sprite.pvr.gz    (if not found, search next)<br>
---* /mnt/sdcard/sprite.pvr.gz                       (if not found, search next)<br>
---* internal_dir/resources-ipadhd/sprite.pvr.gz     (if not found, search next)<br>
---* internal_dir/resources-ipad/sprite.pvr.gz       (if not found, search next)<br>
---* internal_dir/resources-iphonehd/sprite.pvr.gz   (if not found, search next)<br>
---* internal_dir/sprite.pvr.gz                      (if not found, return "sprite.png")<br>
---* If the filename contains relative path like "gamescene/uilayer/sprite.png",<br>
---* and the mapping in fileLookup dictionary contains `key: gamescene/uilayer/sprite.png -> value: gamescene/uilayer/sprite.pvr.gz`.<br>
---* The file search order will be:<br>
---* /mnt/sdcard/gamescene/uilayer/resources-ipadhd/sprite.pvr.gz      (if not found, search next)<br>
---* /mnt/sdcard/gamescene/uilayer/resources-ipad/sprite.pvr.gz        (if not found, search next)<br>
---* /mnt/sdcard/gamescene/uilayer/resources-iphonehd/sprite.pvr.gz    (if not found, search next)<br>
---* /mnt/sdcard/gamescene/uilayer/sprite.pvr.gz                       (if not found, search next)<br>
---* internal_dir/gamescene/uilayer/resources-ipadhd/sprite.pvr.gz     (if not found, search next)<br>
---* internal_dir/gamescene/uilayer/resources-ipad/sprite.pvr.gz       (if not found, search next)<br>
---* internal_dir/gamescene/uilayer/resources-iphonehd/sprite.pvr.gz   (if not found, search next)<br>
---* internal_dir/gamescene/uilayer/sprite.pvr.gz                      (if not found, return "gamescene/uilayer/sprite.png")<br>
---* If the new file can't be found on the file system, it will return the parameter filename directly.<br>
---* This method was added to simplify multiplatform support. Whether you are using cocos2d-js or any cross-compilation toolchain like StellaSDK or Apportable,<br>
---* you might need to load different resources for a given file in the different platforms.<br>
---* since v2.1
---@param filename string
---@return string
function FileUtils:fullPathForFilename (filename) end
---@overload fun(string:string,function:function):self
---@overload fun(string:string):self
---@param path string
---@param callback function
---@return self
function FileUtils:getStringFromFile (path,callback) end
---* Sets the filenameLookup dictionary.<br>
---* param filenameLookupDict The dictionary for replacing filename.<br>
---* since v2.1
---@param filenameLookupDict map_table
---@return self
function FileUtils:setFilenameLookupDictionary (filenameLookupDict) end
---@overload fun(string:string,function:function):self
---@overload fun(string:string):self
---@param filepath string
---@param callback function
---@return self
function FileUtils:removeFile (filepath,callback) end
---* List all files recursively in a directory, async off the main cocos thread.<br>
---* param dirPath The path of the directory, it could be a relative or an absolute path.<br>
---* param callback The callback to be called once the list operation is complete. <br>
---* Will be called on the main cocos thread.<br>
---* js NA<br>
---* lua NA
---@param dirPath string
---@param callback function
---@return self
function FileUtils:listFilesRecursivelyAsync (dirPath,callback) end
---* Checks whether the path is an absolute path.<br>
---* note On Android, if the parameter passed in is relative to "assets/", this method will treat it as an absolute path.<br>
---* Also on Blackberry, path starts with "app/native/Resources/" is treated as an absolute path.<br>
---* param path The path that needs to be checked.<br>
---* return True if it's an absolute path, false if not.
---@param path string
---@return boolean
function FileUtils:isAbsolutePath (path) end
---@overload fun(string:string,string:string,string:string,function:function):self
---@overload fun(string:string,string:string,string:string):self
---@overload fun(string:string,string:string):self
---@overload fun(string:string,string:string,string2:function):self
---@param path string
---@param oldname string
---@param name string
---@param callback function
---@return self
function FileUtils:renameFile (path,oldname,name,callback) end
---* Get default resource root path.
---@return string
function FileUtils:getDefaultResourceRootPath () end
---* Loads the filenameLookup dictionary from the contents of a filename.<br>
---* note The plist file name should follow the format below:<br>
---* code<br>
---* <?xml version="1.0" encoding="UTF-8"?><br>
---* <!DOCTYPE plist PUBLIC "-AppleDTD PLIST 1.0EN" "http:www.apple.com/DTDs/PropertyList-1.0.dtd"><br>
---* <plist version="1.0"><br>
---* <dict><br>
---* <key>filenames</key><br>
---* <dict><br>
---* <key>sounds/click.wav</key><br>
---* <string>sounds/click.caf</string><br>
---* <key>sounds/endgame.wav</key><br>
---* <string>sounds/endgame.caf</string><br>
---* <key>sounds/gem-0.wav</key><br>
---* <string>sounds/gem-0.caf</string><br>
---* </dict><br>
---* <key>metadata</key><br>
---* <dict><br>
---* <key>version</key><br>
---* <integer>1</integer><br>
---* </dict><br>
---* </dict><br>
---* </plist><br>
---* endcode<br>
---* param filename The plist file name.<br>
---* since v2.1<br>
---* js loadFilenameLookup<br>
---* lua loadFilenameLookup
---@param filename string
---@return self
function FileUtils:loadFilenameLookupDictionaryFromFile (filename) end
---*  Checks whether to pop up a message box when failed to load an image.<br>
---* return True if pop up a message box when failed to load an image, false if not.
---@return boolean
function FileUtils:isPopupNotify () end
---* 
---@param filename string
---@return array_table
function FileUtils:getValueVectorFromFile (filename) end
---* Gets the array of search paths.<br>
---* return The array of search paths which may contain the prefix of default resource root path. <br>
---* note In best practise, getter function should return the value of setter function passes in.<br>
---* But since we should not break the compatibility, we keep using the old logic. <br>
---* Therefore, If you want to get the original search paths, please call 'getOriginalSearchPaths()' instead.<br>
---* see fullPathForFilename(const char*).<br>
---* lua NA
---@return array_table
function FileUtils:getSearchPaths () end
---* write a ValueMap into a plist file<br>
---* param dict the ValueMap want to save<br>
---* param fullPath The full path to the file you want to save a string<br>
---* return bool
---@param dict map_table
---@param fullPath string
---@return boolean
function FileUtils:writeToFile (dict,fullPath) end
---* Gets the original search path array set by 'setSearchPaths' or 'addSearchPath'.<br>
---* return The array of the original search paths
---@return array_table
function FileUtils:getOriginalSearchPaths () end
---* Gets the new filename from the filename lookup dictionary.<br>
---* It is possible to have a override names.<br>
---* param filename The original filename.<br>
---* return The new filename after searching in the filename lookup dictionary.<br>
---* If the original filename wasn't in the dictionary, it will return the original filename.
---@param filename string
---@return string
function FileUtils:getNewFilename (filename) end
---* List all files in a directory.<br>
---* param dirPath The path of the directory, it could be a relative or an absolute path.<br>
---* return File paths in a string vector
---@param dirPath string
---@return array_table
function FileUtils:listFiles (dirPath) end
---* Converts the contents of a file to a ValueMap.<br>
---* param filename The filename of the file to gets content.<br>
---* return ValueMap of the file contents.<br>
---* note This method is used internally.
---@param filename string
---@return map_table
function FileUtils:getValueMapFromFile (filename) end
---@overload fun(string:string,function:function):self
---@overload fun(string:string):self
---@param filepath string
---@param callback function
---@return self
function FileUtils:getFileSize (filepath,callback) end
---*  Converts the contents of a file to a ValueMap.<br>
---* This method is used internally.
---@param filedata char
---@param filesize int
---@return map_table
function FileUtils:getValueMapFromData (filedata,filesize) end
---@overload fun(string:string,function:function):self
---@overload fun(string:string):self
---@param dirPath string
---@param callback function
---@return self
function FileUtils:removeDirectory (dirPath,callback) end
---* Sets the array of search paths.<br>
---* You can use this array to modify the search path of the resources.<br>
---* If you want to use "themes" or search resources in the "cache", you can do it easily by adding new entries in this array.<br>
---* note This method could access relative path and absolute path.<br>
---* If the relative path was passed to the vector, FileUtils will add the default resource directory before the relative path.<br>
---* For instance:<br>
---* On Android, the default resource root path is "assets/".<br>
---* If "/mnt/sdcard/" and "resources-large" were set to the search paths vector,<br>
---* "resources-large" will be converted to "assets/resources-large" since it was a relative path.<br>
---* param searchPaths The array contains search paths.<br>
---* see fullPathForFilename(const char*)<br>
---* since v2.1<br>
---* In js:var setSearchPaths(var jsval);<br>
---* lua NA
---@param searchPaths array_table
---@return self
function FileUtils:setSearchPaths (searchPaths) end
---@overload fun(string:string,string:string,function:function):self
---@overload fun(string:string,string:string):self
---@param dataStr string
---@param fullPath string
---@param callback function
---@return self
function FileUtils:writeStringToFile (dataStr,fullPath,callback) end
---* Sets the array that contains the search order of the resources.<br>
---* param searchResolutionsOrder The source array that contains the search order of the resources.<br>
---* see getSearchResolutionsOrder(), fullPathForFilename(const char*).<br>
---* since v2.1<br>
---* In js:var setSearchResolutionsOrder(var jsval)<br>
---* lua NA
---@param searchResolutionsOrder array_table
---@return self
function FileUtils:setSearchResolutionsOrder (searchResolutionsOrder) end
---* Append search order of the resources.<br>
---* see setSearchResolutionsOrder(), fullPathForFilename().<br>
---* since v2.1
---@param order string
---@param front boolean
---@return self
function FileUtils:addSearchResolutionsOrder (order,front) end
---* Add search path.<br>
---* since v2.1
---@param path string
---@param front boolean
---@return self
function FileUtils:addSearchPath (path,front) end
---@overload fun(array_table:array_table,string:string,function:function):self
---@overload fun(array_table:array_table,string:string):self
---@param vecData array_table
---@param fullPath string
---@param callback function
---@return self
function FileUtils:writeValueVectorToFile (vecData,fullPath,callback) end
---@overload fun(string:string,function:function):self
---@overload fun(string:string):self
---@param filename string
---@param callback function
---@return self
function FileUtils:isFileExist (filename,callback) end
---* Purges full path caches.
---@return self
function FileUtils:purgeCachedEntries () end
---* Gets full path from a file name and the path of the relative file.<br>
---* param filename The file name.<br>
---* param relativeFile The path of the relative file.<br>
---* return The full path.<br>
---* e.g. filename: hello.png, pszRelativeFile: /User/path1/path2/hello.plist<br>
---* Return: /User/path1/path2/hello.pvr (If there a a key(hello.png)-value(hello.pvr) in FilenameLookup dictionary. )
---@param filename string
---@param relativeFile string
---@return string
function FileUtils:fullPathFromRelativeFile (filename,relativeFile) end
---* Windows fopen can't support UTF-8 filename<br>
---* Need convert all parameters fopen and other 3rd-party libs<br>
---* param filenameUtf8 std::string name file for conversion from utf-8<br>
---* return std::string ansi filename in current locale
---@param filenameUtf8 string
---@return string
function FileUtils:getSuitableFOpen (filenameUtf8) end
---@overload fun(map_table:map_table,string:string,function:function):self
---@overload fun(map_table:map_table,string:string):self
---@param dict map_table
---@param fullPath string
---@param callback function
---@return self
function FileUtils:writeValueMapToFile (dict,fullPath,callback) end
---* Gets filename extension is a suffix (separated from the base filename by a dot) in lower case.<br>
---* Examples of filename extensions are .png, .jpeg, .exe, .dmg and .txt.<br>
---* param filePath The path of the file, it could be a relative or absolute path.<br>
---* return suffix for filename in lower case or empty if a dot not found.
---@param filePath string
---@return string
function FileUtils:getFileExtension (filePath) end
---* Sets writable path.
---@param writablePath string
---@return self
function FileUtils:setWritablePath (writablePath) end
---* Sets whether to pop-up a message box when failed to load an image.
---@param notify boolean
---@return self
function FileUtils:setPopupNotify (notify) end
---@overload fun(string:string,function:function):self
---@overload fun(string:string):self
---@param fullPath string
---@param callback function
---@return self
function FileUtils:isDirectoryExist (fullPath,callback) end
---* Set default resource root path.
---@param path string
---@return self
function FileUtils:setDefaultResourceRootPath (path) end
---* Gets the array that contains the search order of the resources.<br>
---* see setSearchResolutionsOrder(const std::vector<std::string>&), fullPathForFilename(const char*).<br>
---* since v2.1<br>
---* lua NA
---@return array_table
function FileUtils:getSearchResolutionsOrder () end
---@overload fun(string:string,function:function):self
---@overload fun(string:string):self
---@param dirPath string
---@param callback function
---@return self
function FileUtils:createDirectory (dirPath,callback) end
---* List all files in a directory async, off of the main cocos thread.<br>
---* param dirPath The path of the directory, it could be a relative or an absolute path.<br>
---* param callback The callback to be called once the list operation is complete. Will be called on the main cocos thread.<br>
---* js NA<br>
---* lua NA
---@param dirPath string
---@param callback function
---@return self
function FileUtils:listFilesAsync (dirPath,callback) end
---* Gets the writable path.<br>
---* return  The path that can be write/read a file in
---@return string
function FileUtils:getWritablePath () end
---* List all files recursively in a directory.<br>
---* param dirPath The path of the directory, it could be a relative or an absolute path.<br>
---* return File paths in a string vector
---@param dirPath string
---@param files array_table
---@return self
function FileUtils:listFilesRecursively (dirPath,files) end
---* Destroys the instance of FileUtils.
---@return self
function FileUtils:destroyInstance () end
---* Gets the instance of FileUtils.
---@return self
function FileUtils:getInstance () end