--[[
  UserInterface.lua
  Version: 17.08.19
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

-- *import qgfx2

local pic_items = {}
 
luna.addgadget('socket',{
      init=function(g,c)
             print("Inventory socket #"..g.socket.." set onto ("..g.x..","..g.y..")") 
           end,
      draw=function(g)
         if not gamedata.data.inventorysorted then field.UpdateInventory() end
         Color(0,0,0,180)
         Rect(g.ax,g.ay,g.w,g.h)
         Color(255,255,255,255)
         local i = gamedata.data.inventorysorted[g.socket]
         if i then
           pic_items[i] = pic_items[i] or love.graphics.newImage("GFX/INVENTORY/"..i:upper()..".PNG") or love.graphics.newText("? "..i.." ?")
           love.graphics.draw(pic_items[i],g.ax,g.ay)
         end
      end
})

local Regular = { kind='pivot',x=0,y=0,visible=true,kids={
        {
          kind='picture',
          image='GFX/UserInterface/Kthura.png',
          y=50,
          x=10
        }
}}

local socket=0
for x=200,600,30 do for y=10,120,30 do
    socket = socket + 1
    local newsocket = { kind="$socket", x=x, y=y, w=25, h=25, socket=socket }
    Regular.kids[#Regular.kids+1] = newsocket
end end    

local Talk = { kind='pivot',x=0,y=0,visible=false,kids={ }}


local UI = {

       kind='picture',
       x=0,
       y=450,
       h=150,
       w=800,
       image='GFX/UserInterface/Plasma800.png',
       PR=255,PG=0,PB=255,
       kids = {
           Regular = Regular,
           Talk = Talk,
           Nothing = {kind='pivot'}
       }
}

luna.update(UI)


return UI
