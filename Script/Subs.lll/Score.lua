--[[
**********************************************
  
  Score.lua
  (c) Jeroen Broks, 2017, All Rights Reserved.
  
  This file contains material that is related 
  to a storyline that is which is strictly
  copyrighted to Jeroen Broks.
  
  This file may only be used in an unmodified
  form with an unmodified version of the 
  software this file belongs to.
  
  You may use this file for your study to see
  how I solved certain things in the creation
  of this project to see if you find valuable
  leads for the creation of your own.
  
  Mostly this file comes along with a project
  that is for most part released under an
  open source license and that means that if
  you use that code with this file removed
  from it, you can use it under that license.
  Please check out the other files to find out
  which license applies.
  This file comes 'as-is' and in no possible
  way the author can be held responsible of
  any form of damages that may occur due to 
  the usage of this file
  
  
 **********************************************
 
version: 17.08.31
]]
local s = {}

local function sl()
 local varken = {
       ["heen"] = {
              ["a"] = "P",
              [" "] = "L",
              ["c"] = "m",
              ["b"] = "t",
              ["e"] = ")",
              ["d"] = "%",
              ["g"] = "\96",
              ["f"] = "[",
              ["i"] = "8",
              ["h"] = "r",
              ["k"] = "!",
              ["j"] = "c",
              ["m"] = ">",
              ["l"] = "J",
              ["o"] = "Y",
              ["n"] = "4",
              ["q"] = "A",
              ["p"] = "z",
              ["s"] = "y",
              ["r"] = "7",
              ["5"] = "k",
              ["t"] = "e",
              ["7"] = "]",
              ["6"] = "$",
              ["9"] = "F",
              ["8"] = "\39",
              ["z"] = "H",
              ["C"] = "=",
              ["K"] = "/",
              ["M"] = "K",
              ["\27"] = "v",
              ["0"] = "V",
              ["y"] = "9",
              ["R"] = "6",
              ["u"] = ",",
              ["\39"] = "q",
              ["4"] = "O",
              ["V"] = "&",
              ["2"] = "u",
              ["3"] = "C",
              ["["] = "M",
              ["1"] = "^",
              ["v"] = "b",
              ["w"] = "d",
              ["x"] = "p",
              ["^"] = "N"},
       ["terug"] = {
              [122] = "p",
              [75] = "M",
              [91] = "f",
              [107] = "5",
              [62] = "m",
              [76] = " ",
              [39] = "8",
              [93] = "7",
              [55] = "r",
              [78] = "^",
              [94] = "1",
              [79] = "4",
              [56] = "i",
              [80] = "a",
              [96] = "g",
              [112] = "x",
              [65] = "q",
              [41] = "e",
              [57] = "y",
              [98] = "v",
              [114] = "h",
              [67] = "3",
              [99] = "j",
              [100] = "w",
              [116] = "b",
              [101] = "t",
              [117] = "2",
              [70] = "9",
              [86] = "0",
              [77] = "[",
              [118] = "\27",
              [36] = "6",
              [44] = "u",
              [52] = "n",
              [61] = "C",
              [72] = "z",
              [38] = "V",
              [113] = "\39",
              [47] = "K",
              [37] = "d",
              [89] = "o",
              [54] = "R",
              [121] = "s",
              [74] = "l",
              [109] = "c",
              [33] = "k"}}


  return varken
end

local function ont(a)
  local varken = sl()
  local ret = ""
  for i=1,#a do
      local b = mid(a,i,1):byte()
      ret = ret .. varken.terug[b]
  end
  return ret
end

local function onti(a)
  return tonumber(ont(a)) or 0
end

local tabelletje = j_love_import('SCRIPT/DATA/KAK.LUA')
s.max = 0
for k,d in pairs(tabelletje) do 
    s.max=s.max+d.Punt     
end  

function s.score()
   s.have=0
   for k,v in pairs(gamedata.data.scored) do
       if v then
          s.have = s.have + (tabelletje[k] or {Punt=0}).Punt
       end
   end
   return s.have
end

function s.str()
  s.have = s.have or s.score()
  return "Score: "..s.have.." or "..s.max.."  ("..math.ceil((s.have/s.max)*100).."% complete)"
end         

function s.award(s)
  if s.have[s] then return end
  assert(tabelletje[s],"No data for score: "..sval(s))
  local sfx = "AUDIO/MUSICBOX/"..(({[true]=2, [false]=1})[tabelletje[s].Punt>=10])..".OGG"
  s.audio=s.audio or {}
  s.audio[sfx] = s.audio[sfx] or love.audio.newSource(sfx)
  love.audio.play(s.audio[sfx])
  s.have[s] = true
  s.score()
end
  
return s
