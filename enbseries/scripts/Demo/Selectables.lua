local bit32 = require('bit')
local ImGui = require('ImGui')         

local Enum = ImGui.Enum

require('enbseries.scripts.Demo.Helper')

do
    local selection0 = { {false}, {true},  {false}, {false}, {false} }
    local selection1 = { {false}, {false}, {false}, {false}, {false} }
    local selected0  = -1
    local selected1  = { {false}, {false}, {false} }
    local selected2  = { }
    local selected3  = { {true}, {false}, {false},{false}, {false}, {true}, {false}, {false}, 
                         {false},{false}, {true}, {false}, {false}, {false},{false}, {true}};
    -- populate data
    for i=1, 16 do
        selected2[i] = {}
        selected2[i][1] = false
    end
    
    function Widgets_Selectables() 
        -- Selectable() has 2 overloads:
        -- - The one taking "bool" as a read-only selection information. When Selectable() has been clicked is returns true and you can alter selection state accordingly.
        -- - The one taking "tbl" as a read-write selection information (convenient in some cases)
        -- The earlier is more flexible, as in real application your selection may be stored in a different manner (in flags within objects, as an external list, etc).
        if (ImGui.TreeNode("Basic")) then
            ImGui.Selectable("1. I am selectable", selection0[1]);
            ImGui.Selectable("2. I am selectable", selection0[2]);
            ImGui.Text("3. I am not selectable");
            ImGui.Selectable("4. I am selectable", selection0[4]);
            if (ImGui.Selectable("5. I am double clickable", selection0[5], Enum['ImGuiSelectableFlags_AllowDoubleClick'])) then
                if (ImGui.IsMouseDoubleClicked(0)) then selection0[5][1] = not selection0[5][1] end
            end
            ImGui.TreePop();
        end
        if (ImGui.TreeNode("Selection State: Single Selection")) then
            ImGui.Text(string.format("%d", selected0));
            for n = 1, 5 do
                if (ImGui.Selectable(string.format("Object %d", n), (selected0 == n))) then
                    selected0 = n
                end
            end
            ImGui.TreePop();
        end
        if (ImGui.TreeNode("Selection State: Multiple Selection")) then
            ShowHelpMarker("Hold CTRL and click to select multiple items.")
            for n = 1, 5 do
                if (ImGui.Selectable(string.format("Object %d", n), selection1[n][1])) then
                    if (not ImGui.GetIO().KeyCtrl) then -- Clear selection when CTRL is not held
                        for m = 1, 5 do selection1[m][1] = false end
                    end
                    selection1[n][1] = not selection1[n][1]
                end
            end
            ImGui.TreePop();
        end
        if (ImGui.TreeNode("Rendering more text into the same line")) then
            -- Using the Selectable() override that takes "bool* p_selected" parameter and toggle your booleans automatically.
            ImGui.Selectable("main.c",    selected1[1]); ImGui.SameLine(300); ImGui.Text(" 2,345 bytes")
            ImGui.Selectable("Hello.cpp", selected1[2]); ImGui.SameLine(300); ImGui.Text("12,345 bytes")
            ImGui.Selectable("Hello.h",   selected1[3]); ImGui.SameLine(300); ImGui.Text(" 2,345 bytes")
            ImGui.TreePop()
        end
        if (ImGui.TreeNode("In columns")) then
            ImGui.Columns(3, nil, false);
            for i=1, 16 do
                if (ImGui.Selectable(string.format("Item %d", i), selected2[i])) then end
                ImGui.NextColumn();
            end
            ImGui.Columns(1);
            ImGui.TreePop();
        end
        if (ImGui.TreeNode("Grid")) then            
            for i=1, 16 do
                ImGui.PushID(i)
                if (ImGui.Selectable("Sailor", selected3[i], 0, { 50.0, 50.0} )) then
                    local x = (i-1) % 4; local y = math.floor((i-1) / 4)
                    if (x > 0) then selected3[i - 1] = not selected3[i - 1] end
                    if (x < 3) then selected3[i + 1] = not selected3[i + 1] end
                    if (y > 0) then selected3[i - 4] = not selected3[i - 4] end
                    if (y < 3) then selected3[i + 4] = not selected3[i + 4] end
                end
                if (((i-1) % 4) < 3) then ImGui.SameLine() end
                ImGui.PopID()
            end
            ImGui.TreePop()
        end
    end --func
end