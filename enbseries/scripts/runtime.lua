--[=======================================[

    Filename:       Runtime.lua
    Description:    Demo of Runtime lib
    Created by:     Kingeric1992
    Update Date:    Sep 10, 2018
   
--]=======================================]

local ImGui   = require('ImGui')         
local Runtime = require "Runtime"

-- We only need to format these once
local _ver  = string.format("version: %s", Runtime._VERSION);
local _path = string.format("path:    %s", Runtime._PATH);
local _name = string.format("name:    %s", Runtime._NAME);
local _dir  = string.format("dir:     %s", Runtime._DIR);

-- Address here are specifically for SkyrimSE 1.5.50.0
assert( Runtime._NAME    == "SkyrimSE.exe","unsupported runtime")
assert( Runtime._VERSION == "1.5.50.0",    "unsupported runtime version")


-- fov --------------------------------------------------
local fov_offset = "0x02F6284C"
local fov        = {0.0}
local fov_labal  = string.format("Fov: %s", fov_offset);


-- gamehour ---------------------------------------------
local tod_offsetPtr = "0x01EEABC0"
local tod_offset
local tod           = {0.0}
local tod_labal     = "ToD: "


-- weather (read-only) ----------------------------------
local weather_offsetPtr = "0x02F283D8" -- or "0x02F4DB68"
local weather_offset
local weather_curr
local weather_prev
local weather_trans
local weather           = { prev  = "0", curr  = "0", trans = 1.0 }


local frame_delay = 0

-- in this approach, we move some of the computation to BeginFrame callbacks
function onENBCallback_BeginFrame()

    -- wait a bit for runtime to initiate
    if(frame_delay < 180) then frame_delay = frame_delay + 1; return; end


    if (tod_offset == nil) then
        tod_offset = math.stradd(Runtime.GetOffsetPtr(tod_offsetPtr), "0x34")
        tod_labal  = string.format("ToD: %s", tod_offset)
    end


    if (weather_offset == nil) then
        weather_offset = Runtime.GetOffsetPtr(weather_offsetPtr)
        weather_curr   = math.stradd(weather_offset, "0x48")
        weather_prev   = math.stradd(weather_offset, "0x50")
        weather_trans  = math.stradd(weather_offset, "0x1B8")
    else    
        local offset_curr = Runtime.GetPtr(weather_curr)
        if (tonumber(offset_curr, 16) ~= 0) then
            weather['curr'] = table.concat(table.reverse(Runtime.GetAOB(math.stradd(offset_curr, "0x14"), 4)))
        else
            weather['curr'] = "0"
        end
        
        local offset_prev = Runtime.GetPtr(weather_prev)
        if (tonumber(offset_prev, 16) ~= 0) then
            weather['prev'] = table.concat(table.reverse(Runtime.GetAOB(math.stradd(offset_prev, "0x14"), 4)))
        else
            weather['prev'] = "0"
        end
        
        weather['trans'] = Runtime.GetFloat(weather_trans)
    end
end


function onENBCallback_EndFrame()
    ImGui.Begin("Runtime Lib Demo") 
    
    ImGui.Text(_ver);
    ImGui.Text(_path);
    ImGui.Text(_name);
    ImGui.Text(_dir);

    fov[1] = Runtime.GetOffsetFloat(fov_offset)
    
    if (ImGui.SliderFloat(fov_labal, fov, 1.0, 179.0)) then 
        Runtime.SetOffsetFloat(fov_offset, fov[1])
    end

    if (tod_offset ~= nil) then
        tod[1] = Runtime.GetFloat(tod_offset)  
        if (ImGui.SliderFloat(tod_labal, tod, 0.0, 24.0)) then 
            Runtime.SetFloat(tod_offset, tod[1])
        end
    end
        
    ImGui.Text("Weather:")    
    ImGui.Text(string.format("    curr:  %s", weather['curr']))
    ImGui.Text(string.format("    prev:  %s", weather['prev']))
    ImGui.Text(string.format("    trans: %f", weather['trans']))
    
    ImGui.End()
end