-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
composer.recycleOnSceneChange = true

local save = require ('scripts.save')
save.writeData()

--save.writeData('remove')
audio.reserveChannels(1)
audio.setVolume(0.5, {channel = 1})

-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )

-- Seed the random number generator
math.randomseed( os.time() )

-- Go to the menu screen
composer.gotoScene( "scripts.menu")
