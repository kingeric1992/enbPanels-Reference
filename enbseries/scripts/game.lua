local bit32 = require('bit')
local ImGui = require('ImGui')         
local Game  = require "Game"



local offset_fov = "0x02F6284C" -- SSE: 1.5.39.08
local fov = {0.0}

function onENBCallback_EndFrame()
    
    ImGui.Begin("Game Address", _, ImGui.Enum['ImGuiWindowFlags_UseGlobalUV']) 
    
    ImGui.Text(string.format("Fov offset: %s", offset_fov))
    
    fov[1] = Game.GetFloat(offset_fov);
    if (ImGui.SliderFloat("FOV", fov, 1.0, 179.0)) then 
        Game.SetFloat(offset_fov, fov[1])
    end
    
    ImGui.End()
end