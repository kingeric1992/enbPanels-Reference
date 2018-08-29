local bit32 = require('bit')
local ImGui = require('ImGui')         

local Enum = ImGui.Enum

require('enbseries.scripts.Demo.Helper')

do
    local vec4f = { 0.10, 0.20, 0.30, 0.44 }
    local vec4i = { 1, 5, 100, 255 }

    function Widgets_MultiComponent()
        ImGui.InputFloat2(  "input float2", vec4f);
        ImGui.DragFloat2(   "drag float2",  vec4f, 0.01, 0.0, 1.0);
        ImGui.SliderFloat2( "slider float2",vec4f, 0.0, 1.0);
        ImGui.InputInt2(    "input int2",   vec4i);
        ImGui.DragInt2(     "drag int2",    vec4i, 1, 0, 255);
        ImGui.SliderInt2(   "slider int2",  vec4i, 0, 255);
        ImGui.Spacing();

        ImGui.InputFloat3(  "input float3", vec4f);
        ImGui.DragFloat3(   "drag float3",  vec4f, 0.01, 0.0, 1.0);
        ImGui.SliderFloat3( "slider float3",vec4f, 0.0, 1.0);
        ImGui.InputInt3(    "input int3",   vec4i);
        ImGui.DragInt3(     "drag int3",    vec4i, 1, 0, 255);
        ImGui.SliderInt3(   "slider int3",  vec4i, 0, 255);
        ImGui.Spacing();

        ImGui.InputFloat4(  "input float4", vec4f);
        ImGui.DragFloat4(   "drag float4",  vec4f, 0.01, 0.0, 1.0);
        ImGui.SliderFloat4( "slider float4",vec4f, 0.0, 1.0);
        ImGui.InputInt4(    "input int4",   vec4i);
        ImGui.DragInt4(     "drag int4",    vec4i, 1, 0, 255);
        ImGui.SliderInt4(   "slider int4",  vec4i, 0, 255);
    end
end
