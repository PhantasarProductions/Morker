--[[
  NewGame.lua
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

local netresults = {}
local start_config = { Net = { GameJolt=false, Anna=false }, Login = {GameJolt={User='',Token=''},Anna={ID='',Secu=''}}, lang='English'}
local flow = {}
local go
local game_setup = {

        -- Networks
        Networks = {
                     kind='pivot',y=100,x=0,kids = {
                     {
                        kind='picture',
                        image='text:Welcome to this game',
                        font="Fonts/Highway.ttf", fontsize=15,
                        hot='c',
                        PR=255,PB=255,PG=0,
                        x=400                        
                     },
                     {
                        kind='picture',
                        image='text:Do you wish to connect to the networks below?',
                        font="Fonts/Highway.ttf", fontsize=15,
                        y=40,x=400,
                        hot='c',
                        PR=255,PB=255,PG=0
                     },
                     {
                        kind='checkbox',
                        FR=255,FG=180,FB=0,
                        x=300,y=80,
                        enabled=true,
                        action=function(g) start_config.Net.Anna=g.checked end,
                        kids = { { kind='label',caption='Anna',font="Fonts/Highway.ttf", fontsize=15,x=50,FR=0,FG=255,FB=255 } } 
                        
                     },
                     {
                        kind='checkbox',
                        FR=255,FG=180,FB=0,
                        x=300,y=120,
                        enabled=true,
                        action=function(g) start_config.Net.GameJolt=g.checked end,
                        kids = { { kind='label',caption='Game Jolt',font="Fonts/Highway.ttf", fontsize=15,x=50,FR=0,FG=255,FB=255 } } 
                        
                     } ,
                     {
                        kind='button',
                        FR=0,FG=0,FB=0,
                        BR=255,BG=180,BB=0,
                        x=400,y=160,
                        caption="Next >",
                        font="Fonts/Highway.ttf", fontsize=15,
                        action=function(g) 
                           print("Button hit, so let's go!")
                           if     start_config.Net.Anna     then go('Anna')
                           elseif start_config.Net.GameJolt then go('GameJolt')
                           else                                  go('PickLanguage') end
                        end   
                     }                       
                                             
                   }
                  },
        Anna = {kind='pivot',y=100,x=40, kids={
             {
                 kind='label',
                 caption="ID Number:",
                 font="Fonts/Highway.ttf", fontsize=15,
                 x=40,y=0,FR=255,FG=0,FB=255            
             },
             {
                 kind='label',
                 caption="Secu Code:",
                 font="Fonts/Highway.ttf", fontsize=15,
                 x=40,y=40,FR=255,FG=0,FB=255                 
             },
             AnU = { 
                 kind='textfield',
                 font="Fonts/Highway.ttf", fontsize=15,
                 FR=0,FG=0,FB=0,
                 BR=255,BG=180,BB=0,
                 x=400,y=0,
                 w=200,h=20,
                 typing=function(g)
                     start_config.Login.Anna.ID=g.text
                     g.parent.kids.Ok.visible = start_config.Login.Anna.ID~="" and start_config.Login.Anna.Secu~=""
                 end
             },
             AnS = { 
                 kind='textfield',
                 font="Fonts/Highway.ttf", fontsize=15,
                 FR=0,FG=0,FB=0,
                 BR=255,BG=180,BB=0,
                 x=400,y=40,
                 w=200,h=20,
                 typing=function(g)
                     start_config.Login.Anna.Secu=g.text
                     g.parent.kids.Ok.visible = start_config.Login.Anna.ID~="" and start_config.Login.Anna.Secu~=""
                 end
             },
             Ok = { 
                 kind='button',x=400,y=80, 
                 FR=0,FG=0,FB=0,
                 BR=255,BG=180,BB=0,
                 caption='Next >',
                 visible=false,
                 action=function(g) 
                   print("Button hit, so let's go!")
                   if     start_config.Net.GameJolt then go('GameJolt')
                   else                                  go('PickLanguage') end
                 end   

             },
             { 
                 kind='button',x=40,y=80, 
                 FR=0,FG=0,FB=0,
                 BR=255,BG=180,BB=0,
                 caption='Create Anna account',
                 action=function(g)
                     go("CreateAnna")                      
                 end
             }
             
        }},
                 
        CreateAnna = {kind='pivot',y=100,x=40, kids = {
             {
                  kind='label',x=20,y=0,FR=255,FG=0,FB=255,
                  font="Fonts/Highway.ttf", fontsize=15,
                  caption="Please enter a screen name and hit the continue button to go on"
             },
             UN = {
                 kind='textfield',x=20,y=40,w=200,
                 FR=0,FG=0,FB=0,
                 BR=255,BG=180,BB=0,
                 typing=function (g)
                    g.parent.kids.OK.visible=g.text~=""
                 end                                       
             },
             OK= {
                 kind='button',x=40,y=80, 
                 FR=0,FG=0,FB=0,
                 BR=255,BG=180,BB=0,
                 caption='Create Anna account',
                 action=function(g)
                    local suc,dat = AnnaCreate(g.parent.kids.UN.text)
                    if suc then
                       g.parent.parent.kids.Anna.kids.AnU.text=dat.onlineid
                       g.parent.parent.kids.Anna.kids.AnS.text=dat.secucode
                       g.parent.parent.kids.Anna.kids.Ok .visible=true
                       start_config.Login.Anna.Secu = dat.secucode
                       start_config.Login.Anna.ID   = dat.onlineid
                       go("Anna")
                    else
                       g.parent.kids.ErrorLabel.caption="ERROR: "..dat   
                    end
                 end
             },
             Cancel ={
                 kind='button',x=40,y=120, 
                 FR=255,FG=255,FB=0,
                 BR=255,BG=000,BB=0,
                 caption='Cancel',
                 action=function(g) go ( "Anna" ) end
             },
             ErrorLabel = {
                 kind='label',
                 x=40,y=160,
                 FR=255,FG=0,FB=0,
                 caption="   "
             } 
        }},
        GameJolt = {kind='pivot',y=100,x=40,kids={
             {
                 kind='label',
                 caption="User Name:",
                 font="Fonts/Highway.ttf", fontsize=15,
                 x=40,y=0,FR=255,FG=0,FB=255            
             },
             {
                 kind='label',
                 caption="Token:",
                 font="Fonts/Highway.ttf", fontsize=15,
                 x=40,y=40,FR=255,FG=0,FB=255                 
             },
             GJU = { 
                 kind='textfield',
                 typing=function(g)
                     start_config.Login.GameJolt.User=g.text
                     g.parent.kids.Ok.visible = start_config.Login.GameJolt.User~="" and start_config.Login.GameJolt.Token~=""
                 end,
                 font="Fonts/Highway.ttf", fontsize=15,
                 FR=0,FG=0,FB=0,
                 BR=255,BG=180,BB=0,
                 x=400,y=0,
                 w=200,h=20
                 
             },
             GJT={ 
                 kind='textfield',
                 typing=function(g)
                     start_config.Login.GameJolt.Token=g.text
                     g.parent.kids.Ok.visible = start_config.Login.GameJolt.User~="" and start_config.Login.GameJolt.Token~=""
                 end,
                 font="Fonts/Highway.ttf", fontsize=15,
                 FR=0,FG=0,FB=0,
                 BR=255,BG=180,BB=0,
                 x=400,y=40,
                 w=200,h=20                 
             },
             Ok={             
                 kind='button',x=400,y=80, 
                 FR=0,FG=0,FB=0,
                 BR=255,BG=180,BB=0,
                 caption='Next >',
                 visible=false,
                 action=function(g)
                     go('PickLanguage')
                 end     
             }
        }},
        
        PickLanguage = {kind='pivot',y=100,x=40,kids={
            {
                  kind='label',
                  FR=255,FG=0,FB=255,
                  caption="Pick your scenario language:",
                  font="Fonts/Highway.ttf", fontsize=15,
            },
            {
                  kind='label',
                  FR=255,FG=0,FB=255,
                  y=20,
                  caption="Please note this ONLY affects",
                  font="Fonts/Highway.ttf", fontsize=15,
            },
            {
                  kind='label',
                  FR=255,FG=0,FB=255,
                  y=40,
                  caption="the scenario.",
                  font="Fonts/Highway.ttf", fontsize=15,
            },
            {
                  kind='label',
                  FR=255,FG=0,FB=255,
                  y=60,
                  caption="System text, inventory items etc. remain in English",
                  font="Fonts/Highway.ttf", fontsize=15,
            },
            {
                  kind='radio',
                  FR=255,FG=180,FB=0,
                  y=100,
                  checked=true,
                  action=function(g) start_config.lang='English' end
            },
            {
                  kind='radio',
                  FR=255,FG=180,FB=0,
                  y=120,
                  checked=false,
                  action=function(g) start_config.lang='Dutch' end
            },
            {     
                  kind='label', 
                  FR=0,FG=255,FB=255,
                  y=100, x=100,
                  caption='English'
            },
            {     
                  kind='label', 
                  FR=0,FG=255,FB=255,
                  y=120, x=100,
                  caption='Dutch (Nederlands)'
            }      ,      
             Ok={             
                 kind='button',x=400,y=80, 
                 FR=0,FG=0,FB=0,
                 BR=255,BG=180,BB=0,
                 caption='Next >',
                 action=function(g)
                     gamedata = { data = { scored = {}, score=0, inventory={ Zamzi=true }, map='CITY', layer='outcropping', mapcall='GameStart'},config=start_config}
                     UIscore.caption=subs.score.str()
                     print ()
                     chain.go("LOGIN")
                 end     
             }
                        
        }}
         
     }
     

     
local screen = { kind='strike',r=0,g=0,b=0,x=0,h=0,kids = {
                     
                     {
                         kind='picture',
                         image='GFX/LOGOS/MORKER.PNG',
                         hot='c',
                         x=400,
                         y=50,
                         --kids = {
                         -- Below the functions are put in.
                         --}
                     }
                     
                          
               }
}

function go(n)
 for k,v in pairs(game_setup) do 
    v.visible = k==n
    screen.kids[k]=screen.kids[k] or v
    --print("Added game_setup screen: "..k.." ("..type(v)..")")
    --print(serialize('gamesetupscreen',screen))
 end    
end
go "Networks"


luna.update(screen)
lunar.NEWGAME = screen     
     
return flow     
