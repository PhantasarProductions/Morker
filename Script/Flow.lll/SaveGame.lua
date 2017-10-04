--[[
  SaveGame.lua
  Version: 17.10.04
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
local s = { dir = {} }

luna.addgadget('sgheader',{

      init = function(g,c)
          g.heads={}
          g.myfont=love.graphics.newFont('FONTS/GERMANIA.OTF',30)
          if not g.myfont then print("WARNING! Font not properly loaded for header!") end
          --love.graphics.setFont(g.myfont)
          for k in each({'Save','Restore','Delete'}) do 
              g.heads[k] = love.graphics.newText(g.myfont,k.." game")
               
          end
          g.heads.Load=g.heads.Restore    
          g.visible=true      
      end,
      draw = function(g)
         local img = g.heads[s.doing or 'Save'] 
         if not img then print("NO HEADER!") end
         --print(s.doing or 'Save') -- debug
         --print(g.x,g.y) -- debug
         color(25,18,0,255)
         love.graphics.draw(img,g.x+5,g.y+5,0,1,1,img:getWidth()/2,0)
         color(255,180,0,255)
         love.graphics.draw(img,g.x,g.y,0,1,1,img:getWidth()/2,0)
      end
})

local sgui = {
     kind='pivot',x=0,y=0,kids={
               header = {x=400,y=30,kind='$sgheader'},
               cancel = {x=100,y=550,w=600,kind='button',FR=0,FG=255,FB=255,BG=255,BG=0,BB=0,caption='Cancel',action=function(g) gomenu(menuingame) end}
     }

}

s.gui = sgui.kids
s.sgg = {}

local function entrybutton(g) end

local id
for i=100,500,50 do
   id = (id or 0) + 1
   local newgadget = {x=100,y=i,w=600,kind='button',caption=" Not Yet Defined ",FR=0,FG=255,FB=255,BR=127,BG=0,BB=127,id=id,action=entrybutton}
   s.gui['but'..id] = newgadget
   s.sgg[id] = newgadget
   print('Button #'..id.." created")
end
luna.update(sgui)

function gosave(d)
    s.doing = d
    chain.go('SAVEGAME')
    if not love.filesystem.isDirectory("SaveGame") then love.filesystem.createDirectory("SaveGame") end
    if not love.filesystem.isFile("SaveGame/Dir.lua") then s.dir={} else s.dir= j_love_import("SaveGame/Dir.lua",true) end
    for i,g in ipairs(s.sgg) do
        --local i=g.id
        local n=s.dir[i]
        g.caption=n or "< EMPTY SLOT >"
        g.acaption=nil
        g.visible= (d=='Save') or n~=nil
        g:lf_init()
        print(i.."> "..g.acaption)
    end    
    luna.update(sgui)
end

s.gosave = gosave


lunar.SAVEGAME = sgui
return s
