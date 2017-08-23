--[[
  Field.lua
  Version: 17.08.23
  Copyright (C) 2017 Jeroen Petrus Broks
  
  ===========================
  This file is part of a project related to the Phantasar Chronicles or another
  series or saga which is property of Jeroen P. Broks.
  This means that it may contain references to a story-line plus characters
  which are property of Jeroen Broks. These references may only be distributed
  along with an unmodified version of the game. 
  
  As soon as you remove or replace ALL references to the storyline or character
  references, or any termology specifically set up for the Phantasar universe,
  or any other univers a story of Jeroen P. Broks is set up for,
  the restrictions of this file are removed and will automatically become
  zLib licensed (see below).
  
  Please note that doing so counts as a modification and must be marked as such
  in accordance to the zLib license.
  ===========================
  zLib license terms:
  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.
  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:
  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
]]
local f = {}
FIELD=f


local function MSE(self,tag) -- Map Event Start. Only used to turn the event table into a class
    assert(self[tag],errortag("events.start",{tag}," No event with that tag found"))
    StartEvent(self[tag])
end    

field=f

function f.updateinventory()
  gamedata.data.inventorysorted = {}
  for a,b in spairs(gamedata.data.inventory) do
      if b then gamedata.data.inventorysorted[#gamedata.data.inventorysorted+1]=a end
  end      
end
f.UpdateInventory = f.updateinventory

function f.draw()
   local gd = gamedata.data
   gd.camx = gd.camx or 0
   gd.camy = gd.camy or 0
   glob.map:draw(gd.layer,gd.camx,gd.camy)
   local a1,a2 = EventRunning()   
   QText(sval(a1).."/"..sval(a2),5,5)   
end

function f.LoadMap(mapfile)    
             print("Loading Map: "..mapfile)
             gamedata.data.map = mapfile:upper()
             glob.map = kthura.load("MAPS/"..upper(gamedata.data.map)) 
             print("Importing MapScript: "..mapfile..".lua")
             glob.mapscript = j_love_import("/SCRIPT/MAPS/"..gamedata.data.map..".LUA") or {}             
             local m = glob.mapscript
             ;(m.onLoad or Nada)()
             glob.mapcambound = {} 
             if not m.events then print("WARNING! Map script has no events") end
             m.events = m.events or {} -- crash prevention
             m.events.start = MSE
             map = glob.map
             for l,tm in spairs(map.TagMap) do
              print("- layer: "..l)
              for t,d in spairs(tm) do
                 print("  = tag "..t.." does contain a "..type(d))
                 for of,od in spairs(d) do
                     print("     = field "..of.." = "..sval(od))
                 end   
              end
            end   
end

function f.update(dt)
   if gamedata.data.mapcall then 
      print("Starting startcall event: "..gamedata.data.mapcall)
      glob.mapscript.events:start(gamedata.data.mapcall)
      gamedata.data.mapcall=nil
   end
end   

function f.CamPoint(d1,d2)
   local gd = gamedata.data   
   if type(d1)=='string' then 
      print(gamedata.data.layer..">"..d1)
      assert(map.TagMap[gamedata.data.layer][d1],errortag("CamPoint,",{d1,d2},"There is no object named `"..d1.."` in layer `"..gamedata.data.layer.."`"))
      gd.camx = map.TagMap[gamedata.data.layer][d1].COORD.x
      gd.camy = map.TagMap[gamedata.data.layer][d1].COORD.y
      print("Camera point set to object: "..d1)
   elseif type(d1)=='number' and type(d2)=='number' then
      gd.camx=d1
      gd.camy=d2
   else
      error(errortag("FIELD.CamPoint",{d1,d2},'Illegal CamPoint Request'))
   end      
end 

lunar.FIELD=f
return f
