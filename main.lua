---------------------------------------------------------------------------------
--
-- main.lua
--
---------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- require the composer library
local composer = require "composer"

local displayGroup = display.newGroup()

local rotationTimer
local pictures = {}

local rotationTime = 300
local transitionTime = rotationTime / 2

local reduceFactor = 0.75
local imageWidth, imageHeight = 250, 100
local reducedImageWidth, reducedImageHeight = 250 * reduceFactor, 100 * reduceFactor
local centerX, centerY = display.contentCenterX, display.contentCenterY
local topPosX, topPosY = centerX, centerY - 70
local bottomPosX, bottomPosY = centerX, centerY + 70

local function setTopDepthEffect(object)
  object.path.x1 = 30
  object.path.x2 = 10
  object.path.x4 = -30
  object.path.x3 = -10
end

local function setBottomDepthEffect(object)
  object.path.x1 = -30
  object.path.x2 = -10
  object.path.x4 = 30
  object.path.x3 = 10
end

-- center picture
local pic1 = display.newImageRect(displayGroup, "img/01.png", imageWidth, imageHeight)
pic1.x, pic1.y = centerX, centerY
pic1.position = "center"
pic1.type = "Double Score"
pictures[#pictures + 1] = pic1

-- top picture
local pic2 = display.newImageRect(displayGroup, "img/02.png", imageWidth, imageHeight)
pic2.x, pic2.y = topPosX, topPosY
pic2.position = "top"
pic2.type = "Slow Down"
pictures[#pictures + 1] = pic2
setTopDepthEffect(pic2)

-- bottom picture
local pic3 = display.newImageRect(displayGroup, "img/03.png", imageWidth, imageHeight)
pic3.x, pic3.y = bottomPosX, bottomPosY
pic3.position = "bottom"
pic3.type = "+1 Life"
pictures[#pictures + 1] = pic3
setBottomDepthEffect(pic3)

-- invisible picture
local pic4 = display.newImageRect(displayGroup, "img/04.png", imageWidth, imageHeight)
pic4.x, pic4.y = rightPosX, rightPosY
pic4.position = "notVisible"
pic4.type = "Speed Up"
pic4.alpha = 0
pictures[#pictures + 1] = pic4

local function animateBottomDepthEffect(object)
  transition.to( object.path, { time=transitionTime, x1=-30, x2=-10, x3=10, x4=30 } )
end

local function animateTopDepthEffect(object)
  transition.to( object.path, { time=transitionTime, x1=30, x2=10, x3=-10, x4=-30 } )
end

local function animateNoDepthEffect(object)
  transition.to( object.path, { time=transitionTime, x1=0, x2=0, x3=0, x4=0 } )
end

local function rotateImage(object)

  if object.position == "top" then
    object.position = "center"
    object:toFront()
    transition.to(object, { time=transitionTime, x=centerX, y=centerY, width=imageWidth, height=imageHeight } )
    animateNoDepthEffect(object)

  elseif object.position == "center" then
    object.position = "bottom"
    transition.to(object, { time=transitionTime, x=bottomPosX, y=bottomPosY, width=reducedImageWidth, height=reducedImageHeight } )
    animateBottomDepthEffect(object)

  elseif object.position == "bottom" then
    object.position = "notVisible"
    transition.to(object, { time=transitionTime/2, alpha=0, x=bottomPosX, y=bottomPosY } )

  elseif object.position == "notVisible" then
    object.position = "top"
    object.x, object.y = topPosX, topPosY
    object.width, object.height = reducedImageWidth, reducedImageHeight
    setTopDepthEffect(object)
    transition.to(object, { time=rotationTime, alpha=1 } )

  end
end

local function rotateImages()
  rotateImage(pic1)
  rotateImage(pic2)
  rotateImage(pic3)
  rotateImage(pic4)
end

local function getCenterPicture()
  for i = 1, #pictures do
    local picture = pictures[i]
    if picture.position == "center" then
      print("Selected bonus mode: " .. picture.type)
    end
  end
end

rotationTimer = timer.performWithDelay(rotationTime, rotateImages, -1)

local function onObjectTap( event )
  if rotationTimer then
    timer.cancel( rotationTimer )
    rotationTimer = nil
    getCenterPicture()
  else
    rotationTimer = timer.performWithDelay(rotationTime, rotateImages, -1)
  end
  return true
end
displayGroup:addEventListener( "tap", onObjectTap )
