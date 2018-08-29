local bit32 = require('bit')
local ImGui = require('ImGui')         

local Enum = ImGui.Enum

require('enbseries.scripts.Demo.Helper')

do
    local pressed_count = 0

    function Widgets_Image()
        local _io = ImGui.GetIO()
        ImGui.TextWrapped("Below we are displaying the font texture (which is the only texture we have access to in this demo)."..
                          "Use the 'ImTextureID' type as storage to pass pointers or identifier to your own texture data. Hover the texture for a zoomed view!")

        local my_tex_id = _io.Fonts.TexID;
        local my_tex_w  = (my_tex_id.tex1).x;
        local my_tex_h  = (my_tex_id.tex1).y;

        ImGui.Text(string.format("%.0fx%.0f", my_tex_w, my_tex_h))
        local pos = ImGui.GetCursorScreenPos()
        ImGui.Image(my_tex_id, {my_tex_w, my_tex_h}, {0,0}, {1,1}, {1.0, 1.0, 1.0, 1.0}, {1.0, 1.0, 1.0, 0.5})
        
        if (ImGui.IsItemHovered()) then
            ImGui.BeginTooltip()
            local region_sz = 32.0
            local region_x  = _io.MousePos[1] - pos[1] - region_sz * 0.5; if (region_x < 0.0) then region_x = 0.0; elseif (region_x > (my_tex_w - region_sz)) then region_x = my_tex_w - region_sz end
            local region_y  = _io.MousePos[2] - pos[2] - region_sz * 0.5; if (region_y < 0.0) then region_y = 0.0; elseif (region_y > (my_tex_h - region_sz)) then region_y = my_tex_h - region_sz end
            local zoom      = 4.0
            ImGui.Text(string.format("Min: (%.2f, %.2f)", region_x, region_y))
            ImGui.Text(string.format("Max: (%.2f, %.2f)", region_x + region_sz, region_y + region_sz))
            local uv0 = { region_x / my_tex_w, region_y / my_tex_h}
            local uv1 = {(region_x + region_sz) / my_tex_w, (region_y + region_sz) / my_tex_h}
            ImGui.Image(my_tex_id, {region_sz * zoom, region_sz * zoom}, uv0, uv1, {1.0, 1.0, 1.0, 1.0}, {1.0, 1.0, 1.0, 0.5})
            ImGui.EndTooltip()
        end
        ImGui.TextWrapped("And now some textured buttons..")
        
        ImGui.PushID("temp")
        for i = 0, 7 do 
            ImGui.PushID(i)
            local frame_padding = i - 1;     -- -1 = uses default padding
           
           --not registering keypress somehow....
            if ( ImGui.ImageButton(my_tex_id, { 32.0, 32.0}, { 0.0, 0.0}, { 32.0 / my_tex_w, 32.0 / my_tex_h}, frame_padding, {0.0, 0.0, 0.1, 1.0}) ) then
                pressed_count = pressed_count + 1
            end
            
            ImGui.PopID()
            ImGui.SameLine()
        end
        ImGui.PopID()

        ImGui.NewLine()
        ImGui.Text(string.format("Pressed %d times.", pressed_count))
    end
end