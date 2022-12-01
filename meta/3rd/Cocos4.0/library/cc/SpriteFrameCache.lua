---@meta

---@class cc.SpriteFrameCache :cc.Ref
local SpriteFrameCache={ }
cc.SpriteFrameCache=SpriteFrameCache




---* 
---@param plist string
---@return boolean
function SpriteFrameCache:reloadTexture (plist) end
---*  Adds multiple Sprite Frames from a plist file content. The texture will be associated with the created sprite frames. <br>
---* js NA<br>
---* lua addSpriteFrames<br>
---* param plist_content Plist file content string.<br>
---* param texture Texture pointer.
---@param plist_content string
---@param texture cc.Texture2D
---@return self
function SpriteFrameCache:addSpriteFramesWithFileContent (plist_content,texture) end
---*  Adds an sprite frame with a given name.<br>
---* If the name already exists, then the contents of the old name will be replaced with the new one.<br>
---* param frame A certain sprite frame.<br>
---* param frameName The name of the sprite frame.
---@param frame cc.SpriteFrame
---@param frameName string
---@return self
function SpriteFrameCache:addSpriteFrame (frame,frameName) end
---@overload fun(string:string,cc.Texture2D1:string):self
---@overload fun(string:string):self
---@overload fun(string:string,cc.Texture2D:cc.Texture2D):self
---@param plist string
---@param texture cc.Texture2D
---@return self
function SpriteFrameCache:addSpriteFramesWithFile (plist,texture) end
---*  Returns an Sprite Frame that was previously added.<br>
---* If the name is not found it will return nil.<br>
---* You should retain the returned copy if you are going to use it.<br>
---* js getSpriteFrame<br>
---* lua getSpriteFrame<br>
---* param name A certain sprite frame name.<br>
---* return The sprite frame.
---@param name string
---@return cc.SpriteFrame
function SpriteFrameCache:getSpriteFrameByName (name) end
---*  Removes multiple Sprite Frames from a plist file.<br>
---* Sprite Frames stored in this file will be removed.<br>
---* It is convenient to call this method when a specific texture needs to be removed.<br>
---* since v0.99.5<br>
---* param plist The name of the plist that needs to removed.
---@param plist string
---@return self
function SpriteFrameCache:removeSpriteFramesFromFile (plist) end
---*  Initialize method.<br>
---* return if success return true.
---@return boolean
function SpriteFrameCache:init () end
---*  Purges the dictionary of loaded sprite frames.<br>
---* Call this method if you receive the "Memory Warning".<br>
---* In the short term: it will free some resources preventing your app from being killed.<br>
---* In the medium term: it will allocate more resources.<br>
---* In the long term: it will be the same.
---@return self
function SpriteFrameCache:removeSpriteFrames () end
---*  Removes unused sprite frames.<br>
---* Sprite Frames that have a retain count of 1 will be deleted.<br>
---* It is convenient to call this method after when starting a new Scene.<br>
---* js NA
---@return self
function SpriteFrameCache:removeUnusedSpriteFrames () end
---*  Removes multiple Sprite Frames from a plist file content.<br>
---* Sprite Frames stored in this file will be removed.<br>
---* It is convenient to call this method when a specific texture needs to be removed.<br>
---* param plist_content The string of the plist content that needs to removed.<br>
---* js NA
---@param plist_content string
---@return self
function SpriteFrameCache:removeSpriteFramesFromFileContent (plist_content) end
---*  Deletes an sprite frame from the sprite frame cache. <br>
---* param name The name of the sprite frame that needs to removed.
---@param name string
---@return self
function SpriteFrameCache:removeSpriteFrameByName (name) end
---*  Check if multiple Sprite Frames from a plist file have been loaded.<br>
---* js NA<br>
---* lua NA<br>
---* param plist Plist file name.<br>
---* return True if the file is loaded.
---@param plist string
---@return boolean
function SpriteFrameCache:isSpriteFramesWithFileLoaded (plist) end
---*  Removes all Sprite Frames associated with the specified textures.<br>
---* It is convenient to call this method when a specific texture needs to be removed.<br>
---* since v0.995.<br>
---* param texture The texture that needs to removed.
---@param texture cc.Texture2D
---@return self
function SpriteFrameCache:removeSpriteFramesFromTexture (texture) end
---*  Destroys the cache. It releases all the Sprite Frames and the retained instance.<br>
---* js NA
---@return self
function SpriteFrameCache:destroyInstance () end
---*  Returns the shared instance of the Sprite Frame cache.<br>
---* return The instance of the Sprite Frame Cache.<br>
---* js NA
---@return self
function SpriteFrameCache:getInstance () end