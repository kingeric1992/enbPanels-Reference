         
local bit32 = require('bit')
local ImGui = require('ImGui')         

local Enum = ImGui.Enum

require('enbseries.scripts.Demo.Helper')

--use do/end to limit scope
do
--these are equivilent to "static variable"
    local Basic_clicked       = 0
    local Basic_check         = {true}
    local Basic_e             = {0}
    local Basic_counter       = 0 
    local Basic_item_current  = {0}
    local Basic_str0          = {"Hello, world!"}

    local Basic_i0 = {123}
    local Basic_i1 = {50}
    local Basic_i2 = {42}
    local Basic_i3 = {0}

    local Basic_f0 = {0.001}
    local Basic_f1 = {1.e10}
    local Basic_f2 = {1.0} 
    local Basic_f3 = {0.0067}
    local Basic_f4 = {0.123}
    local Basic_f5 = {0.0}
    
    local Basic_vec4a = { 0.10, 0.20, 0.30, 0.44 }
    local Basic_angle = { 0.0};
    
    local Basic_col1 = { 1.0,0.0,0.2 }
    local Basic_col2 = { 0.4,0.7,0.0,0.5}
    
    local Basic_listbox_item_current = {1};
             
    function Widgets_Basic()        
        if (ImGui.Button("Button")) then 
            Basic_clicked = Basic_clicked + 1
        end
        
        if (bit32.band(Basic_clicked, 1)) then
            ImGui.SameLine()
            ImGui.Text("Thanks for clicking me!")
        end
        
        ImGui.Checkbox("checkbox", Basic_check)
        ImGui.RadioButton("radio a", Basic_e, 0); ImGui.SameLine()
        ImGui.RadioButton("radio b", Basic_e, 1); ImGui.SameLine()
        ImGui.RadioButton("radio c", Basic_e, 2);

    -- Color buttons, demonstrate using PushID() to add unique identifier in the ID stack, and changing style.
        for i = 0, 6 do
            if (i > 0) then 
                ImGui.SameLine()
                ImGui.PushID(i)
                ImGui.PushStyleColor(Enum['ImGuiCol_Button'],       ImGui.ColorConvertHSVtoRGB({ i/7.0, 0.6, 0.6, 1.0}))
                ImGui.PushStyleColor(Enum['ImGuiCol_ButtonHovered'],ImGui.ColorConvertHSVtoRGB({ i/7.0, 0.7, 0.7, 1.0}))
                ImGui.PushStyleColor(Enum['ImGuiCol_ButtonActive'], ImGui.ColorConvertHSVtoRGB({ i/7.0, 0.8, 0.8, 1.0}))
                ImGui.Button("Click")
                ImGui.PopStyleColor(3)
                ImGui.PopID()
            end
        end

    -- Arrow buttons
        local spacingX, spacingY = ImGui.GetStyleVar(Enum['ImGuiStyleVar_ItemInnerSpacing'])
        ImGui.PushButtonRepeat(true)
        if (ImGui.ArrowButton("##left", Enum['ImGuiDir_Left'])) then Basic_counter = Basic_counter - 1 end
        ImGui.SameLine(0.0, spacingX)
        if (ImGui.ArrowButton("##right",Enum['ImGuiDir_Right']))then Basic_counter = Basic_counter + 1 end
        ImGui.PopButtonRepeat()
        ImGui.SameLine()
        ImGui.Text(string.format("%d", Basic_counter))

        ImGui.Text("Hover over me")
        if (ImGui.IsItemHovered()) then
            ImGui.SetTooltip("I am a tooltip")
        end
        ImGui.SameLine()
        ImGui.Text("- or me")
           
        if (ImGui.IsItemHovered()) then
            ImGui.BeginTooltip()
            ImGui.Text("I am a fancy tooltip")
            ImGui.PlotLines("Curve", { 0.6, 0.1, 1.0, 0.5, 0.92, 0.1, 0.2 }, 7)
            ImGui.EndTooltip()
        end

        ImGui.Separator()
        ImGui.LabelText("label", "Value")            
        
        do
        -- Using the _simplified_ one-liner Combo() api here
        -- See "Combo" section for examples of how to use the more complete BeginCombo()/EndCombo() api.
            local items = { "AAAA", "BBBB", "CCCC", "DDDD", "EEEE", "FFFF", "GGGG", "HHHH", "IIII", "JJJJ", "KKKK", "LLLLLLL", "MMMM", "OOOOOOO" }
            ImGui.Combo("combo", Basic_item_current, items, #items)
            ImGui.SameLine(); ShowHelpMarker("Refer to the \"Combo\" section below for an explanation of the full BeginCombo/EndCombo API, and demonstration of various flags.\n")
        end
        
        do  -- Input      
            ImGui.InputText(  "input text",  Basic_str0, 128); ImGui.SameLine()
            ShowHelpMarker("Hold SHIFT or use mouse to select text.\n".."CTRL+Left/Right to word jump.\n"..
                           "CTRL+A or double-click to select all.\n".."CTRL+X,CTRL+C,CTRL+V clipboard.\n"..
                           "CTRL+Z,CTRL+Y undo/redo.\n".."ESCAPE to revert.\n"); -- [..] concate strings
                           
            ImGui.InputInt(   "input int",   Basic_i0); ImGui.SameLine()
            ShowHelpMarker("You can apply arithmetic operators +,*,/ on numerical values.\n  e.g. [ 100 ], input \'*2\', result becomes [ 200 ]\nUse +- to subtract.\n");

            ImGui.InputFloat( "input float",      Basic_f0, 0.01, 1.0)
            ImGui.InputFloat( "input scientific", Basic_f1, 0.0,  0.0, "%e"); ImGui.SameLine()
            ShowHelpMarker("You can input value using the scientific notation,\n  e.g. \"1e+8\" becomes \"100000000\".\n");
            
            ImGui.InputFloat3("input float3", Basic_vec4a);
        end

        do  -- Drag
            ImGui.DragInt("drag int", Basic_i1, 1); ImGui.SameLine()
            ShowHelpMarker("Click and drag to edit value.\nHold SHIFT/ALT for faster/slower edit.\nDouble-click or CTRL+click to input value.");

            ImGui.DragInt(  "drag int 0..100",  Basic_i2, 1, 0, 100, "%d%%")
            ImGui.DragFloat("drag float",       Basic_f2, 0.005)
            ImGui.DragFloat("drag small float", Basic_f3, 0.0001, 0.0, 0.0, "%.06f ns")
        end

        do  -- Slider
            ImGui.SliderInt("slider int", Basic_i3, -1, 3); ImGui.SameLine()
            ShowHelpMarker("CTRL+click to input value.");

            ImGui.SliderFloat("slider float",         Basic_f4, 0.0,    1.0, "ratio = %.3f")
            ImGui.SliderFloat("slider float (curve)", Basic_f5, -10.0, 10.0, "%.4f", 2.0)
            ImGui.SliderAngle("slider angle",         Basic_angle)
        end
        
        do  -- ColorEdit
            ImGui.ColorEdit3("color 1", Basic_col1); ImGui.SameLine()
            ShowHelpMarker("Click on the colored square to open a color picker.\nClick and hold to use drag and drop.\nRight-click on the colored square to show options.\nCTRL+click on individual component to input value.\n")
            ImGui.ColorEdit4("color 2", Basic_col2)
        end

        do  -- List box
            local listbox_items = { "Apple", "Banana", "Cherry", "Kiwi", "Mango", "Orange", "Pineapple", "Strawberry", "Watermelon" }
            ImGui.ListBox("listbox\n(single select)", Basic_listbox_item_current, listbox_items, #listbox_items, 4);

            -- ImGui.PushItemWidth(-1);
            -- ImGui.ListBox("##listbox2", &listbox_item_current2, listbox_items, #listbox_items, 4);
            -- ImGui.PopItemWidth();
        end
    end

end