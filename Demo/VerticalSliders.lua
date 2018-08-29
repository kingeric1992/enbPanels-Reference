local bit32 = require('bit')
local ImGui = require('ImGui')         

local Enum = ImGui.Enum

require('enbseries.scripts.Demo.Helper')

do
    local int_value = { 0 }
    local values    = {{0.0}, {0.60}, {0.35}, {0.9}, {0.70}, {0.20}, {0.0}}
    local values2   = {{0.20},{0.80}, {0.40}, {0.25}}
    
    function Widgets_VerticalSliders()
        local spacing = 4;
        ImGui.PushStyleVar(Enum['ImGuiStyleVar_ItemSpacing'], { spacing, spacing })
       
        ImGui.VSliderInt("##int", {18,160}, int_value, 0, 5)
        ImGui.SameLine()
        
        ImGui.PushID("set1");
        for i=0, 6 do
            if (i > 0) then ImGui.SameLine() end
            ImGui.PushID(i)
            ImGui.PushStyleColor(Enum['ImGuiCol_FrameBg'],        ImGui.ColorConvertHSVtoRGB({ i/7.0, 0.5, 0.5, 1.0}))
            ImGui.PushStyleColor(Enum['ImGuiCol_FrameBgHovered'], ImGui.ColorConvertHSVtoRGB({ i/7.0, 0.6, 0.5, 1.0}))
            ImGui.PushStyleColor(Enum['ImGuiCol_FrameBgActive'],  ImGui.ColorConvertHSVtoRGB({ i/7.0, 0.7, 0.5, 1.0}))
            ImGui.PushStyleColor(Enum['ImGuiCol_SliderGrab'],     ImGui.ColorConvertHSVtoRGB({ i/7.0, 0.9, 0.9, 1.0}))
            ImGui.VSliderFloat("##v", {18,160}, values[i+1], 0.0, 1.0, "")
            if (ImGui.IsItemActive() or ImGui.IsItemHovered()) then
                ImGui.SetTooltip("%.3f", values[i+1][1])
            end
            ImGui.PopStyleColor(4)
            ImGui.PopID()
        end
        ImGui.PopID()
        
        local rows = 3
        local small_slider_size = { 18, (160.0 - ( rows - 1)*spacing) / rows }
        
        
        ImGui.SameLine()
        ImGui.PushID("set2")
        for nx = 0, 3 do
            if (nx > 0) then ImGui.SameLine() end
            ImGui.BeginGroup()
            for ny = 0, (rows - 1) do
                ImGui.PushID(nx*rows+ny)
                ImGui.VSliderFloat("##v", small_slider_size, values2[nx+1], 0.0, 1.0, "")
                if (ImGui.IsItemActive() or ImGui.IsItemHovered()) then
                    ImGui.SetTooltip("%.3f", values2[nx+1][1])
                end
                ImGui.PopID()
            end
            ImGui.EndGroup()
        end
        ImGui.PopID()

        
        ImGui.SameLine()
        ImGui.PushID("set3")
        for i = 0, 3 do
            if (i > 0) then ImGui.SameLine() end
            ImGui.PushID(i)
            ImGui.PushStyleVar(Enum['ImGuiStyleVar_GrabMinSize'], 40)
            ImGui.VSliderFloat("##v", {40,160}, values[i+1], 0.0, 1.0, "%.2f\nsec")
            ImGui.PopStyleVar()
            ImGui.PopID()
        end
        ImGui.PopID()
        ImGui.PopStyleVar()
    end
end