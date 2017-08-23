--[[
  LogIn.lua
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
local lgn={}
lgn.dat = {

       {
          Check=function() return gamedata.config.Login.GameJolt.User and gamedata.config.Login.GameJolt.Token end,
          line="Logging in to Game Jolt",
          action=function()
          end
       },{       
          Check=function() return gamedata.config.Login.Anna.ID and gamedata.config.Login.Anna.secu end,
          line="Logging in to Anna",
          action=function()
          end
       },{
          Check=function() return true end,
          line="Loading the game",          
          action=function()
             -- print("Loading Map: "..gamedata.data.map)
             FIELD.LoadMap(gamedata.data.map) --glob.map = kthura.load("MAPS/"..upper(gamedata.data.map)) 
             chain.go("FIELD")
             --error("Sorry this is all we got now.") 
          end
       }
}

local act=1
local cntdn=10
local lin = "Starting the game\n"
local noted

function lgn.draw()
  if noted==1 then
     lin = lin .."= "..lgn.dat[act].line.."\n"
     noted=2
  end
  white()
  love.graphics.print(lin,0,0)
  cntdn = cntdn - 1
end

function lgn.update()
    if lgn.dat[act].Check() then
       noted=noted or 1       
       if cntdn<=0 then
          lgn.dat[act].action()
          cntdn=10
          act=act+1
          noted=nil
       end
    else
       act=act+1
    end    
end







return lgn
