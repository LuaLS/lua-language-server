---@meta

---@class ccs.ArmatureDataManager :cc.Ref
local ArmatureDataManager={ }
ccs.ArmatureDataManager=ArmatureDataManager




---* brief    remove animation data<br>
---* param     id the id of the animation data
---@param id string
---@return self
function ArmatureDataManager:removeAnimationData (id) end
---* Add armature data<br>
---* param id The id of the armature data<br>
---* param armatureData ArmatureData *
---@param id string
---@param armatureData ccs.ArmatureData
---@param configFilePath string
---@return self
function ArmatureDataManager:addArmatureData (id,armatureData,configFilePath) end
---@overload fun(string:string,string:string,string:string):self
---@overload fun(string:string):self
---@param imagePath string
---@param plistPath string
---@param configFilePath string
---@return self
function ArmatureDataManager:addArmatureFileInfo (imagePath,plistPath,configFilePath) end
---* 
---@param configFilePath string
---@return self
function ArmatureDataManager:removeArmatureFileInfo (configFilePath) end
---* 
---@return map_table
function ArmatureDataManager:getTextureDatas () end
---* brief    get texture data<br>
---* param     id the id of the texture data you want to get<br>
---* return TextureData *
---@param id string
---@return ccs.TextureData
function ArmatureDataManager:getTextureData (id) end
---* brief    get armature data<br>
---* param    id the id of the armature data you want to get<br>
---* return    ArmatureData *
---@param id string
---@return ccs.ArmatureData
function ArmatureDataManager:getArmatureData (id) end
---* brief    get animation data from _animationDatas(Dictionary)<br>
---* param     id the id of the animation data you want to get<br>
---* return AnimationData *
---@param id string
---@return ccs.AnimationData
function ArmatureDataManager:getAnimationData (id) end
---* brief    add animation data<br>
---* param     id the id of the animation data<br>
---* return AnimationData *
---@param id string
---@param animationData ccs.AnimationData
---@param configFilePath string
---@return self
function ArmatureDataManager:addAnimationData (id,animationData,configFilePath) end
---* Init ArmatureDataManager
---@return boolean
function ArmatureDataManager:init () end
---* brief    remove armature data<br>
---* param    id the id of the armature data you want to get
---@param id string
---@return self
function ArmatureDataManager:removeArmatureData (id) end
---* 
---@return map_table
function ArmatureDataManager:getArmatureDatas () end
---* brief    remove texture data<br>
---* param     id the id of the texture data you want to get
---@param id string
---@return self
function ArmatureDataManager:removeTextureData (id) end
---* brief    add texture data<br>
---* param     id the id of the texture data<br>
---* return TextureData *
---@param id string
---@param textureData ccs.TextureData
---@param configFilePath string
---@return self
function ArmatureDataManager:addTextureData (id,textureData,configFilePath) end
---* 
---@return map_table
function ArmatureDataManager:getAnimationDatas () end
---* brief    Judge whether or not need auto load sprite file
---@return boolean
function ArmatureDataManager:isAutoLoadSpriteFile () end
---* brief    Add sprite frame to CCSpriteFrameCache, it will save display name and it's relative image name
---@param plistPath string
---@param imagePath string
---@param configFilePath string
---@return self
function ArmatureDataManager:addSpriteFrameFromFile (plistPath,imagePath,configFilePath) end
---* 
---@return self
function ArmatureDataManager:destroyInstance () end
---* 
---@return self
function ArmatureDataManager:getInstance () end