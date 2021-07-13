


local composer = require( "composer" )

local scene = composer.newScene()


local _CX = display.contentCenterX
local _CY = display.contentCenterY
local _CH = display.contentHeight
local _CW = display.contentWidth

--аудио
local backgroundMusic






local function play ()
  --composer.removeScene('scripts/menu')
  composer.gotoScene('scripts.world1')
end


local function shop()
  composer.gotoScene('scripts.shop', {effect = 'crossFade', time = 400})
end



function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

  local background = display.newImageRect(sceneGroup, 'images/menuBack.png', 1280, 1920)
  background.x = _CX
  background.y = _CY
  --local background2 = display.newImage(sceneGroup, 'images/menu2.png', _CX, _CY)
  --background2.alpha = 1

  ---transition.to( background2, { transition=easing.continuousLoop, time = 20000, iterations = 0, alpha = 0 } )
  local playSaw = display.newImageRect(sceneGroup, 'images/saw_big.png', 256, 256)

  local playButton = display.newImageRect(sceneGroup, 'images/play_button.png', 160, 160)
  playButton.x, playButton.y = _CX, _CY

  transition.to (playButton, { transition=easing.continuousLoop, time = 2000, iterations = 0, width = 170, height = 170})

  playButton:addEventListener('tap', play)
  playSaw.x, playSaw.y = playButton.x, playButton.y
  transition.to(playSaw, {time = 2000, rotation = playSaw.rotation + 360, iterations = 0})


  local shopButton = display.newImageRect(sceneGroup, 'images/shop_button.png', 120, 120)
  shopButton.x, shopButton.y = _CX, playButton.y + 200
  transition.to (shopButton, { transition=easing.continuousLoop, time = 2000, iterations = 0, width = 117, height = 117})

  local logo = display.newImageRect(sceneGroup, 'images/logo.png', 400, 148)
  logo.x = _CX
  logo.y = 150


  shopButton:addEventListener('tap', shop)
--версия
  local versionText = display.newText(sceneGroup, 'v0.83', 40, _CH-20, native.systemFont, 20)
  versionText:setFillColor(0,0,0)
--аудио
  backgroundMusic = audio.loadStream('music/Tower Climber.ogg')


end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
    audio.setVolume( 1, { channel=1 } )
    audio.play(backgroundMusic, {channel = 1})
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
