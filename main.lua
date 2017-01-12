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

local pictures = {}

local centerX, centerY = display.contentCenterX, display.contentCenterY
local topPosX, topPosY = centerX, centerY - 70
local leftPosX, leftPosY = centerX - 200, centerY - 20
local rightPosX, rightPosY = centerX + 200, centerY - 20

-- Add any objects that should appear on all scenes below (e.g. tab bar, hud, etc)
local pic1 = display.newImageRect(displayGroup, "img/01.png", 250, 100)
pic1.x, pic1.y = centerX, centerY + 70
pic1.myName = "center"

pic1.path.x4 = 0
pic1.path.y4 = 0
pic1.path.x2 = 0
pic1.path.y2 = 0

pictures[#pictures+1] = pic1

-- Add any objects that should appear on all scenes below (e.g. tab bar, hud, etc)
local pic2 = display.newImageRect(displayGroup, "img/02.png", 250, 100)
pic2.x, pic2.y = topPosX, topPosY
pic2.myName = "top"

pic2.fill.effect = "filter.blur"

pic2.path.x4 = 0
pic2.path.y4 = 0
pic2.path.x2 = 0
pic2.path.y2 = 0

pictures[#pictures+1] = pic2

local pic3 = display.newImageRect(displayGroup, "img/03.png", 250, 100)
pic3.x, pic3.y = leftPosX, leftPosY
pic3.fill.effect = "filter.blur"
pic3.myName = "left"

pictures[#pictures+1] = pic3

local pic4 = display.newImageRect(displayGroup, "img/04.png", 250, 100)
pic4.x, pic4.y = rightPosX, rightPosY
pic4.fill.effect = "filter.blur"
pic4.myName = "right"

pictures[#pictures+1] = pic3

pic1:toFront()

local inTransition = false

local transitionTime = 500

local function changeBlur(object, isBlurred)
  if object and object.fill and isBlurred then
    object.fill.effect = "filter.blur"
    transition.to( object.fill.effect, { time=transitionTime, intensity=1 } )
  elseif object and not isBlurred then
    --object.fill = nil
  end
  inTransition = false
end

local function rotateImage(object)
  if object.myName == "center" then
    object.myName = "left"
    transition.to(object, { time=transitionTime, x=(leftPosX), y=(leftPosY), onComplete=changeBlur(object, true) } )

  elseif object.myName == "left" then
    object.myName = "top"
    transition.to(object, { time=transitionTime, x=(topPosX), y=(topPosY), onComplete=changeBlur(object, true) } )

  elseif object.myName == "top" then
    object.myName = "right"
    transition.to(object, { time=transitionTime, x=(rightPosX), y=(rightPosY), onComplete=changeBlur(object, true) } )

  elseif object.myName == "right" then
    object.myName = "center"
    transition.to(object, { time=transitionTime, x=(centerX), y=(centerY), onComplete=changeBlur(object, false) } )

  end
end

local function rotateImages()
  rotateImage(pic1)
  rotateImage(pic2)
  rotateImage(pic3)
  rotateImage(pic4)
end
timer.performWithDelay(1000, rotateImages, -1)
