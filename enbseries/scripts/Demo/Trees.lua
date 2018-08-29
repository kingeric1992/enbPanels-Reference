
local bit32 = require('bit')
local ImGui = require('ImGui')         

local Enum = ImGui.Enum

require('enbseries.scripts.Demo.Helper')

do
    local align_label_with_current_x_position = {false}
    
-- Dumb representation of what may be user-side selection state. 
-- You may carry selection state inside or outside your objects in whatever format you see fit.
    local selection_mask = bit32.lshift(1, 2)
    
    function Widgets_Trees()
        if (ImGui.TreeNode("Basic trees")) then
            for i = 0, 4 do
                if (ImGui.TreeNode(string.format("Child %d", i), 0, i)) then
                    ImGui.Text("blah blah")
                    ImGui.SameLine()
                    if (ImGui.SmallButton("button")) then end
                    ImGui.TreePop()
                end
            end
            ImGui.TreePop()
        end

        if (ImGui.TreeNode("Advanced, with Selectable nodes")) then
            ShowHelpMarker("This is a more standard looking tree with selectable nodes.\nClick to select, CTRL+Click to toggle, click on arrows or double-click to open.");
            ImGui.Checkbox("Align label with current X position)", align_label_with_current_x_position)
            ImGui.Text("Hello!")
            
            if (align_label_with_current_x_position[1]) then
                ImGui.Unindent(ImGui.GetTreeNodeToLabelSpacing())
            end

            local node_clicked = -1; -- Temporary storage of what node we have clicked to process selection at the end of the loop. May be a pointer to your own node type, etc.
            ImGui.PushStyleVar(Enum['ImGuiStyleVar_IndentSpacing'], ImGui.GetFontSize() * 3) -- Increase spacing to differentiate leaves from expanded contents.
            
            for  i = 0, 5 do
                -- Disable the default open on single-click behavior and pass in Selected flag according to our selection state.
                local mask = 0
                
                if (bit32.band( selection_mask, bit32.lshift(1, i)) ~= 0) then 
                    mask = Enum['ImGuiTreeNodeFlags_Selected'] 
                end
                
                local node_flags = bit32.bor(Enum['ImGuiTreeNodeFlags_OpenOnArrow'], Enum['ImGuiTreeNodeFlags_OpenOnDoubleClick'], mask);
                
                if (i < 3) then
                    -- Node
                    local node_open = ImGui.TreeNode(string.format("Selectable Node %d", i), node_flags, i)
                    if (ImGui.IsItemClicked()) then
                        node_clicked = i
                    end
                    if (node_open) then
                        ImGui.Text("Blah blah\nBlah Blah")
                        ImGui.TreePop()
                    end
                else
                    -- Leaf: The only reason we have a TreeNode at all is to allow selection of the leaf. Otherwise we can use BulletText() or TreeAdvanceToLabelPos()+Text().
                    node_flags = bit32.bor(node_flags, Enum['ImGuiTreeNodeFlags_Leaf'], Enum['ImGuiTreeNodeFlags_NoTreePushOnOpen']) -- Enum['ImGuiTreeNodeFlags_Bullet']
                    ImGui.TreeNode(string.format("Selectable Leaf %d", i), node_flags, i)
                    
                    if (ImGui.IsItemClicked()) then
                        node_clicked = i
                    end
                end
            end --for
            
            if (node_clicked ~= -1) then
                -- Update selection state. Process outside of tree loop to avoid visual inconsistencies during the clicking-frame.
                if (ImGui.GetIO().KeyCtrl) then
                    selection_mask = bit32.bxor(selection_mask, bit32.lshift(1, node_clicked))           -- CTRL+click to toggle
                else --if (!(selection_mask & (1 << node_clicked))) -- Depending on selection behavior you want, this commented bit preserve selection when clicking on item that is part of the selection
                    selection_mask = bit32.lshift(1, node_clicked)        -- Click to single-select
                end
            end
            
            ImGui.PopStyleVar()                
            if (align_label_with_current_x_position[1]) then
                ImGui.Indent(ImGui.GetTreeNodeToLabelSpacing())
            end
            
            ImGui.TreePop()
        end
    end --Function
end