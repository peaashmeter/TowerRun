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
local heroGroup
local gameStarted = 0
local gemsAmount = 0

local backgroundMusic

local spawnedAsteroids = {} --“олько дл€ уровн€ 3

display.setDefault( "textureWrapX", "repeat" )
display.setDefault( "textureWrapY", "repeat" )

local function gotoMenu()
    return composer.gotoScene('scripts.menu', {effect = "crossFade", time = 400})
end


local function nextScene ()
    gameEnded = 0
    gameStarted = 0
    return composer.gotoScene('scripts.world4', {effect = "crossFade", time = 400})
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
      timer.cancel( dangerTimer )
      audio.fadeOut( { channel=1, time=1000} )
      if emitter then
        display.remove(emitter)
      end
    elseif (leftRect.y >= 4950) then
      transition.to(hero, {transition = easing.inCubic, time = 3000, rotation = hero.rotation + 1080,
      width = hero.width*2, height = hero.height*2, y = hero.y - 1000, x = _CX, alpha = 0, onComplete = nextScene})


      transition.to(herolight, {transition = easing.inCubic, time = 3000,
      width = herolight.width*2, height = herolight.height*2, y = hero.y - 1000, x = _CX, alpha = 0})
      gemsTimer()
      plusGemsTimer()
      timer.cancel(dangerTimer)
    --  audio.fadeOut( { channel=1, time=1000} )
    if emitter then
      display.remove(emitter)
    end
      ui.alpha = 1
  end
end






local function startGame()
      gameEnded = 0
      transition.to(leftRect, {time = 40000, y = 5000, onComplete = endGame})
      transition.to(rightRect, {time = 40000, y = 5000})
      transition.to(back, {time = 40000, y = back.y + 400})
      transition.to(helpHand, {time = 500, alpha = 0, onComplete = helpGarbage})
      transition.to(helpText, {time = 500, alpha = 0})
      dangerTimers()
      clearTimers()
      audio.setVolume(1, { channel=1 } )
      audio.play(backgroundMusic, {channel = 1})
end




function rotateBack ()
  transition.to(back, {time = 60000, rotation = 360, iterations = 0})
end


function dropParts ()
  for i = 1,1 do
    local dieParticle = display.newImage(objects, save.loadHalf(), hero.x, hero.y)
    dieParticle.rotation = -30 + math.random(60)
    transition.to( dieParticle, {transition = easing.inSine, time = 1000 + math.random(1000), y = dieParticle.y + 1000, x = dieParticle.x - 400 + math.random(800)})
  end
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
       transition.to(herolight, {time = 100, x = 96})
       if emitter then
         transition.to(emitter, {time = 100, x = 96})
       end
       gameStarted = 1
       startGame()
       heroLeftCollide()
       hero.position = 'left'
      end
     if (gameStarted == 0 and event.x and startX and event.x > startX ) then
       transition.to(hero, {time = 100, x = _CW - 96})
       transition.to(herolight, {time = 100, x = _CW - 96})
       if emitter then
         transition.to(emitter, {time = 100, x = _CW - 96})
       end
       gameStarted = 1
       startGame()
       heroRightCollide()
       hero.position = 'right'
     end
     if (gameEnded ~= 1 and event.x > startX) then
       transition.to(hero, {time = 200, x = _CW - 96})
       transition.to(herolight, {time = 200, x = _CW - 96})
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
       transition.to(herolight, {time = 200, x = 96})
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



function heroCollision (self, event)
if (event.phase == 'began' and (event.other.name == 'asteroid')) then
      display.remove(hero)
      display.remove(herolight)
      hero:removeSelf()
      endGame()
    end
end


function gemsTimer()
  gemTimer = timer.performWithDelay( 50, gemsEffect, 10)
end

function gemsEffect ()   --красивый вылет кристаллов в конце уровн€
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
  save.sessionGems = save.sessionGems + 6
  uiGemText.text = save.sessionGems
end



function dangerTimers ()
  dangerTimer = timer.performWithDelay(1700, dangerGenerator,20)
end


function dangerGenerator ()

  local asteroid = display.newImage(objects, 'images/asteroid.png')
  local pos = math.random(1,5)

  if pos == 1 or pos == 2 then
    asteroid.x = -200
    asteroid.y = math.random(-250, -150)
    transition.to(asteroid, {time = math.random(1000,3000)+5000, y = _CH + 200, x = _CW + math.random(100,300), rotation = math.random(360, 720)})
  elseif pos == 3 then
    asteroid.x = _CX - 100 + math.random(200)
    asteroid.y = -200
    transition.to(asteroid, {time = math.random(1000,3000)+5000, y = _CH + 200, x = _CX - 50 + math.random(100), rotation = math.random(360,720)})
  elseif pos == 4 or pos == 5 then
    asteroid.x = _CW + 200
    asteroid.y = math.random(-250, -150)
    transition.to(asteroid, {time = math.random(1000,3000)+5000, y = _CH + 200, x = math.random(-300,-100), rotation = math.random(360,720)})
  end
  asteroid.name = 'asteroid'

  physics.addBody(asteroid, 'static', {radius = 58})
  asteroid.collision = heroCollision
  asteroid:addEventListener('collision')
  spawnedAsteroids[#spawnedAsteroids+1] = asteroid

end


function clearTimers ()
  clearTimer = timer.performWithDelay(1000, clearGenerator,0)
end

function clearGenerator ()
  local ast = spawnedAsteroids[#spawnedAsteroids]
  if ast and ast.y == _CH + 200 then
    display.remove(ast)
    ast = nil
  end
end






function scene:create( event )

math.randomseed( os.time() )
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    physics.pause()  -- Temporarily pause the physics engine

    background = display.newGroup()
    sceneGroup:insert(background)

    objects = display.newGroup()
    sceneGroup:insert(objects)

    foreground = display.newGroup()
    sceneGroup:insert(foreground)


    heroGroup = display.newGroup()
    sceneGroup:insert(heroGroup)


    ui = display.newGroup()
    sceneGroup:insert(ui)
    ui.alpha = 0

    hero = display.newSprite(heroGroup, save.loadSkin())
    hero.x = _CX
    hero.y = _CH - 90
    physics.addBody(hero)
    hero:setFrame(1)
    hero.name = 'hero'

    hero.collision = heroCollision
    hero:addEventListener('collision')


    herolight = display.newImage(heroGroup, 'images/light.png', hero.x, hero.y)
    herolight:toBack()

    emitter = save.loadParticles()
    if emitter then
    emitter.x, emitter.y = hero.x, hero.y
    heroGroup:insert(emitter)
    emitter:toBack()
    end



      leftRect = display.newRect(foreground, 32, -5000 + _CH, 64, 10000)
      local scaleFactorX = 64 / leftRect.width
      local scaleFactorY = 64 / leftRect.height

      leftRect.fill = {type = 'image', filename = 'images/block3.png'}

      leftRect.fill.scaleX = scaleFactorX
      leftRect.fill.scaleY = scaleFactorY


      rightRect = display.newRect(foreground, _CW - 32, -5000 + _CH, 64, 10000)
      local scaleFactorX = 64 / rightRect.width
      local scaleFactorY = 64 / rightRect.height

      rightRect.fill = {type = 'image', filename = 'images/block3.png'}

      rightRect.fill.scaleX = scaleFactorX
      rightRect.fill.scaleY = scaleFactorY


      back = display.newImageRect(background, 'images/background3.png', 2200, 2200)
      back.x = _CX
      back.y = _CY - 225
      back:addEventListener ('touch', moveHero)
      rotateBack ()

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
      helpHand = display.newImageRect(foreground, 'images/hand.png', 96, 96)
      helpHand.x = 64
      helpHand.y = _CY
      helpHand.rotation = -30
      transition.to(helpHand, {transition = easing.inOutExpo, time = 2000, x = _CW - 64, rotation = 30, iterations = 0})



      --надпись о том, как начать игру
      helpText = display.newText(foreground, 'Swipe to start!', _CX, _CY - 100, 'GloriaHallelujah.ttf' or native.systemFont, 40)
      helpText:setFillColor(1,1,1)
      --helpText.rotation = -60

      uiGem = display.newImage(ui, 'images/gem.png', _CW - 160, 64)
      uiGem.width = 32
      uiGem.height = 32
      uiGemText = display.newText(ui, save.sessionGems, uiGem.x + 48, uiGem.y, 'GloriaHallelujah.ttf' or native.systemFont, 30)
      uiGemText:setFillColor(1,1,1)


      backgroundMusic = audio.loadStream('music/World3.ogg')



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
          if (flameSideRandomizerTimer) then timer.cancel(flameSideRandomizerTimer) end
          if (spawnSmallSawsTimer) then timer.cancel(spawnSmallSawsTimer) end
          if (dangerTimer) then timer.cancel(dangerTimer) end
          if (gemTimer) then timer.cancel(gemTimer) end
          display.remove(gem)
    elseif ( phase == "did" ) then
      composer.removeScene( "scripts.world3" )
      audio.stop(1)
      audio.dispose(backgroundMusic)
    end
end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )


return scene
