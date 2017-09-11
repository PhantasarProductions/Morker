--[[
  Menu.lua
  Version: 17.09.11
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


local m = {}

local always = {kind='pivot',x=0,y=0}
local gameonly = {kind='pivot',x=0,y=0}
local mui = {kind='pivot',x=0,y=0,kids={always,gameonly}}
local energy = {kind='label',x=0,y=20,caption='',FR=40,FG=40,FB=40}
local chainback

local batstates ={
   unknown='Cannot determine power status.',
   battery='Not plugged in, running on a battery.',
   nobattery='Plugged in, no battery available.',
   charging='Plugged in, charging battery.',
   charged='Plugged in, battery is fully charged.'
}


always.kids = {
   {
       kind='picture',
       image='GFX/LOGOS/MORKER.PNG',
       hot='c',
       x=400,
       y=50,
       FR=255,FG=255,FB=255,
       IR=255,IG=255,IB=255
   },
   {   kind='label', x=0,y=0, caption='OS: '..love.system.getOS(), FR=40,FG=40,FB=40},
   energy,
}   

local score =  {  kind='label', x=0,y=40, caption="", FR=50,FG=0,FB=50 }
gameonly.kids = {
  score
}

lunamorica.update(mui)

function m.draw()
end

function m.update()
    local state, percent, seconds = love.system.getPowerInfo( )
    local e = ""
    --print(state, percent, seconds) -- debug
    if percent then 
       e = percent.."%"
    else
       e = "N/A"   
    end   
    e = e .. "   ".. (batstates[state] or "?")
    energy.caption='Energy: '..e
end

function m.gomenu(ingame,back)
   gameonly.visible=ingame
   always.visible=true
   chainback = back or 'FIELD'
   if ingame then
      score.caption = subs.SCORE.str()
   end   
   chain.go("MENU")
end

gomenu=m.gomenu

lunar.MENU = mui
return m
