--[[
  EventChain.lua
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


-- *import lunamorica

--[[


    Love2D is a call-back based programming tool.
    That sounds pretty nice and cool for action based games, but for point-and-click adventures, it's actually a nightmare.
    After all the characters need to say their lines and the system has to wait for the lines to be said to get the next thing done.
    
    Like:
    - Use axe on tree
    - "You really want me to cut down the tree?"
    - "Ok"
    - Hero cutting down tree
    - Tree falling
    - Killing spy that was watching you
    - Scoring points
    - "Wow! That worked better than I thought"
    
    A callback engine such as Love2D could never do that, or at least not in a regular setting.
    So this engine will provide a special gadget which can make Love2D wait without spooking up its callback nature...
    At least, that is the idea.
    
    
    All numbered things will be taken as event commands.
    the "skippable" field will allow the player to skip the entire event (will not work on touchscreen, sorry).
    the "nextevent" field will allow you as developer to chain to the next event. For skippable events this can help to make sure the game is in the right setting.
    the "skipevent" field will only be executed if the player skips.
    
    
    

]]

-- *define chat

local function chat(a)
   -- *if chat
   print("eventchain: "..a)
   -- *fi
end   

local eventchain = {}

local function ec_exe(e)
   local w
   assert(eventchain,"Eventchain definition error")
   if not eventchain.running then return end
   local ce = eventchain[eventchain.running]
   if not ce then 
      -- likely the event has ended
      eventchain.running = nil 
      return
   end
   if e~=(ce.evt or 'update') then return end
   if type(ce.func)=='string' then
      chat((e or 'update').." string func")
      local ok,mychunk = pcall(loadstring,ce.func) 
      ok = ok or assert(ok,"Event string compile error\n"..mychunk)
      ok,w = pcall(mychunk)
      ok = ok or assert(ok,"Event string runtime error:\n"..w)
   elseif type(ce.func)=='function' then
      w = ce.func()
   else
     error("Event function string unknown")
   end
   if ce.dontwait or w then running=running+1 end
end                

lunamorica.addgadget("$eventchain",{
    draw=function()      
      --chat("draw")
      ec_exe('draw')
    end,
    lupdate=function(dt)
      --chat("update")
      ec_exe('update')
    end
            
})

function StartEvent(evchain)
  eventchain = evchain
  eventchain.running=1
end

function EventRunning()
  return eventchain.running~=nil,eventchain.running
end

