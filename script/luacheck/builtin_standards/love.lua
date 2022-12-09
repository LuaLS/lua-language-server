local standards = require "luacheck.standards"

local empty = {}
local read_write = {read_only = false}

local love = {
   fields = {
      getVersion = empty,
      conf = read_write,
      directorydropped = read_write,
      draw = read_write,
      errhand = read_write,
      errorhandler = read_write,
      filedropped = read_write,
      focus = read_write,
      gamepadaxis = read_write,
      gamepadpressed = read_write,
      gamepadreleased = read_write,
      handlers = read_write,
      hasDeprecationOutput = empty,
      joystickadded = read_write,
      joystickaxis = read_write,
      joystickhat = read_write,
      joystickpressed = read_write,
      joystickreleased = read_write,
      joystickremoved = read_write,
      keypressed = read_write,
      keyreleased = read_write,
      load = read_write,
      lowmemory = read_write,
      mousefocus = read_write,
      mousemoved = read_write,
      mousepressed = read_write,
      mousereleased = read_write,
      quit = read_write,
      resize = read_write,
      run = read_write,
      setDeprecationOutput = empty,
      textedited = read_write,
      textinput = read_write,
      threaderror = read_write,
      touchmoved = read_write,
      touchpressed = read_write,
      touchreleased = read_write,
      update = read_write,
      visible = read_write,
      wheelmoved = read_write,

      audio = standards.def_fields("getDistanceModel","getDopplerScale","getSourceCount","getOrientation",
         "getPosition","getVelocity","getVolume","newSource","pause","play","setDistanceModel","setDopplerScale",
         "setOrientation","setPosition","setVelocity", "setVolume","stop","getActiveSourceCount","getRecordingDevices",
         "newQueueableSource","setEffect","getActiveEffects","getEffect","getMaxSceneEffects","getMaxSourceEffects",
         "isEffectsSupported","setMixWithSystem"),

      data = standards.def_fields("compress","decode","decompress","encode","getPackedSize","hash","newByteData",
         "newDataView","pack","unpack"),

      event = standards.def_fields("clear","poll","pump","push","quit","wait"),

      filesystem = standards.def_fields("append","areSymlinksEnabled","createDirectory","exists",
         "getAppdataDirectory","getDirectoryItems","getIdentity","getLastModified",
         "getRealDirectory","getRequirePath","getSaveDirectory","getSize","getSource",
         "getSourceBaseDirectory","getUserDirectory","getWorkingDirectory","init","isDirectory",
         "isFile","isFused","isSymlink","lines","load","mount","newFile","newFileData","read",
         "remove","setIdentity","setRequirePath","setSource","setSymlinksEnabled","unmount","write",
         "getInfo","setCRequirePath","getCRequirePath"),

      font = standards.def_fields("newImageRasterizer", "newGlyphData", "newTrueTypeRasterizer",
         "newBMFontRasterizer", "newRasterizer"),

      graphics = standards.def_fields("arc","circle","clear","discard","draw","ellipse","getBackgroundColor",
         "getBlendMode","getCanvas","getCanvasFormats","getColor","getColorMask",
         "getDefaultFilter","getDimensions","getFont","getHeight",
         "getLineJoin","getLineStyle","getLineWidth","getShader","getStats","getStencilTest",
         "getSupported","getSystemLimits","getPointSize","getRendererInfo","getScissor","getWidth",
         "intersectScissor","isGammaCorrect","isWireframe","line","newCanvas","newFont","newMesh",
         "newImage","newImageFont","newParticleSystem","newShader","newText","newQuad",
         "newSpriteBatch","newVideo","origin","points","polygon","pop","present",
         "print","printf","push","rectangle","reset","rotate","scale","setBackgroundColor",
         "setBlendMode","setCanvas","setColor","setColorMask","setDefaultFilter","setFont",
         "setLineJoin","setLineStyle","setLineWidth","setNewFont","setShader","setPointSize",
         "setScissor","setStencilTest","setWireframe","shear","stencil","translate",
         "captureScreenshot","getImageFormats","newArrayImage","newVolumeImage","newCubeImage",
         "getTextureTypes","drawLayer","setDepthMode","setMeshCullMode","setFrontFaceWinding",
         "applyTransform","replaceTransform","transformPoint","inverseTransformPoint","getStackDepth",
         "flushBatch","validateShader","drawInstanced","getDepthMode","getFrontFaceWinding","getMeshCullMode",
         "getDPIScale","getPixelDimensions","getPixelHeight","getPixelWidth","isActive","getDefaultMipmapFilter",
         "setDefaultMipmapFilter"),

      image = standards.def_fields("isCompressed","newCompressedData","newImageData","newCubeFaces"),

      joystick = standards.def_fields("getJoystickCount","getJoysticks","loadGamepadMappings",
         "saveGamepadMappings","setGamepadMapping"),

      keyboard = standards.def_fields("getKeyFromScancode","getScancodeFromKey","hasKeyRepeat","hasTextInput",
         "isDown","isScancodeDown","setKeyRepeat","setTextInput","hasScreenKeyboard"),

      math = standards.def_fields("compress","decompress","gammaToLinear","getRandomSeed","getRandomState",
         "isConvex","linearToGamma","newBezierCurve","newRandomGenerator","noise","random",
         "randomNormal","setRandomSeed","setRandomState","triangulate","newTransform"),

      mouse = standards.def_fields("getCursor","getPosition","getRelativeMode","getSystemCursor","getX",
         "getY","hasCursor","isDown","isGrabbed","isVisible","newCursor","setCursor","setGrabbed",
         "setPosition","setRelativeMode","setVisible","setX","setY","isCursorSupported"),

      physics = standards.def_fields("getDistance","getMeter","newBody","newChainShape","newCircleShape",
         "newDistanceJoint","newEdgeShape","newFixture","newFrictionJoint","newGearJoint",
         "newMotorJoint","newMouseJoint","newPolygonShape","newPrismaticJoint","newPulleyJoint",
         "newRectangleShape","newRevoluteJoint","newRopeJoint","newWeldJoint","newWheelJoint",
         "newWorld","setMeter"),

      sound = standards.def_fields("newDecoder","newSoundData"),

      system = standards.def_fields("getClipboardText","getOS","getPowerInfo","getProcessorCount","openURL",
         "setClipboardText","vibrate","hasBackgroundMusic"),

      thread = standards.def_fields("getChannel","newChannel","newThread"),

      timer = standards.def_fields("getAverageDelta","getDelta","getFPS","getTime","sleep","step"),

      touch = standards.def_fields("getPosition","getPressure","getTouches"),

      video = standards.def_fields("newVideoStream"),

      window = standards.def_fields("close","fromPixels","getDisplayName","getFullscreen",
         "getFullscreenModes","getIcon","getMode","getPixelScale","getPosition","getTitle",
         "hasFocus","hasMouseFocus","isDisplaySleepEnabled","isMaximized","isOpen","isVisible",
         "maximize","minimize","requestAttention","setDisplaySleepEnabled","setFullscreen",
         "setIcon","setMode","setPosition","setTitle","showMessageBox","toPixels",
         "updateMode","isMinimized","restore","getDPIScale")
   }
}

-- `love` standard contains only `love` global, so return it here directly using normal std format.
return {
   read_globals = {love = love}
}
