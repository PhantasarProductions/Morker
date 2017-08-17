--[[
  flow.lua
  
  version: 17.08.17
  Copyright (C) 2017 Jeroen P. Broks
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
local list = love.filesystem.getDirectoryItems( "$$mydir$$" )
for imp in each(list) do
    local gn = lower(imp)
    if f~="FLOW.LUA" and suffixed(imp,".LUA") then
       print("Importing FLOW: "..left(imp,#imp-4))
       chain.map[left(imp,#imp-4)] = j_love_import("$$mydir$$/"..imp)
    end
end       
