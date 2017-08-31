--[[
  Talk.lua
  Version: 17.08.31
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
-- *import scenario
-- *import Var

local talking
local talkconfig    = j_love_import("SCRIPT/DATA/TALK.LUA")
local talkfunctions = j_love_import("SCRIPT/DATA/TALKFUNCTIONS.LUA")
local TalkFont      = love.graphics.newFont( "FONTS/HIGHWAY.TTF", 20 )

talkconfig.PLAYER = talkconfig.KTHURA


function StopTalking()
     if not talking then return end
     local seg = talking.segs[talking.seg]
     if not seg then return end
     (talkfunctions[seg.tag:upper()] or talkfunctions.GEN).Stop(seg.tag)
     talking=nil
end

local function TalkCallBack()
    local seg = talking.segs[talking.seg]
    if not seg then
       talking=nil 
       return true 
    end
    (talkfunctions[seg.tag:upper()] or talkfunctions.GEN).Start(seg.tag)
    for l in each(seg.lines) do
        black()
        for x=l.x-1,l.x+1 do for y=l.y-1,l.y+1 do love.graphics.draw(l.graph,x,y,0,1,1,l.ox,0) end end
        Color(seg.color.R,seg.color.G,seg.color.B)
        love.graphics.draw(l.graph,l.x,l.y,0,1,1,l.ox,0) 
    end
    local tme = math.abs(love.timer.getTime()-seg.time)
    --print("Time :"..tme.."; MaxTime: "..seg.maxtime.."; Segment:"..talking.seg)
    if tme>seg.maxtime then 
       talking.seg=talking.seg+1
       (talkfunctions[seg.tag:upper()] or talkfunctions.GEN).Stop(seg.tag)
       if not talking.segs[talking.seg] then
          talking=nil 
          return true 
       end 
       talking.segs[talking.seg].time=love.timer.getTime();
    end
    return false
end



function Talk(base,tag)
   if talking then return TalkCallBack() end
   gamedata.data.VARS = gamedata.data.VARS or {}
   Var.Reg(gamedata.data.VARS)
   if not Done('&TAGS') then
      --Var.D('<ouml>','\182\60')
      --Var.D('Morker','M\246rker')
      j_love_import("$$mydir$$/SPECIAAL.LUASCRIPT") -- Extention msy NEVER be .lua or the builder will FREAK OUT!
   end
   -- If "talking" is not active, then let's parse the data out
   local scen=scenario
   assert(scen.data,errortag("Talk",{base,tag},"Scenario data not loaded"))
   assert(scen.data[base],errortag("Talk",{base,tag},"Scenario block doesn't exist"))
   local d = scen.data[base][tag:upper()]
   assert(d,errortag("Talk",{base,tag},"Scenario tag does not exist"))
   local tlen = 0
   local segs = {}
   local font = TalkFont
   local lines
   for s in each(d) do
       for l in each(s.Lines) do tlen = tlen + #l end
       local maxw = 300 + (tlen*.03); if maxw>500 then maxw=500 end
       lines = {}
       if s.Header=='KTHURA' then s.Header='PLAYER' end
       local newseg = { lines = lines, color=(talkconfig[s.Header].TextColor or {R=255,G=255,B=255}), tag=s.Header, maxtime=10+(tlen*.015) }
       segs[#segs+1] = newseg
       local line
       local words
       local graph
       local w
       local y = 0
       for l in each(s.Lines) do
           words = mysplit(Var.S(l))
           line = ""
           for i,w in ipairs(words) do
               if line ~= "" then line = line .. " " end
               line = line .. w
               graph = love.graphics.newText(font,line)
               if i==#words or graph:getWidth()>=maxw then 
                  lines[#lines+1] = { graph=graph,line=line, ox=graph:getWidth()/2, dy=y }
                  y = y + graph:getHeight()
                  line=""
               end
           end               
       end -- line
       newseg.height=y
       newseg.width=0
       for l in each(newseg.lines) do if newseg.width<l.graph:getWidth() then newseg.width=l.graph:getWidth() end end
       local bx,by = 400,300
       local act = glob.map.TagMap[gamedata.data.layer][s.Header]
       if s.Header=='KTHURA' then act = glob.map.TagMap[gamedata.data.layer].PLAYER end
       if act then
          bx = (act.COORD.x)   -gamedata.data.camx
          by = (act.COORD.y-70)-gamedata.data.camy
       end   
       if by<50 then by=50 end
       if bx<(newseg.width/2)+10 then bx=(newseg.width/2)+10 end
       if by+(newseg.height)>350 then by=350-(newseg.height) end
       if bx>790-(newseg.width/2) then bx=790-(newseg.width/2) end
       newseg.x,newseg.y=bx,by
       for l in each(newseg.lines) do l.x=newseg.x l.y=by+l.dy end
       newseg.time = love.timer.getTime()
   end -- segment  
   talking = { segs=segs, seg=1 }
   print(errortag('Talk',{base,tag}," Initiated"))
   --print(serialize('talkdata',talking))
   return false
end -- function

function MapTalk(tag)
   return Talk('MAP',tag:upper())
end   


return {Talk=Talk,MapTalk=MapTalk,StopTalking=StopTalking}
