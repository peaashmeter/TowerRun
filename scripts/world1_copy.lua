-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

math.randomseed(os.clock())

local physics = require "physics"
physics.start()
physics.setGravity(0, 0)


local background = display.newGroup()
local foreground = display.newGroup()
local objects = display.newGroup()
local gameStarted = 0

local _CX = display.contentCenterX
local _CY = display.contentCenterY
local _CH = display.contentHeight
local _CW = display.contentWidth
local startX
local gameEnded = 0

local sheetOptions = {
  width = 64,
  height = 64,
  numFrames = 10
  }

local hero1_sheet = graphics.newImageSheet('images/hero1_strip.png', sheetOptions)


local hero1_sequence = {
  {     name = "leftCollide",
        start = 1,
        count = 5,
        time = 200,
        loopCount = 1,
        loopDirection = "bounce"
    },

 {
        name = "rightCollide",
        start = 6,
        count = 5,
        time = 200,
        loopCount = 1,
        loopDirection = "bounce"
    }
}

display.setDefault( "textureWrapX", "repeat" )
display.setDefault( "textureWrapY", "repeat" )




local hero = display.newSprite(hero1_sheet, hero1_sequence)
hero.x = _CX
hero.y = _CH - 90
physics.addBody(hero)
hero:setFrame(1)


local function endGame()
    gameEnded = 1
    transition.cancel(leftRect)
    transition.cancel(rightRect)
    transition.cancel(back)
end

local function startGame()
      gameEnded = 0
      transition.to(leftRect, {time = 60000, y = 5000, onComplete = endGame})
      transition.to(rightRect, {time = 60000, y = 5000})
      transition.to(back, {time = 60000, y = back.y + 400})
end




local function heroLeftCollide()
  if (hero and gameEnded == 0) then
    hero:setSequence('leftCollide')
    hero:play()
  end
end

local function heroRightCollide()
  if (hero and gameEnded == 0) then
    hero:setSequence('rightCollide')
    hero:play()
  end
end

function moveHero(event)
  if (event.phase == 'began') then
      startX = event.x
  elseif (event.phase == 'ended') then
      if (gameStarted == 0 and event.x < startX) then
       transition.to(hero, {time = 100, x = 96})
       gameStarted = 1
       startGame()
       dangerTimers()
       heroLeftCollide()
       hero.position = 'left'
      end
     if (gameStarted == 0 and event.x > startX) then
       transition.to(hero, {time = 100, x = _CW - 96})
       gameStarted = 1
       startGame()
       dangerTimers()
       heroRightCollide()
       hero.position = 'right'
     end
     if (event.x > startX) then
       transition.to(hero, {time = 200, x = _CW - 96})
       if (hero.position ~= 'right') then
         heroRightCollide()
         hero.position = 'right'
       end
     end
     if (event.x < startX) then
       transition.to(hero, {time = 200, x = 96})
       if (hero.position ~='left') then
         heroLeftCollide()
         hero.position = 'left'
       end
     end
   end
   return true
end


function sawCollision (self, event)
  if (event.phase == 'began') then
    display.remove(hero)
    hero:removeSelf()
    endGame()
  end
end


function setGame()

  leftRect = display.newRect(foreground, 32, -5000 + _CH, 64, 10000)
  local scaleFactorX = 64 / leftRect.width
  local scaleFactorY = 64 / leftRect.height

  leftRect.fill = {type = 'image', filename = 'images/block.png'}

  leftRect.fill.scaleX = scaleFactorX
  leftRect.fill.scaleY = scaleFactorY


  rightRect = display.newRect(foreground, _CW - 32, -5000 + _CH, 64, 10000)
  local scaleFactorX = 64 / rightRect.width
  local scaleFactorY = 64 / rightRect.height

  rightRect.fill = {type = 'image', filename = 'images/block.png'}

  rightRect.fill.scaleX = scaleFactorX
  rightRect.fill.scaleY = scaleFactorY


  back = display.newImageRect(background, 'images/back.png', 450, 1250)
  back.x = _CX
  back.y = _CY - 225
  back:addEventListener ('touch', moveHero)


  local edgeGradientDown = display.newRect(foreground, _CX, _CH - 32, 450, 64)
  edgeGradientDown.fill = {
    type = "gradient",
    color1 = { 0, 0, 0, 0},
    color2 = {0, 0, 0, 1},
    direction = "down"
  }

  local edgeGradientUp = display.newRect(foreground, _CX, 32, 450, 64)
  edgeGradientUp.fill = {
  type = "gradient",
  color1 = { 0, 0, 0, 0},
  color2 = {0, 0, 0, 1},
  direction = "up"
  }

end

setGame()

function sawSet()
  if (gameEnded == 0) then
    math.randomseed(os.clock())
    if (math.random(2) == 1) then
      math.randomseed(os.clock())
      saw_big = display.newImage(background, 'images/saw_big.png')
      saw_big.x = 64
      saw_big.y = -300
      transition.to(saw_big, {time = 2000, y = _CH + 500, rotation = saw_big.rotation + 360})
    elseif (math.random(2) ~= 1) then
      math.randomseed(os.clock())
      saw_big = display.newImage(background, 'images/saw_big.png')
      saw_big.x = _CW - 64
      saw_big.y = -300
      transition.to(saw_big, {time = 2000, y = _CH + 500, rotation = saw_big.rotation - 360})
    end
      if (saw_big and saw_big.y > _CH + 500) then
        display.remove(saw_big)
      end
      if (saw_big) then
        physics.addBody(saw_big, 'static', {radius = 128})
      end
  end
  if (saw_big) then
    saw_big.collision = sawCollision
    saw_big:addEventListener('collision')
  end
end

function dangerTimers()
  timer.performWithDelay(1000 + math.random(2000)/20, sawSet, 0)
end


hero.collision = sawCollision
hero:addEventListener('collision')
