local composer = require( "composer" )
local save = require ('scripts.save')
local json = require ("json")


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


local function gotoMenu()
  return composer.gotoScene('scripts.menu', {effect = "crossFade", time = 400})
end

local function nextScene ()
  gameEnded = 0
  gameStarted = 0
  local randnum = math.random(1,3)
  if randnum == 1 then
    return composer.gotoScene('scripts.world2', {effect = "crossFade", time = 400})
  elseif randnum == 2 then
    return composer.gotoScene('scripts.world3', {effect = "crossFade", time = 400})
  elseif randnum == 3 then
    return composer.gotoScene('scripts.world1', {effect = "crossFade", time = 400})
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
      audio.fadeOut({ channel=1, time=1000})
      timer.cancel(dangerTimer)
      if emitter then
        display.remove(heroemitter)
      end
    elseif (leftRect.y >= 4950) then
      transition.to(hero, {transition = easing.inCubic, time = 3000, rotation = hero.rotation + 1080,
      width = hero.width*2, height = hero.height*2, y = hero.y - 1000, x = _CX, alpha = 0, onComplete = nextScene}) --переход в меню (временно)
      gemsTimer()
      plusGemsTimer()
      ui.alpha = 1
      audio.fadeOut( { channel=1, time=2000} )
      timer.cancel(dangerTimer)
      if emitter then
        display.remove(heroemitter)
      end
  end
end


local function startGame()
      gameEnded = 0
      transition.to(leftRect, {time = 60000, y = 5000, onComplete = endGame})
      transition.to(rightRect, {time = 60000, y = 5000})
      --transition.to(back, {time = 60000, y = back.y + 400})
      transition.to(helpHand, {time = 500, alpha = 0, onComplete = helpGarbage})
      transition.to(helpText, {time = 500, alpha = 0})
      speedUp = timer.performWithDelay(1000, dangerSpeedTimer, 0)
      dangerTimers()
      emitter:start()
      audio.setVolume( 1, { channel=1 } )
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
         transition.to(heroemitter, {time = 100, x = 96})
       end
       gameStarted = 1
       startGame()
       --dangerTimers()
       heroLeftCollide()
       hero.position = 'left'
      end
     if (gameStarted == 0 and event.x and startX and event.x > startX) then
       transition.to(hero, {time = 100, x = _CW - 96})
       if emitter then
         transition.to(heroemitter, {time = 100, x = _CW - 96})
       end
       gameStarted = 1
       startGame()
       --dangerTimers()
       heroRightCollide()
       hero.position = 'right'
     end
     if (gameEnded ~= 1 and event.x > startX) then
       transition.to(hero, {time = 200, x = _CW - 96})
       if emitter then
         transition.to(heroemitter, {time = 200, x = _CW - 96})
       end
       if (hero.position ~= 'right') then
         heroRightCollide()
         hero.position = 'right'
       end
     end
     if (gameEnded ~= 1 and event.x < startX) then
       if emitter then
         transition.to(heroemitter, {time = 200, x = 96})
       end
       transition.to(hero, {time = 200, x = 96})
       if (hero.position ~='left') then
         heroLeftCollide()
         hero.position = 'left'
       end
     end
   end
   return true
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
  save.sessionGems = save.sessionGems + 10
  uiGemText.text = save.sessionGems
end

function heroCollision (self, event)
  if (event.phase == 'began' and (event.other.name == 'saw_black')) then
      display.remove(hero)
      display.remove(herolight)
      hero:removeSelf()
      endGame()
  end
end

function spawnSaw ()
  local mode = math.random(1,2)
  if mode == 1 then
    saw_black = display.newImage(objects, 'images/saw_black.png')
    saw_black.x, saw_black.y = -200, _CY
    transition.to(saw_black, {transition = easing.continuousLoop, time = 4000, rotation = 720, x = _CW + 200, y = _CH - 64})
  elseif mode == 2 then
    saw_black = display.newImage(objects, 'images/saw_black.png')
    saw_black.x, saw_black.y = _CW+200, _CY
    transition.to(saw_black, {transition = easing.continuousLoop, time = 4000, rotation = 720, x = -200, y = _CH - 64})
  end
  if saw_black then
    saw_black.name = 'saw_black'
    physics.addBody(saw_black, 'static', {radius = 64})
    saw_black.collision = heroCollision
    saw_black:addEventListener('collision')
  end
end

function spawnSawDown ()
  local mode = math.random(1,2)
  if mode == 1 then
    saw_black = display.newImage(objects, 'images/saw_black.png')
    saw_black.x, saw_black.y = 64, -200
    transition.to(saw_black, {transition = easing.continuousLoop, time = 8000, rotation = 1440, y = _CH + 200})
  elseif mode == 2 then
    saw_black = display.newImage(objects, 'images/saw_black.png')
    saw_black.x, saw_black.y = _CW - 64, -200
    transition.to(saw_black, {transition = easing.continuousLoop, time = 8000, rotation = 1440, y = _CH + 200})
  end
  if saw_black then
    saw_black.name = 'saw_black'
    physics.addBody(saw_black, 'static', {radius = 64})
    saw_black.collision = heroCollision
    saw_black:addEventListener('collision')
  end
end

function dangerTimers()
  dangerTimer = timer.performWithDelay(3000, dangerGenerator, 0)
end

function dangerGenerator()
  local mode = math.random(1,3)
  if mode == 1 or mode == 2 then
    spawnSaw()
  elseif mode == 3 then
    spawnSawDown()
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

    heroGroup = display.newGroup()
    sceneGroup:insert(heroGroup)

    foreground = display.newGroup()
    sceneGroup:insert(foreground)




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

    heroemitter = save.loadParticles()
    if heroemitter then
    heroemitter.x, emitter.y = hero.x, hero.y
    heroGroup:insert(heroemitter)
    heroemitter:toBack()
    end




      leftRect = display.newRect(foreground, 32, -5000 + _CH, 64, 10000)
      local scaleFactorX = 64 / leftRect.width
      local scaleFactorY = 64 / leftRect.height

      leftRect.fill = {type = 'image', filename = 'images/block4.png'}

      leftRect.fill.scaleX = scaleFactorX
      leftRect.fill.scaleY = scaleFactorY


      rightRect = display.newRect(foreground, _CW - 32, -5000 + _CH, 64, 10000)
      local scaleFactorX = 64 / rightRect.width
      local scaleFactorY = 64 / rightRect.height

      rightRect.fill = {type = 'image', filename = 'images/block4.png'}

      rightRect.fill.scaleX = scaleFactorX
      rightRect.fill.scaleY = scaleFactorY


      local filePath = system.pathForFile('scripts/particle_texture.json')
      local f = io.open( filePath, "r" )
      local emitterData = f:read( "*a" )
      f:close()

      -- Decode the string
      local emitterParams = json.decode(emitterData)
      print(emitterParams)
      -- Create the emitter
      emitter = display.newEmitter(emitterParams)
      emitter.x = display.contentCenterX
      emitter.y = display.contentCenterY
      emitter:pause()

            foreback = display.newImageRect(foreground, 'images/background4.png', 720, 1280)
            foreback.x = _CX
            foreback.y = _CY
            foreback:addEventListener ('touch', moveHero)


      --back = display.newImageRect(background, 'images/background3.png', 720, 1280)
      back = display.newRect(background, _CX, _CY, _CW, _CH)
      back:setFillColor(0.8,0.9,0.9)
      back.x = _CX
      back.y = _CY
      back:addEventListener ('touch', moveHero)


        --local edgeGradientDown = display.newRect(foreground, _CX, _CH - 32, 450, 64)
      --edgeGradientDown.fill = {
        --type = "gradient",
        --color1 = { 0, 0, 0, 0},
        --color2 = {0, 0, 0, 1},
        --direction = "down"
      --}

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



      backmask = graphics.newMask('images/backmask.png')
      foreback:setMask(backmask)

      backgroundMusic = audio.loadStream('music/World4.ogg')


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
          emitter:removeSelf()
    elseif ( phase == "did" ) then
      composer.removeScene( "scripts.world4" )
      audio.stop(1)
      audio.dispose(backgroundMusic)
    end
end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )


return scene
