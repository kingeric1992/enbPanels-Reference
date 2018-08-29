local bit32 = require('bit')
local ImGui = require('ImGui')         

local Enum = ImGui.Enum

require('enbseries.scripts.Demo.Helper')

do
    local col1  = { 1.0, 0.0, 0.2 }
    local col2  = { 0.4, 0.7, 0.0, 0.5 }
    local mode  = 0;
    local names = { "Bobby", "Beatrice", "Betty", "Brianna", "Barry", "Bernard", "Bibi", "Blaine", "Bryn" }
    
    function Widgets_DragAndDrop()
    -- ColorEdit widgets automatically act as drag source and drag target.
    -- They are using standardized payload strings IMGUI_PAYLOAD_TYPE_COLOR_3F and IMGUI_PAYLOAD_TYPE_COLOR_4F to allow your own widgets
    -- to use colors in their drag and drop interaction. Also see the demo in Color Picker -> Palette demo.
    
        do  -- do/end block here is only to limit scope/organize code
            ImGui.BulletText("Drag and drop in standard widgets");
            ImGui.Indent();
            ImGui.ColorEdit3("color 1", col1);
            ImGui.ColorEdit4("color 2", col2);
            ImGui.Unindent();
            ImGui.BulletText("Drag and drop to copy/swap items");
            ImGui.Indent();
        end
    
        local Mode_Copy, Mode_Move, Mode_Swap = 0, 1, 2
        if (ImGui.RadioButton("Copy", mode == Mode_Copy)) then mode = Mode_Copy; end; ImGui.SameLine();
        if (ImGui.RadioButton("Move", mode == Mode_Move)) then mode = Mode_Move; end; ImGui.SameLine();
        if (ImGui.RadioButton("Swap", mode == Mode_Swap)) then mode = Mode_Swap; end;
        
        
        for n = 1, #names do
            ImGui.PushID(n)
            if (((n-1) % 3) ~= 0) then ImGui.SameLine() end
            ImGui.Button(names[n], {60,60})
            
            local data = {n} --the payload table, place your data inside the table

            -- Our buttons are both drag sources and drag targets here!
            if (ImGui.BeginDragDropSource(Enum['ImGuiDragDropFlags_None'])) then
                ImGui.SetDragDropPayload("DND_DEMO_CELL", data) -- Set our payload, with typeID "DND_DEMO_CELL"
                -- Display preview (could be anything, e.g. when dragging an image we could decide to display the filename and a small preview of the image, etc.)
                if (mode == Mode_Copy) then ImGui.Text(string.format("Copy %s", names[n])) end
                if (mode == Mode_Move) then ImGui.Text(string.format("Move %s", names[n])) end
                if (mode == Mode_Swap) then ImGui.Text(string.format("Swap %s", names[n])) end
                ImGui.EndDragDropSource()
            end
            
            if (ImGui.BeginDragDropTarget()) then
                local payload = ImGui.AcceptDragDropPayload("DND_DEMO_CELL") -- Accept our payload, with matching typeID "DND_DEMO_CELL"
                if (payload ~= nil) then
                    local payload_n = payload[1] -- the n we put in data table
                    print(string.format("dst: %d, src: %d", n, payload_n))
                    if     (mode == Mode_Copy) then names[n] = names[payload_n]
                    elseif (mode == Mode_Move) then names[n] = names[payload_n]; names[payload_n] = "";
                    elseif (mode == Mode_Swap) then 
                        local tmp = names[n]; names[n] = names[payload_n]; names[payload_n] = tmp
                    end
                end
                ImGui.EndDragDropTarget()
            end
            ImGui.PopID()
        end
        ImGui.Unindent()
    end
end