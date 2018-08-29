local bit32 = require('bit')
local ImGui = require('ImGui')         

local Enum = ImGui.Enum

require('enbseries.scripts.Demo.Helper')

do
    local color             = { 114/255, 144/255, 154/255, 200/255 }
    local alpha_preview     = {true }
    local alpha_half_preview= {false}
    local drag_and_drop     = {true }
    local options_menu      = {true }
    local hdr               = {false}
    
    local alpha             = {true}
    local alpha_bar         = {true}
    local side_preview      = {true}
    local ref_color         = {false}
    local ref_color_v       = { 1.0, 0.0, 1.0, 0.5}
    local inputs_mode       = {2}
    local picker_mode       = {0}    
    
    local saved_palette     = {}
    local backup_color      = {}
    
    -- Generate a dummy palette
    for i=1, 32 do
        saved_palette[i] = ImGui.ColorConvertHSVtoRGB({(i-1) / 31.0, 0.8, 0.8, 1.0})
    end
            
    function Widgets_ColorPicker()
        ImGui.Checkbox("With Alpha Preview",      alpha_preview)
        ImGui.Checkbox("With Half Alpha Preview", alpha_half_preview)
        ImGui.Checkbox("With Drag and Drop",      drag_and_drop)
        ImGui.Checkbox("With Options Menu",       options_menu); ImGui.SameLine(); ShowHelpMarker("Right-click on the individual color widget to show options.")
        ImGui.Checkbox("With HDR", hdr); ImGui.SameLine(); ShowHelpMarker("Currently all this does is to lift the 0..1 limits on dragging widgets.")
        local misc_flags = bit32.bor( 
            Enum['ImGuiColorEditFlags_HDR'] *               BoolToNum(hdr[1]), 
            Enum['ImGuiColorEditFlags_NoDragDrop'] *        BoolToNum(not drag_and_drop[1]),  
            Enum['ImGuiColorEditFlags_AlphaPreviewHalf'] *  BoolToNum(alpha_half_preview[1]),
            Enum['ImGuiColorEditFlags_AlphaPreview'] *      BoolToNum((not alpha_half_preview[1]) and alpha_preview),
            Enum['ImGuiColorEditFlags_NoOptions'] *         BoolToNum(not options_menu))

        ImGui.Text("Color widget:")
        ImGui.SameLine(); ShowHelpMarker("Click on the colored square to open a color picker.\nCTRL+click on individual component to input value.\n")
        ImGui.ColorEdit3("MyColor##1", color, misc_flags)

        ImGui.Text("Color widget HSV with Alpha:")
        ImGui.ColorEdit4("MyColor##2", color, bit32.bor(Enum['ImGuiColorEditFlags_HSV'], misc_flags))

        ImGui.Text("Color widget with Float Display:")
        ImGui.ColorEdit4("MyColor##2f", color, bit32.bor(Enum['ImGuiColorEditFlags_Float'], misc_flags))

        ImGui.Text("Color button with Picker:")
        ImGui.SameLine(); ShowHelpMarker("With the ImGuiColorEditFlags_NoInputs flag you can hide all the slider/text inputs.\nWith the ImGuiColorEditFlags_NoLabel flag you can pass a non-empty label which will only be used for the tooltip and picker popup.")
        ImGui.ColorEdit4("MyColor##3", color, bit32.bor(Enum['ImGuiColorEditFlags_NoInputs'], Enum['ImGuiColorEditFlags_NoLabel'], misc_flags))

        ImGui.Text("Color button with Custom Picker Popup:")
        
        local open_popup = ImGui.ColorButton("MyColor##3b", color, misc_flags)
        ImGui.SameLine(); open_popup = open_popup or ImGui.Button("Palette")
        
        if (open_popup) then
            ImGui.OpenPopup("mypicker"); backup_color = color
        end
        
        if (ImGui.BeginPopup("mypicker")) then
            -- FIXME: Adding a drag and drop example here would be perfect!
            ImGui.Text("MY CUSTOM COLOR PICKER WITH AN AMAZING PALETTE!")
            ImGui.Separator()
            ImGui.ColorPicker4("##picker", color, bit32.bor(misc_flags, Enum['ImGuiColorEditFlags_NoSidePreview'], Enum['ImGuiColorEditFlags_NoSmallPreview']))
            ImGui.SameLine()
            ImGui.BeginGroup()
            ImGui.Text("Current")
            ImGui.ColorButton("##current", color, bit32.bor(Enum['ImGuiColorEditFlags_NoPicker'], Enum['ImGuiColorEditFlags_AlphaPreviewHalf']), {60,40})
            ImGui.Text("Previous")
            if (ImGui.ColorButton("##previous", backup_color, bit32.bor(Enum['ImGuiColorEditFlags_NoPicker'], Enum['ImGuiColorEditFlags_AlphaPreviewHalf']), {60,40})) then
                color = backup_color
            end
            ImGui.Separator()
            ImGui.Text("Palette")
            
            local flag = bit32.bor(Enum['ImGuiColorEditFlags_NoAlpha'], Enum['ImGuiColorEditFlags_NoPicker'], Enum['ImGuiColorEditFlags_NoTooltip'])
            for n=1, #saved_palette do
                ImGui.PushID(n)
                if (((n-1) % 8) ~= 0) then
                    local _, spacingY = ImGui.GetStyleVar(Enum['ImGuiStyleVar_ItemSpacing'])
                    ImGui.SameLine(0.0, spacingY)
                end
                if (ImGui.ColorButton("##palette", saved_palette[n], flag, {20,20})) then
                    color = { saved_palette[n][1], saved_palette[n][2], saved_palette[n][3], color[4]} -- Preserve alpha!
                end
                
                --[[
                if (ImGui.BeginDragDropTarget()) then
                    if (const ImGuiPayload* payload = AcceptDragDropPayload(IMGUI_PAYLOAD_TYPE_COLOR_3F))
                        memcpy((float*)&saved_palette[n], payload->Data, sizeof(float) * 3);
                    if (const ImGuiPayload* payload = AcceptDragDropPayload(IMGUI_PAYLOAD_TYPE_COLOR_4F))
                        memcpy((float*)&saved_palette[n], payload->Data, sizeof(float) * 4);
                    ImGui.EndDragDropTarget()
                end
                ]]--
                ImGui.PopID()
            end
            ImGui.EndGroup()
            ImGui.EndPopup()
        end

        ImGui.Text("Color button only:")
        ImGui.ColorButton("MyColor##3c", color, misc_flags, {80,80})

        ImGui.Text("Color picker:")
        ImGui.Checkbox("With Alpha",        alpha)
        ImGui.Checkbox("With Alpha Bar",    alpha_bar)
        ImGui.Checkbox("With Side Preview", side_preview)
        if (side_preview[1]) then
            ImGui.SameLine()
            ImGui.Checkbox("With Ref Color", ref_color)
            if (ref_color[1]) then
                ImGui.SameLine();
                ImGui.ColorEdit4("##RefColor", ref_color_v, bit32.bor(Enum['ImGuiColorEditFlags_NoInputs'], misc_flags));
            end
        end
        ImGui.Combo("Inputs Mode", inputs_mode, "All Inputs\0No Inputs\0RGB Input\0HSV Input\0HEX Input\0")
        ImGui.Combo("Picker Mode", picker_mode, "Auto/Current\0Hue bar + SV rect\0Hue wheel + SV triangle\0")
        ImGui.SameLine(); ShowHelpMarker("User can right-click the picker to change mode.");
        
        local flags = misc_flags;
        if (not alpha[1])        then flags = bit32.bor(flags, Enum['ImGuiColorEditFlags_NoAlpha']) end -- This is by default if you call ColorPicker3() instead of ColorPicker4()
        if (alpha_bar[1])        then flags = bit32.bor(flags, Enum['ImGuiColorEditFlags_AlphaBar']) end
        if (not side_preview[1]) then flags = bit32.bor(flags, Enum['ImGuiColorEditFlags_NoSidePreview'])   end
        if (picker_mode[1] == 1) then flags = bit32.bor(flags, Enum['ImGuiColorEditFlags_PickerHueBar'])    end
        if (picker_mode[1] == 2) then flags = bit32.bor(flags, Enum['ImGuiColorEditFlags_PickerHueWheel'])  end
        if (inputs_mode[1] == 1) then flags = bit32.bor(flags, Enum['ImGuiColorEditFlags_NoInputs']) end
        if (inputs_mode[1] == 2) then flags = bit32.bor(flags, Enum['ImGuiColorEditFlags_RGB']) end
        if (inputs_mode[1] == 3) then flags = bit32.bor(flags, Enum['ImGuiColorEditFlags_HSV']) end
        if (inputs_mode[1] == 4) then flags = bit32.bor(flags, Enum['ImGuiColorEditFlags_HEX']) end
        
        if (ref_color[1]) then
            ImGui.ColorPicker4("MyColor##4", color, flags, ref_color_v)
        else
            ImGui.ColorPicker4("MyColor##4", color, flags)
        end
            
        ImGui.Text("Programmatically set defaults:")
        ImGui.SameLine(); ShowHelpMarker(
            "SetColorEditOptions() is designed to allow you to set boot-time default.\n"..
            "We don't have Push/Pop functions because you can force options on a per-widget basis if needed, and the user can change non-forced ones with the options menu.\n"..
            "We don't have a getter to avoid encouraging you to persistently save values that aren't forward-compatible."
        )
        if (ImGui.Button("Default: Uint8 + HSV + Hue Bar")) then
            ImGui.SetColorEditOptions(bit32.bor(Enum['ImGuiColorEditFlags_Uint8'], Enum['ImGuiColorEditFlags_HSV'], Enum['ImGuiColorEditFlags_PickerHueBar']))
        end
        if (ImGui.Button("Default: Float + HDR + Hue Wheel")) then
            ImGui.SetColorEditOptions(bit32.bor(Enum['ImGuiColorEditFlags_Float'], Enum['ImGuiColorEditFlags_HDR'], Enum['ImGuiColorEditFlags_PickerHueWheel']))
        end
    end
end