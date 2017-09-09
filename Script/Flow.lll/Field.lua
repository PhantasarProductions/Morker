--[[
  Field.lua
  Version: 17.09.09
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

function f.autoscroll()
   if EventRunning() then return end
   local gd = gamedata.data
   local tm = glob.map.TagMap[gd.layer]
   if not PLAYER then return end
   gd.camx = PLAYER.COORD.x - 400
   gd.camy = PLAYER.COORD.y - 250
   if tm.CAM_LEFT   and gd.camx<    tm.CAM_LEFT.COORD.x then gd.camx=tm.CAM_LEFT.COORD.x end
   if tm.CAM_TOP    and gd.camy<    tm.CAM_TOP.COORD.y  then gd.camy=tm.CAM_TOP.COORD.y end
   if tm.CAM_RIGHT  and gd.camx+800>tm.CAM_LEFT.COORD.x then gd.camx=tm.CAM_LEFT.COORD.x end
   if tm.CAM_BOTTOM and gd.camy+500>tm.CAM_TOP.COORD.y  then gd.camy=tm.CAM_TOP.COORD.y end
end

local function dprint(t,x,y,ac)
   local c = ac or {255,255,255}
   black()
   for ix=x-1,x+1 do for iy=y-1,y+1 do       
       love.graphics.print(t,ix,iy)
   end end
   Color(c[1],c[2],c[3])
   love.graphics.print(t,x,y)
end   
       

function f.draw()
   local gd = gamedata.data
   gd.camx = gd.camx or 0
   gd.camy = gd.camy or 0
   glob.map:draw(gd.layer,gd.camx,gd.camy)
   local a1,a2 = EventRunning()   
   UI.kids.Regular.visible = not a1
   --QText(sval(a1).."/"..sval(a2),5,5) -- debug info   
   if not a1 then f.autoscroll() end
   if f.show then
      white()
      local y = (f.my or 25)-20
      if y>UI.y-30 then y=UI.y-30 end
      dprint(f.show,(f.mx or 10)+10,y,{255,255,255})
   end
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
            scenario.LoadData('Maps/'..mapfile,"MAP",false)  
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

function f.SpawnPlayer(spot,xdata)
    local xd = {}
    if type(spot)=='string' then
       local exitspot = glob.map.TagMap[gamedata.data.layer][spot]
       if exitspot.DATA then xd.WIND = exitspot.DATA.WIND end
    end
    xd.WIND = xd.WIND or "South"
    xd.TEXTURE = "GFX/ACTORS/BUNDLED/KTHURA/"..xd.WIND:upper()..".PICBUNDLE/"
    xd.FRAME = 1   
    for k,v in pairs(xdata or {}) do xd[k]=v end
    PLAYER = kthura.Spawn(glob.map,gamedata.data.layer,spot,'PLAYER',xd)
end

function f.TurnPlayer(wind)
   if not PLAYER then return print("WARNING! No player to turn!") end
   PLAYER.WIND=wind
   PLAYER.TEXTURE = "GFX/ACTORS/BUNDLED/KTHURA/"..PLAYER.WIND:upper()..".PICBUNDLE/"
   print("Kthura turned "..wind)
   return true
end   

function f.ScrollTo(p1,p2,pwait)
   local tox,toy,wait
   if type(p1)=='number' then   
      tox,toy,wait=p1,(p2 or 0),pwait
   elseif type(p1)=='table' then
      tox=p1.x or p1.X or gamedata.data.camx or 0
      toy=p1.y or p1.Y or gamedata.data.camy or 0
      wait=p1.wait    
   end
   local ok
   repeat
     if gamedata.data.camx<tox then gamedata.data.camx=gamedata.data.camx+1 end
     if gamedata.data.camx>tox then gamedata.data.camx=gamedata.data.camx-1 end
     if gamedata.data.camy<toy then gamedata.data.camy=gamedata.data.camy+1 end
     if gamedata.data.camy>toy then gamedata.data.camy=gamedata.data.camy-1 end
     ok = gamedata.data.camy==toy and gamedata.data.camx==tox
     if not wait then return ok end
   until ok  
   -- The 'wait' is only a safety precaution, since it's a pretty useless thing in a callback situation.
   return ok -- Does this help?
end

function f.grabobj(arx,ary) 
   local rtag,rshow,robj
   local x=arx+gamedata.data.camx
   local y=ary+gamedata.data.camy   
   --print("Scanning for clickable objects ("..arx..","..ary..") >> ("..x..","..y..")")
   if UI:hover(arx,ary) then
      if UIKthura:hover(arx,ary) then
         rtag = "SYS:KTHURA"
         rshow = "Kthura"
      else
        if gamedata.data.inventorysorted then f.UpdateInventory() end
        for g in each(UISockets) do
            --print("Scanning: "..sval(g.socket).." "..sval(gamedata.data.inventorysorted[g.socket]).." hovering: "..sval(g:hover(arx,ary)))
            if g:hover(arx,ary) then
               local i = gamedata.data.inventorysorted[g.socket]
               if i then
                 rtag="INV:"..g.socket
                 rshow=i
               end -- if i
            end    -- if g:hover
        end -- for g      
      end -- if UI:hover
   else
     for o in each(glob.map.MapObjects[gamedata.data.layer]) do
       local gotit = false
       if o.KIND=='Obstacle' then
          local w = o.LoadedTexture.images[1]:getWidth()
          local h = o.LoadedTexture.images[1]:getHeight()
          gotit = x>o.COORD.x-(w/2) and x<o.COORD.x+(w/2) and y<o.COORD.y and y>o.COORD.y-h
          --print("Obstacle scan ("..o.COORD.x..","..o.COORD.y..") "..w.."x"..h.. " >> "..o.TAG)
       end
       if gotit then
          rtag  = o.TAG
          rshow = o.DATA.NPC
          robj  = o
       end
     end      
   end
   --print("= Returning tag: "..sval(rtag)) 
   --print("= Returning shw: "..sval(rshow))
   return rtag,rshow,robj
end

function f.mousemoved(x,y,dx,dy)
  local tag,obj
  tag,f.show,obj=f.grabobj(x,y)
  f.mx=x
  f.my=y
end
   
lunar.FIELD=f
return f
