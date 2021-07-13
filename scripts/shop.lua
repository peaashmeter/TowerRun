
local composer = require( "composer" )
local save = require ('scripts.save')
local json = require ("json")



local scene = composer.newScene()

local _CX = display.contentCenterX
local _CY = display.contentCenterY
local _CH = display.contentHeight
local _CW = display.contentWidth


local data = save.loadData()


local icons

local backgroundMusic




local function goback()
  composer.gotoScene('scripts.menu', {effect = 'crossFade', time = 400})
end


local function chooseHero1 ()
  if save.checkSkin(1) then
  hero2_icon.strokeWidth = 0
  hero3_icon.strokeWidth = 0
  hero1_icon.strokeWidth = 5
  hero4_icon.strokeWidth = 0
  hero5_icon.strokeWidth = 0
  hero6_icon.strokeWidth = 0
  save.writeData (1, 1)
end
end


local function chooseHero2 ()
  if save.checkSkin(2) then
  hero2_icon.strokeWidth = 5
  hero3_icon.strokeWidth = 0
  hero1_icon.strokeWidth = 0
  hero4_icon.strokeWidth = 0
  hero5_icon.strokeWidth = 0
  hero6_icon.strokeWidth = 0
  save.writeData (1, 2)
end
end


local function chooseHero3 ()
  if save.checkSkin(3) then
  hero2_icon.strokeWidth = 0
  hero3_icon.strokeWidth = 5
  hero1_icon.strokeWidth = 0
  hero4_icon.strokeWidth = 0
  hero5_icon.strokeWidth = 0
  hero6_icon.strokeWidth = 0
  save.writeData (1, 3)
end
end

local function chooseHero4 ()
  if save.checkSkin(4) then
  hero2_icon.strokeWidth = 0
  hero3_icon.strokeWidth = 0
  hero1_icon.strokeWidth = 0
  hero4_icon.strokeWidth = 5
  hero5_icon.strokeWidth = 0
  hero6_icon.strokeWidth = 0
  save.writeData (1, 4)
end
end

local function chooseHero5 ()
  if save.checkSkin(5) then
  hero2_icon.strokeWidth = 0
  hero3_icon.strokeWidth = 0
  hero1_icon.strokeWidth = 0
  hero4_icon.strokeWidth = 0
  hero5_icon.strokeWidth = 5
  hero6_icon.strokeWidth = 0

  save.writeData (1, 5)
end
end

local function chooseHero6 ()
  if save.checkSkin(6) then
  hero2_icon.strokeWidth = 0
  hero3_icon.strokeWidth = 0
  hero1_icon.strokeWidth = 0
  hero4_icon.strokeWidth = 0
  hero5_icon.strokeWidth = 0
  hero6_icon.strokeWidth = 5

  save.writeData (1, 6)
end
end

local function buyHero2 ()
  save.writeData(2,2)
  data = save.loadData()
  gemsAmount.text = data.gems
  chooseHero2 ()
  displayPrices(1)
end


local function buyHero3 ()
  save.writeData(2,3)
  data = save.loadData()
  gemsAmount.text = data.gems
  chooseHero3 ()
  displayPrices(1)
end

local function buyHero4 ()
  save.writeData(2,4)
  data = save.loadData()
  gemsAmount.text = data.gems
  chooseHero4 ()
  displayPrices(1)
end

local function buyHero5 ()
  save.writeData(2,5)
  data = save.loadData()
  gemsAmount.text = data.gems
  chooseHero5 ()
  displayPrices(1)
end

local function buyHero6 ()
  save.writeData(2,6)
  data = save.loadData()
  gemsAmount.text = data.gems
  chooseHero6 ()
  displayPrices(1)
end

local function resetData ()
  save.writeData('remove')
  chooseHero1 ()
  displayPrices()
end




function onLoadChoose ()
  local data = save.loadData()
  if data.skinid == 1 then
    chooseHero1()
  elseif data.skinid == 2 then
    chooseHero2()
  elseif data.skinid == 3 then
    chooseHero3()
  elseif data.skinid == 4 then
    chooseHero4()
  elseif data.skinid == 5 then
    chooseHero5()
  elseif data.skinid == 6 then
    chooseHero6()
  else
    resetData ()
  end
end



function displayPrices(mode)
  if mode == nil then
  local data = save.loadData()
  price1d = display.newImageRect(icons, 'images/gem.png', 16,16)
  price1d.x, price1d.y = hero1_button.x - 32, hero1_button.y
  price1t = display.newText(icons, '300', hero1_button.x, hero1_button.y, 'GloriaHallelujah.ttf' or native.systemFont, 20)


  price2d = display.newImageRect(icons, 'images/gem.png', 16,16)
  price2d.x, price2d.y = hero2_button.x - 32, hero2_button.y
  price2t = display.newText(icons, '300', hero2_button.x, hero2_button.y, 'GloriaHallelujah.ttf' or native.systemFont, 20)

  price3d = display.newImageRect(icons, 'images/gem.png', 16,16)
  price3d.x, price3d.y = hero3_button.x - 32, hero3_button.y
  price3t = display.newText(icons, '300', hero3_button.x, hero3_button.y, 'GloriaHallelujah.ttf' or native.systemFont, 20)

  price4d = display.newImageRect(icons, 'images/gem.png', 16,16)
  price4d.x, price4d.y = hero4_button.x - 32, hero4_button.y
  price4t = display.newText(icons, '1000', hero4_button.x, hero4_button.y, 'GloriaHallelujah.ttf' or native.systemFont, 20)

  price5d = display.newImageRect(icons, 'images/gem.png', 16,16)
  price5d.x, price5d.y = hero5_button.x - 32, hero5_button.y
  price5t = display.newText(icons, '1000', hero5_button.x, hero5_button.y, 'GloriaHallelujah.ttf' or native.systemFont, 20)

  price6d = display.newImageRect(icons, 'images/gem.png', 16,16)
  price6d.x, price6d.y = hero6_button.x - 32, hero6_button.y
  price6t = display.newText(icons, '1000', hero6_button.x, hero6_button.y, 'GloriaHallelujah.ttf' or native.systemFont, 20)
--    print (data.isid2)
  if data.isid1 == 1 then
    display.remove(price1d)
    display.remove(price1t)
  end
  if data.isid2 == 1 then
    display.remove(price2d)
    display.remove(price2t)
  end
  if data.isid3 == 1 then
    display.remove(price3d)
    display.remove(price3t)
  end
  if data.isid4 == 1 then
    display.remove(price4d)
    display.remove(price4t)
  end
  if data.isid5 == 1 then
    display.remove(price5d)
    display.remove(price5t)
  end
  if data.isid6 == 1 then
    display.remove(price6d)
    display.remove(price6t)
  end
  elseif mode then
    local data = save.loadData()
    if data.isid1 == 1 then
      display.remove(price1d)
      display.remove(price1t)
    end
    if data.isid2 == 1 then
      display.remove(price2d)
      display.remove(price2t)
    end
    if data.isid3 == 1 then
      display.remove(price3d)
      display.remove(price3t)
    end
    if data.isid4 == 1 then
      display.remove(price4d)
      display.remove(price4t)
    end
    if data.isid5 == 1 then
      display.remove(price5d)
      display.remove(price5t)
    end
    if data.isid6 == 1 then
      display.remove(price6d)
      display.remove(price6t)
    end
end
end



-- create()
function scene:create( event )


	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
  background = display.newGroup()
  sceneGroup:insert(background)

  ui = display.newGroup()
  sceneGroup:insert(ui)


  icons = display.newGroup()
  sceneGroup:insert(icons)



  local back = display.newImage(background, 'images/menuBack.png', _CX, _CY)
  --local forehills = display.newImageRect(background, 'images/shop_fore.png', 450, 508)
  --forehills.x = _CX
  --forehills.y = _CH - 204
  --forehills:setFillColor(0.5,0.5,0.5)


  gemsAmount = display.newText(ui, data.gems, _CW - 48, 48, 'GloriaHallelujah.ttf' or native.systemFont, 40)
  gemsAmount:setFillColor(0,0,0)





  local gemIcon = display.newImage(ui, 'images/gem.png', gemsAmount.x - 80, gemsAmount.y)

  local backButton = display.newImageRect(ui, 'images/back_button.png', 80, 80)
  backButton.x = 70
  backButton.y = gemsAmount.y

  backButton:addEventListener('tap', goback)



  hero1_icon = display.newImage(icons, 'images/hero1.png', 75, 256)
  hero1_icon:setStrokeColor(0,1,0)
  hero1_icon:addEventListener('tap', chooseHero1)

  hero1_button = display.newImageRect(icons, 'images/priceplace.png', 100, 29)
  hero1_button.x = hero1_icon.x
  hero1_button.y = hero1_icon.y + 50


  hero2_icon = display.newImage(icons, 'images/hero2.png', 225, 256)
  hero2_icon:setStrokeColor(0,1,0)
  hero2_icon:addEventListener('tap', chooseHero2)


  hero2_button = display.newImageRect(icons, 'images/priceplace.png', 100, 29)
  hero2_button.x = hero2_icon.x
  hero2_button.y = hero2_icon.y + 50
  hero2_button:addEventListener('tap', buyHero2)


  hero3_icon = display.newImage(icons, 'images/hero3.png', 375, 256)
  hero3_icon:setStrokeColor(0,1,0)
  hero3_icon:addEventListener('tap', chooseHero3)

  hero3_button = display.newImageRect(icons, 'images/priceplace.png', 100, 29)
  hero3_button.x = hero3_icon.x
  hero3_button.y = hero3_icon.y + 50
  hero3_button:addEventListener('tap', buyHero3)

  hero4_icon = display.newImage(icons, 'images/hero4.png', 75, 384)
  hero4_icon:setStrokeColor(0,1,0)
  hero4_icon:addEventListener('tap', chooseHero4)

  hero4_button = display.newImageRect(icons, 'images/priceplace.png', 100, 29)
  hero4_button.x = hero4_icon.x
  hero4_button.y = hero4_icon.y + 50
  hero4_button:addEventListener('tap', buyHero4)

  hero5_icon = display.newImage(icons, 'images/hero5.png', 225, 384)
  hero5_icon:setStrokeColor(0,1,0)
  hero5_icon:addEventListener('tap', chooseHero5)

  hero5_button = display.newImageRect(icons, 'images/priceplace.png', 100, 29)
  hero5_button.x = hero5_icon.x
  hero5_button.y = hero5_icon.y + 50
  hero5_button:addEventListener('tap', buyHero5)

  hero6_icon = display.newImage(icons, 'images/hero6.png', 375, 384)
  hero6_icon:setStrokeColor(0,1,0)
  hero6_icon:addEventListener('tap', chooseHero6)

  hero6_button = display.newImageRect(icons, 'images/priceplace.png', 100, 29)
  hero6_button.x = hero6_icon.x
  hero6_button.y = hero6_icon.y + 50
  hero6_button:addEventListener('tap', buyHero6)

  --local reset_button = display.newRect(icons, _CX, _CY + 100, 200,100)
  --reset_button:addEventListener('tap', resetData)

  --local reset_test = display.newText(icons, 'Reset button', reset_button.x, reset_button.y, 'GloriaHallelujah.ttf' or native.systemFont, 25)
--  reset_test:setFillColor(0,0,0)

onLoadChoose()
displayPrices()

--emitter 4
local filePath = system.pathForFile('scripts/hero4_emitter.json')
local f = io.open( filePath, "r" )
local emitterData = f:read( "*a" )
f:close()

-- Decode the string
local emitterParams = json.decode(emitterData)
print(emitterParams)
-- Create the emitter
hero4_emitter = display.newEmitter(emitterParams)
hero4_emitter.x = hero4_icon.x
hero4_emitter.y = hero4_icon.y

icons:insert(hero4_emitter)
hero4_emitter:toBack()

--emitter5

filePath = system.pathForFile('scripts/particle5.json')
f = io.open(filePath, "r" )
emitterData = f:read( "*a" )
f:close()

-- Decode the string
emitterParams = json.decode(emitterData)
print(emitterParams)
-- Create the emitter
hero5_emitter = display.newEmitter(emitterParams)
hero5_emitter.x = hero5_icon.x
hero5_emitter.y = hero5_icon.y

icons:insert(hero5_emitter)
hero5_emitter:toBack()

--emitter6
filePath = system.pathForFile('scripts/particle6.json')
f = io.open(filePath, "r" )
emitterData = f:read( "*a" )
f:close()

-- Decode the string
emitterParams = json.decode(emitterData)
print(emitterParams)
-- Create the emitter
hero6_emitter = display.newEmitter(emitterParams)
hero6_emitter.x = hero6_icon.x
hero6_emitter.y = hero6_icon.y

icons:insert(hero6_emitter)
hero6_emitter:toBack()


--аудио
  backgroundMusic = audio.loadStream('music/shop_loop.ogg')

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
    audio.setVolume( 0.75, { channel=1 } )
    audio.play(backgroundMusic, {channel = 1, loops = -1})
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
    audio.fade({channel=1, time=500})
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
    audio.stop(1)
    audio.dispose(backgroundMusic)
    composer.removeScene('shop')
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
