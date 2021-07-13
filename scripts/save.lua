local A = {}
local json = require "json"

local path = system.pathForFile('savefile.json', system.DocumentsDirectory)
--A.datafile = io.open(path, 'w')

local sheetOptions = {
  width = 64,
  height = 64,
  numFrames = 10
  }

local hero_sequence = {
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

local hero1_sheet = graphics.newImageSheet('images/hero1_strip.png', sheetOptions)
local hero2_sheet = graphics.newImageSheet('images/hero2_strip.png', sheetOptions)
local hero3_sheet = graphics.newImageSheet('images/hero3_strip.png', sheetOptions)
local hero4_sheet = graphics.newImageSheet('images/hero4_strip.png', sheetOptions)
local hero5_sheet = graphics.newImageSheet('images/hero5_strip.png', sheetOptions)
local hero6_sheet = graphics.newImageSheet('images/hero6_strip.png', sheetOptions)

A.sessionGems = 0


saveData = {
  gems = 0;
  skinid = 0;
  isid1 = 1;
  isid2 = 0;
  isid3 = 0;
  isid4 = 0;
  isid5 = 0;
  isid6 = 0
}







function A.loadData ()
  local savefile = io.open(path, 'r')
  if savefile then
    local contents = savefile:read( "*a" )
       io.close(savefile)
       loadedData = json.decode(contents)
       return loadedData
   end
end



function A.loadHalf()
  local half1 = 'images/hero1_half.png'
  local half2 = 'images/hero2_half.png'
  local half3 = 'images/hero3_half.png'
  local half4 = 'images/hero4_half.png'
  local half5 = 'images/hero5_half.png'
  local half6 = 'images/hero6_half.png'
  local savefile = A.loadData()
  if savefile.skinid == 1 then
    return half1
  elseif savefile.skinid == 2 then
    return half2
  elseif savefile.skinid == 3 then
    return half3
  elseif savefile.skinid == 4 then
    return half4
  elseif savefile.skinid == 5 then
    return half5
  elseif savefile.skinid == 6 then
    return half6
  end
end


function A.loadSkin()
  local savefile = A.loadData()
  if savefile.skinid == 1 then
    return hero1_sheet, hero_sequence

  elseif savefile.skinid == 2 then
    return hero2_sheet, hero_sequence

  elseif savefile.skinid == 3 then
    return hero3_sheet, hero_sequence

  elseif savefile.skinid == 4 then
    return hero4_sheet, hero_sequence

  elseif savefile.skinid == 5 then
    return hero5_sheet, hero_sequence

  elseif savefile.skinid == 6 then
    return hero6_sheet, hero_sequence

  else return hero1_sheet, hero_sequence
  end

end


function A.loadParticles()
  local savefile = A.loadData()
  if savefile.skinid == 4 then
    local filePath = system.pathForFile('scripts/particle4_down.json')
    local f = io.open( filePath, "r" )
    local emitterData = f:read( "*a" )
    f:close()

    -- Decode the string
    local emitterParams = json.decode(emitterData)
    print(emitterParams)

    emitter = display.newEmitter(emitterParams)
  return emitter

  elseif savefile.skinid == 5 then
    local filePath = system.pathForFile('scripts/particle5_down.json')
    local f = io.open( filePath, "r" )
    local emitterData = f:read( "*a" )
    f:close()

    local emitterParams = json.decode(emitterData)
    print(emitterParams)
    
    emitter = display.newEmitter(emitterParams)
    return emitter

  elseif savefile.skinid == 6 then
    local filePath = system.pathForFile('scripts/particle6_down.json')
    local f = io.open( filePath, "r" )
    local emitterData = f:read( "*a" )
    f:close()

    -- Decode the string
    local emitterParams = json.decode(emitterData)
    print(emitterParams)

    emitter = display.newEmitter(emitterParams)
  return emitter
  else return nil
  end
end

function A.checkSkin(num)
  local savefile = A.loadData()
  if savefile.isid1 == 1 and num == 1 then
    return true

  elseif savefile.isid2 == 1 and num == 2 then
    return true

  elseif savefile.isid3 == 1 and num == 3 then
    return true

  elseif savefile.isid4 == 1 and num == 4 then
    return true

  elseif savefile.isid5 == 1 and num == 5 then
    return true

  elseif savefile.isid6 == 1 and num == 6 then
    return true

  else
    savefile.isid1 = 1
    return false
  end

end


function A.writeData (mode, num)
  local data = A.loadData()
  local savefile = io.open(path, 'w')
  --saveData.gems = saveData.gems + A.sessionGems
  if not mode then
    if data and data.skinid then
      tonumber(data.gems)
      saveData.gems = saveData.gems + data.gems + A.sessionGems
      saveData.skinid = data.skinid
      saveData.isid1 = data.isid1
      saveData.isid2 = data.isid2
      saveData.isid3 = data.isid3
      saveData.isid4 = data.isid4
      saveData.isid5 = data.isid5
      saveData.isid6 = data.isid6
  --  print(saveData.skinid)
    else
      saveData.gems = saveData.gems + A.sessionGems
      saveData.skinid = 1
      saveData.isid1 = 1
      saveData.isid2 = 0
      saveData.isid3 = 0
      saveData.isid4 = 0
      saveData.isid5 = 0
      saveData.isid6 = 0
    end
  elseif mode == 1 then
    tonumber(data.gems)
    saveData.gems = data.gems
    saveData.skinid = num
    saveData.isid1 = data.isid1
    saveData.isid2 = data.isid2
    saveData.isid3 = data.isid3
    saveData.isid4 = data.isid4
    saveData.isid5 = data.isid5
    saveData.isid6 = data.isid6

  elseif mode == 2 then
    tonumber(data.gems)
    saveData.gems = data.gems

    if num == 1 then
      saveData.isid1 = 1
      elseif num == 2 then
        if saveData.isid2 ~=1 and data.gems - 300 >= 0 then
        saveData.isid2 = 1
        saveData.gems = data.gems - 300
        saveData.skinid = num
      end
      elseif num == 3 then
        if saveData.isid3 ~=1 and data.gems - 300 >= 0 then
        saveData.isid3 = 1
        saveData.gems = data.gems - 300
        saveData.skinid = num
        end
      elseif num == 4 then
        if saveData.isid4 ~=1 and data.gems - 1000 >= 0 then
        saveData.isid4 = 1
        saveData.gems = data.gems - 1000
        saveData.skinid = num
        end
      elseif num == 5 then
        if saveData.isid5 ~=1 and data.gems - 1000 >= 0 then
        saveData.isid5 = 1
        saveData.gems = data.gems - 1000
        saveData.skinid = num
        end
      elseif num == 6 then
        if saveData.isid6 ~=1 and data.gems - 1000 >= 0 then
        saveData.isid6 = 1
        saveData.gems = data.gems - 1000
        saveData.skinid = num
        end
    end
  elseif mode == 'remove' then
    tonumber(data.gems)
    saveData.gems = data.gems
      saveData.skinid = 1
      saveData.isid1 = 1
      saveData.isid2 = 0
      saveData.isid3 = 0
      saveData.isid4 = 0
      saveData.isid5 = 0
      saveData.isid6 = 0
  end
  savefile:write(json.encode(saveData))
  A.sessionGems = 0
  saveData.gems = 0
  io.close(savefile)
end

function A.generateData()
  local data = A.loadData()
  local savefile = io.open(path, 'w')
  savefile:write(json.encode(saveData))
end

return A
