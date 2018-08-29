local bit32 = require('bit')
local ImGui = require('ImGui')         

local Enum = ImGui.Enum

require('enbseries.scripts.Demo.Helper')

do
    local flags = {0}
    local item_current = 1
    local item_current_2 = {1}
    local item_current_3 = {0} -- If the selection isn't within 1..count, Combo won't display a preview
    local item_current_4 = {1}
    
    function ItemGetter(data, idx)
        return data[#data - idx + 1] -- return a string on success, nil on fail
    end
    
    function Widgets_Combo()
        -- Expose flags as checkbox for the demo
        ImGui.CheckboxFlags("ImGuiComboFlags_PopupAlignLeft", flags, Enum['ImGuiComboFlags_PopupAlignLeft']);
        
        if (ImGui.CheckboxFlags("ImGuiComboFlags_NoArrowButton", flags, Enum['ImGuiComboFlags_NoArrowButton'])) then
            Widgets_flags = bit32.band(Widgets_flags, bit32.bnot(Enum['ImGuiComboFlags_NoPreview']))     -- Clear the other flag, as we cannot combine both
        end
        if (ImGui.CheckboxFlags("ImGuiComboFlags_NoPreview", flags, Enum['ImGuiComboFlags_NoPreview'])) then
            Widgets_flags = bit32.band(Widgets_flags, bit32.bnot(Enum['ImGuiComboFlags_NoArrowButton'])); -- Clear the other flag, as we cannot combine both
        end
        
        -- General BeginCombo() API, you have full control over your selection data and display type.
        local items = { "AAAA", "BBBB", "CCCC", "DDDD", "EEEE", "FFFF", "GGGG", "HHHH", "IIII", "JJJJ", "KKKK", "LLLLLLL", "MMMM", "OOOOOOO" };

        if (ImGui.BeginCombo("combo 1", items[item_current], flags[1])) then -- the 2nd arg is current "preview name"
            for n = 1, #items do
                local is_selected = (item_current == n);
                if (ImGui.Selectable(items[n], is_selected)) then item_current = n end
                -- Set the initial focus when opening the combo (scrolling + for keyboard navigation support in the upcoming navigation branch)
                if (is_selected) then ImGui.SetItemDefaultFocus() end
            end
            ImGui.EndCombo()
        end

        -- Simplified one-liner Combo() API, using values packed in a single constant string
        ImGui.Combo("combo 2 (one-liner)", item_current_2, "aaaa\0bbbb\0cccc\0dddd\0eeee\0\0");

        -- Simplified one-liner Combo() using an array of const char*
        ImGui.Combo("combo 3 (array)", item_current_3, items, #items);

        -- Simplified one-liner Combo() using an accessor function
        ImGui.Combo("combo 4 (function)", item_current_4, ItemGetter, items, #items);
    end
end