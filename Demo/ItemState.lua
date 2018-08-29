local bit32 = require('bit')
local ImGui = require('ImGui')         

local Enum = ImGui.Enum

require('enbseries.scripts.Demo.Helper')


do
    local item_type = {1}
    local current   = {1}
    local b         = {false}
    local col4f     = { 1.0, 0.5, 0.0, 1.0 }
    local test_window = {false};
    local embed_all_inside_a_child_window = {false}
    
    function Widgets_ItemState()
        -- Display the value of IsItemHovered() and other common item state functions. Note that the flags can be combined.
        -- (because BulletText is an item itself and that would affect the output of IsItemHovered() we pass all state in a single call to simplify the code).
        ImGui.RadioButton("Text",        item_type, 0); ImGui.SameLine()
        ImGui.RadioButton("Button",      item_type, 1); ImGui.SameLine()
        ImGui.RadioButton("CheckBox",    item_type, 2); ImGui.SameLine()
        ImGui.RadioButton("SliderFloat", item_type, 3); ImGui.SameLine()
        ImGui.RadioButton("ColorEdit4",  item_type, 4); ImGui.SameLine()
        ImGui.RadioButton("ListBox",     item_type, 5)
        
        local ret   = false;
        local items = { "Apple", "Banana", "Cherry", "Kiwi" }
        
        if (item_type[1] == 0) then       ImGui.Text(       "ITEM: Text")   end                       -- Testing text items with no identifier/interaction
        if (item_type[1] == 1) then ret = ImGui.Button(     "ITEM: Button") end                       -- Testing button
        if (item_type[1] == 2) then ret = ImGui.Checkbox(   "ITEM: CheckBox", b) end                  -- Testing checkbox
        if (item_type[1] == 3) then ret = ImGui.SliderFloat("ITEM: SliderFloat", col4f, 0.0, 1.0) end -- Testing basic item
        if (item_type[1] == 4) then ret = ImGui.ColorEdit4( "ITEM: ColorEdit4", col4f) end            -- Testing multi-component items (IsItemXXX flags are reported merged)
        if (item_type[1] == 5) then ret = ImGui.ListBox(    "ITEM: ListBox", current, items, #items, #items) end
        
        ImGui.BulletText(string.format(
            "Return value = %s\n"..
            "IsItemFocused() = %s\n"..
            "IsItemHovered() = %s\n"..
            "IsItemHovered(_AllowWhenBlockedByPopup) = %s\n"..
            "IsItemHovered(_AllowWhenBlockedByActiveItem) = %s\n"..
            "IsItemHovered(_AllowWhenOverlapped) = %s\n"..
            "IsItemHovered(_RectOnly) = %s\n"..
            "IsItemActive() = %s\n"..
            "IsItemDeactivated() = %s\n"..
            "IsItemDeactivatedAfterChange() = %s\n"..
            "IsItemVisible() = %s\n",
            ret,
            ImGui.IsItemFocused(),
            ImGui.IsItemHovered(),
            ImGui.IsItemHovered(Enum['ImGuiHoveredFlags_AllowWhenBlockedByPopup']),
            ImGui.IsItemHovered(Enum['ImGuiHoveredFlags_AllowWhenBlockedByActiveItem']),
            ImGui.IsItemHovered(Enum['ImGuiHoveredFlags_AllowWhenOverlapped']),
            ImGui.IsItemHovered(Enum['ImGuiHoveredFlags_RectOnly']),
            ImGui.IsItemActive(),
            ImGui.IsItemDeactivated(),
            ImGui.IsItemDeactivatedAfterChange(),
            ImGui.IsItemVisible()
        ));

        ImGui.Checkbox("Embed everything inside a child window (for additional testing)", embed_all_inside_a_child_window)
        if (embed_all_inside_a_child_window[1]) then
            ImGui.BeginChild("outer_child", { 0, ImGui.GetFontSize() * 20 }, true)
        end

        -- Testing IsWindowFocused() function with its various flags. Note that the flags can be combined.
        ImGui.BulletText(string.format(
            "IsWindowFocused() = %s\n"..
            "IsWindowFocused(_ChildWindows) = %s\n"..
            "IsWindowFocused(_ChildWindows|_RootWindow) = %s\n"..
            "IsWindowFocused(_RootWindow) = %s\n"..
            "IsWindowFocused(_AnyWindow) = %s\n",
            ImGui.IsWindowFocused(),
            ImGui.IsWindowFocused(Enum['ImGuiFocusedFlags_ChildWindows']),
            ImGui.IsWindowFocused(bit32.bor(Enum['ImGuiFocusedFlags_ChildWindows'], Enum['ImGuiFocusedFlags_RootWindow'])),
            ImGui.IsWindowFocused(Enum['ImGuiFocusedFlags_RootWindow']),
            ImGui.IsWindowFocused(Enum['ImGuiFocusedFlags_AnyWindow'])
        ))

        -- Testing IsWindowHovered() function with its various flags. Note that the flags can be combined.
        ImGui.BulletText(string.format(
            "IsWindowHovered() = %s\n"..
            "IsWindowHovered(_AllowWhenBlockedByPopup) = %s\n"..
            "IsWindowHovered(_AllowWhenBlockedByActiveItem) = %s\n"..
            "IsWindowHovered(_ChildWindows) = %s\n"..
            "IsWindowHovered(_ChildWindows|_RootWindow) = %s\n"..
            "IsWindowHovered(_RootWindow) = %s\n"..
            "IsWindowHovered(_AnyWindow) = %s\n",
            ImGui.IsWindowHovered(),
            ImGui.IsWindowHovered(Enum['ImGuiHoveredFlags_AllowWhenBlockedByPopup']),
            ImGui.IsWindowHovered(Enum['ImGuiHoveredFlags_AllowWhenBlockedByActiveItem']),
            ImGui.IsWindowHovered(Enum['ImGuiHoveredFlags_ChildWindows']),
            ImGui.IsWindowHovered(bit32.bor(Enum['ImGuiHoveredFlags_ChildWindows'], Enum['ImGuiHoveredFlags_RootWindow'])),
            ImGui.IsWindowHovered(Enum['ImGuiHoveredFlags_RootWindow']),
            ImGui.IsWindowHovered(Enum['ImGuiHoveredFlags_AnyWindow'])
        ))

        ImGui.BeginChild("child", {0, 50}, true)
        ImGui.Text("This is another child window for testing with the _ChildWindows flag.")
        ImGui.EndChild()
        if (embed_all_inside_a_child_window[1]) then
            ImGui.EndChild()
        end

        -- Calling IsItemHovered() after begin returns the hovered status of the title bar.
        -- This is useful in particular if you want to create a context menu (with BeginPopupContextItem) associated to the title bar of a window.
        ImGui.Checkbox("Hovered/Active tests after Begin() for title bar testing", test_window);
        if (test_window[1]) then
            ImGui.Begin("Title bar Hovered/Active tests (LUA)", test_window)
            if (ImGui.BeginPopupContextItem()) then -- <-- This is using IsItemHovered()
                if (ImGui.MenuItem("Close")) then test_window[1] = false end
                ImGui.EndPopup()
            end
            ImGui.Text(string.format(
                "IsItemHovered() after begin = %s (== is title bar hovered)\n"..
                "IsItemActive() after begin = %s (== is window being clicked/moved)\n",
                ImGui.IsItemHovered(), ImGui.IsItemActive()
            ))
            ImGui.End()
        end
    end
end