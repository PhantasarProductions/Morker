--[[
  quit.lua
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

-- *if ignore
local love = { event={quit=function() end}} -- fool outline
-- *fi

local backchain

-- Catch the quit event and lead to the QUIT flow
function love.quit()
    print('Quit request')
    if chain.currentname=='QUIT' then saveconfig() return end
    backchain=chain.currentname
    chain.go('QUIT')
    return true
end


local qui = {kind='pivot',x=0,y=0,kids={

      {kind='picture', fontsize=40,font="Fonts/Highway.ttf",image='text:Do you really want to quit',hot='c',x=400,y=100,FR=255,FG=0,FB=255},
      {kind='button',  fontsize=40,font="Fonts/Highway.ttf",caption='Yes',x=200,w=150,y=300,action=love.event.quit,FR=0,FG=255,FB=255,BR=127,BG=0,BB=127},
      {kind='button',  fontsize=40,font="Fonts/Highway.ttf",caption='No', x=450,w=150,y=300,action=function() chain.go(backchain) end,FR=0,FG=255,FB=255,BR=127,BG=0,BB=127}


}}

luna.update(qui)
lunar.QUIT = qui

return {draw = function() end}
