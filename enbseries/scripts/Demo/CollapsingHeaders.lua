local bit32 = require('bit')
local ImGui = require('ImGui')         

local Enum = ImGui.Enum

require('enbseries.scripts.Demo.Helper')

do
    local closable_group = {false}
    
    function Widgets_CollapsingHeaders() 
        ImGui.Checkbox("Enable extra group", closable_group)
        if (ImGui.CollapsingHeader("Header")) then
            ImGui.Text(string.format("IsItemHovered: %s", ImGui.IsItemHovered()))
            for i = 0, 4 do
                ImGui.Text(string.format("Some content %d", i))
            end
        end

        if (ImGui.CollapsingHeader("Header with a close button", closable_group)) then
            ImGui.Text(string.format("IsItemHovered: %s", ImGui.IsItemHovered()))
            for i = 0, 4 do
                ImGui.Text(string.format("More content %d", i))
            end
        end
    end
end