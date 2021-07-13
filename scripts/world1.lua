-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------


--добавить сохранение игровой сессии в таблицу в отдельном скрипте, затем - в файл


local composer = require( "composer" )
local save = require ('scripts.save')



local scene = composer.newScene()

local physics = require "physics"
physics.start()
physics.setGravity(0, 0)




local _CX = display.contentCenterX
local _CY = display.contentCenterY
local _CH = display.contentHeight
local _CW = display.contentWidth
local startX
local gameEnded = 0

local ui
local background
local foreground
local objects
local gameStarted = 0
local gemsAmount = 0
local dangerSpeed = 0

display.setDefault( "textureWrapX", "repeat" )
display.setDefault( "textureWrapY", "repeat" )



--local hero
local saw_big
local danger
local fpsmeter

--аудио
local backgroundMusic




local function helpGarbage ()
  if (helpText and helpHand) then                    --сборка мусора (удаление начальной помощи)
    display.remove(helpHand)
    display.remove(helpText)
  end
end



local function dropParts ()
  for i = 1,2 do
    local dieParticle = display.newImage(objects, save.loadHalf(), hero.x, hero.y)
    dieParticle.rotation = -30 + math.random(60)
    transition.to( dieParticle, {transition = easing.inSine, time = 1000 + math.random(1000), y = dieParticle.y + 1000, x = dieParticle.x - 400 + math.random(800)})
  end
end






--composer.gotoScene('scripts.menu')

local function gotoMenu()
  return composer.gotoScene('scripts.menu', {effect = "crossFade", time = 400})
end

local function nextScene ()
  gameEnded = 0
  gameStarted = 0
  local randnum = math.random(1,2)
  if randnum == 1 then
    return composer.gotoScene('scripts.world2', {effect = "crossFade", time = 400})
  else
    return composer.gotoScene('scripts.world2', {effect = "crossFade", time = 400})
  end
end




local function endGame()
    gameEnded = 1
    transition.cancel(leftRect)
    transition.cancel(rightRect)
    transition.cancel(back)
    if (leftRect.y < 4950) then
      dropParts()
      save.writeData()
      timer.performWithDelay(2000, gotoMenu)
      audio.fadeOut( { channel=1, time=1000} )
      if emitter then
        display.remove(emitter)
      end
    elseif (leftRect.y >= 4950) then
      transition.to(hero, {transition = easing.inCubic, time = 3000, rotation = hero.rotation + 1080,
      width = hero.width*2, height = hero.height*2, y = hero.y - 1000, x = _CX, alpha = 0, onComplete = nextScene}) --переход в меню (временно)
      gemsTimer()
      plusGemsTimer()
      ui.alpha = 1
      audio.fadeOut( { channel=1, time=2000} )
      if emitter then
        display.remove(emitter)
      end
  end
end

local function startGame()
      gameEnded = 0
      transition.to(leftRect, {time = 30000, y = 5000, onComplete = endGame})
      transition.to(rightRect, {time = 30000, y = 5000})
      transition.to(back, {time = 30000, y = back.y + 400})
      transition.to(helpHand, {time = 500, alpha = 0, onComplete = helpGarbage})
      transition.to(helpText, {time = 500, alpha = 0})
      speedUp = timer.performWithDelay(1000, dangerSpeedTimer, 0)
      audio.setVolume( 0.5, { channel=1 } )
      audio.play(backgroundMusic, {channel = 1})
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
      if (gameStarted == 0 and event.x and startX and event.x < startX ) then
       transition.to(hero, {time = 100, x = 96})
       if emitter then
         transition.to(emitter, {time = 100, x = 96})
       end
       gameStarted = 1
       startGame()
       dangerTimers()
       cloudTimers()
       heroLeftCollide()
       hero.position = 'left'
      end
     if (gameStarted == 0 and event.x and startX and event.x > startX) then
       transition.to(hero, {time = 100, x = _CW - 96})
       if emitter then
         transition.to(emitter, {time = 100, x = _CW - 96})
       end
       gameStarted = 1
       startGame()
       dangerTimers()
       cloudTimers()
       heroRightCollide()
       hero.position = 'right'
     end
     if (gameEnded ~= 1 and event.x > startX) then
       transition.to(hero, {time = 200, x = _CW - 96})
       if emitter then
         transition.to(emitter, {time = 200, x = _CW - 96})
       end
       if (hero.position ~= 'right') then
         heroRightCollide()
         hero.position = 'right'
       end
     end
     if (gameEnded ~= 1 and event.x < startX) then

       transition.to(hero, {time = 200, x = 96})
       if emitter then
         transition.to(emitter, {time = 200, x = 96})
       end
       if (hero.position ~='left') then
         heroLeftCollide()
         hero.position = 'left'
       end
     end
   end
   return true
end


function sawCollision (self, event)
  if (event.phase == 'began' and event.other.name == 'saw_big') then
    display.remove(hero)
    hero:removeSelf()
    endGame()
  end
end







function dangerTimers()
  danger = timer.performWithDelay(500 + math.random(200), sawSet, 0)
end             --функции только для первого мира


function sawSet()
  local leftTimer, rightTimer = 0, 0
  if (gameEnded == 0 and leftRect.y < 4500) then
    --math.randomseed(os.clock())
    if (math.random(100) >= 50 and leftTimer < 3) then
      --math.randomseed(os.clock())
      leftTimer = leftTimer + 1
      rigthTimer = 0
      saw_big = display.newImage(background, 'images/saw_big.png')
      saw_big.x = 64
      saw_big.y = -300
      transition.to(saw_big, {time = 2000, y = _CH + 500, rotation = saw_big.rotation + 360})
      saw_big.name = 'saw_big'
    elseif (rightTimer < 3) then
    --  math.randomseed(os.clock())
      rigthTimer = rightTimer + 1
      leftTimer = 0
      saw_big = display.newImage(background, 'images/saw_big.png')
      saw_big.x = _CW - 64
      saw_big.y = -300
      transition.to(saw_big, {time = 2000, y = _CH + 500, rotation = saw_big.rotation - 360})
      saw_big.name = 'saw_big'
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



function cloudTimers()              -- анимированные облака
  cloudTimer = timer.performWithDelay(2000 + math.random(3000), cloudSet, 0)
end

function cloudSet()
  local cloudSize = math.random(2)
  if (gameEnded == 0) then
    if (cloudSize == 1) then
      cloud_small = display.newImageRect(background, 'images/cloud.png', 75, 47)
      cloud_small.x = _CW + 100
      cloud_small.y = math.random(-300, _CH - 200)
      cloud_small.alpha = 0.5
      transition.to(cloud_small, {time = 60000, x = -200, y = cloud_small.y + _CY/2})
    elseif (cloudSize ~= 1) then
      cloud_big = display.newImageRect(background, 'images/cloud.png', 150, 94)
      cloud_big.x = -100
      cloud_big.y = math.random(-300, _CH - 200)
      cloud_big.alpha = 0.9
      transition.to(cloud_big, {time = 40000, x = _CW + 200, y = cloud_big.y + _CY})
    end
  end
  if (cloud_big and cloud_big.x >= _CH + 200) then
    display.remove(cloud_big)
  elseif (cloud_small and cloud_small.x >= _CH + 200) then
    display.remove(cloud_small)
  end
end


function gemsTimer()
  gemTimer = timer.performWithDelay( 50, gemsEffect, 10)
end

function gemsEffect ()   --красивый вылет кристаллов в конце уровня
  if (math.random(2) == 1) then
    local gem = display.newImageRect(objects, 'images/gem.png',  32, 32)
    gem.x = -32
    gem.y = _CY - math.random(200)
    transition.to(gem, {transition = easing.inCubic, time = 250, y = uiGem.y, x = uiGem.x, rotation = 180, alpha = 0})
  elseif (math.random(2) ~= 1) then
    local gem = display.newImageRect(objects, 'images/gem.png',  32, 32)
    gem.x = _CW + 32
    gem.y = _CY - math.random(200)
    transition.to(gem, {transition = easing.inCubic, time = 250, y = uiGem.y, x = uiGem.x, rotation = 180, alpha = 0})
  end
end



function plusGemsTimer ()
  plusGems = timer.performWithDelay(100, plusGems, 10 )
end

function plusGems ()
  ui.alpha = 1
  save.sessionGems = save.sessionGems + 2
  uiGemText.text = save.sessionGems
end









function resetHero ()
  if (not hero) then
    hero = display.newSprite(objects, hero1_sheet, hero1_sequence)
    hero.x = _CX
    hero.y = _CH - 90
    physics.addBody(hero)
    hero:setFrame(1)


    hero.collision = sawCollision
    hero:addEventListener('collision')

  end
end





function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    physics.pause()  -- Temporarily pause the physics engine

    background = display.newGroup()
    sceneGroup:insert(background)

    foreground = display.newGroup()
    sceneGroup:insert(foreground)

    objects = display.newGroup()
    sceneGroup:insert(objects)


    ui = display.newGroup()
    sceneGroup:insert(ui)
    ui.alpha = 0

    hero = display.newSprite(objects, save.loadSkin())
    hero.x = _CX
    hero.y = _CH - 90
    physics.addBody(hero)
    hero:setFrame(1)
    hero.name = 'hero'

    hero.collision = sawCollision
    hero:addEventListener('collision')

    emitter = save.loadParticles()
    if emitter then
    emitter.x, emitter.y = hero.x, hero.y
    objects:insert(emitter)
    emitter:toBack()
    end



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


      back = display.newImageRect(background, 'images/background1.png', 450, 1250)
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

    --  danger = timer.performWithDelay(350 + math.random(500), sawSet, 0)


      --рука помощи
      helpHand = display.newImageRect(objects, 'images/hand.png', 96, 96)
      helpHand.x = 64
      helpHand.y = _CY
      helpHand.rotation = -30
      transition.to(helpHand, {transition = easing.inOutExpo, time = 2000, x = _CW - 64, rotation = 30, iterations = 0})

      resetHero()


      --надпись о том, как начать игру
      helpText = display.newText(objects, 'Swipe to start!', _CX, _CY - 100, 'GloriaHallelujah.ttf' or native.systemFont, 40)
      helpText:setFillColor(0,0,0)
      --helpText.rotation = -60

      uiGem = display.newImage(ui, 'images/gem.png', _CW - 160, 64)
      uiGem.width = 32
      uiGem.height = 32
      uiGemText = display.newText(ui, save.sessionGems, uiGem.x + 48, uiGem.y, 'GloriaHallelujah.ttf' or native.systemFont, 30)
      uiGemText:setFillColor(0,0,0)


      backgroundMusic = audio.loadStream('music/World1.ogg')


    end






-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
          physics.start()


    end
end



function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
          if(cloudTimer) then timer.cancel(cloudTimer) end
          if (danger) then timer.cancel(danger) end
          if (gemTimer) then timer.cancel(gemTimer) end
          display.remove(gem)
    elseif ( phase == "did" ) then
      composer.removeScene( "scripts.world1" )
      audio.stop(1)
      audio.dispose(backgroundMusic)
    end
end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )


return scene
