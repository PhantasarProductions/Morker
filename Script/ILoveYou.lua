--[[
**********************************************
  
  ILoveYou.lua
  (c) Jeroen Broks, 2017, All Rights Reserved.
  
  This file contains material that is related 
  to a storyline that is which is strictly
  copyrighted to Jeroen Broks.
  
  This file may only be used in an unmodified
  form with an unmodified version of the 
  software this file belongs to.
  
  You may use this file for your study to see
  how I solved certain things in the creation
  of this project to see if you find valuable
  leads for the creation of your own.
  
  Mostly this file comes along with a project
  that is for most part released under an
  open source license and that means that if
  you use that code with this file removed
  from it, you can use it under that license.
  Please check out the other files to find out
  which license applies.
  This file comes 'as-is' and in no possible
  way the author can be held responsible of
  any form of damages that may occur due to 
  the usage of this file
  
  
 **********************************************
 
version: 17.08.23
]]

print("Morker - By Jeroen Broks")

-- Dependencies
-- *import chain_lunamorica
-- *import AnnaAndGameJolt
-- *import kthura
-- *import scenario

scen = scen or scenario 
luna = luna or lunamorica -- LAAAAAZY!

-- local imports
-- *import glob
-- *import EventChain
-- *import UserInterface
-- *import flow

UI=UserInterface  assert(UI,"General User Interface not loaded")
lunar.FIELD = UI


mkl.version("Morker - ILoveYou.lua","17.08.23")
mkl.lic    ("Morker - ILoveYou.lua","Phantasar Closed License")


function saveconfig()
   local saveconfig = serialize('local config',config).."\n\nreturn config\n\n"
   love.filesystem.write('config/config.lua',saveconfig)
end

function love.load()
   love.filesystem.createDirectory("config")
   love.filesystem.createDirectory("savegames")
   love.filesystem.createDirectory("swap")   
   if love.filesystem.isFile("config/config.lua") then config = j_love_import('config/config.lua') end
   config = config or { screen='full'}
   saveconfig() 
   chain.go(({[false]='NEWGAME',[true]='STARTSCREEN'})[love.filesystem.isFile("savegames/dir.lua")])
   for k,f in spairs(chain.x) do print("X-EVENT font for: "..k.." > "..type(f)) end -- Debug line
end

function love.quit()
   saveconfig()
end   
