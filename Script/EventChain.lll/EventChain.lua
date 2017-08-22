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
   if e~=ce.evt or 'update' then return end
   if type(e.func)=='string' then
      local ok,mychunk = pcall(loadstring,e.func) 
      ok = ok or assert(ok,"Event string compile error\n"..mychunk)
      ok,w = pcall(mychunk)
      ok = ok or assert(ok,"Event string runtime error:\n"..ret)
   elseif type(e.func)=='function' then
      w = e.func()
   else
     error("Event function string unknown")
   end
   if ce.dontwait or w then running=running+1 end
end                

lunamorica.addevent("$eventchain",{
    draw=function()      
      ec_exe('draw')
    end,
    update=function()
      ec_exe('update')
    end
            
})

