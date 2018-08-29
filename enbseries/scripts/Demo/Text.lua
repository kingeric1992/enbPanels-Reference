local bit32 = require('bit')
local ImGui = require('ImGui')         

local Enum = ImGui.Enum

require('enbseries.scripts.Demo.Helper')

do
    local T_wrap_width = {200.0};
    local str        = {"\xe6\x97\xa5\xe6\x9c\xac\xe8\xaa\x9e"}
    
    function Widgets_Text()    
        if (ImGui.TreeNode("Colored Text")) then
            -- Using shortcut. You can use PushStyleColor()/PopStyleColor() for more flexibility.
            ImGui.TextColored({1.0, 0.0, 1.0, 1.0}, "Pink")
            ImGui.TextColored({1.0, 1.0, 0.0, 1.0}, "Yellow")
            ImGui.TextDisabled("Disabled")
            ImGui.SameLine(); ShowHelpMarker("The TextDisabled color is stored in ImGuiStyle.")
            ImGui.TreePop()
        end

        if (ImGui.TreeNode("Word Wrapping")) then
            -- Using shortcut. You can use PushTextWrapPos()/PopTextWrapPos() for more flexibility.
            ImGui.TextWrapped("This text should automatically wrap on the edge of the window. The current implementation for text wrapping follows simple rules suitable for English and possibly other languages.")
            ImGui.Spacing()
           
            ImGui.SliderFloat("Wrap width", T_wrap_width, -20, 600, "%.0f")
            local wrap_width = T_wrap_width[1]
            
            ImGui.Text("Test paragraph 1:")
            
            local pos = ImGui.GetCursorScreenPos()
            ImGui.Drawlist.AddRectFilled({pos[1] + wrap_width, pos[2]}, {pos[1] + wrap_width + 10, pos[2] + ImGui.GetTextLineHeight()}, 0xff00ffff)
            
            
            ImGui.PushTextWrapPos(ImGui.GetCursorPos()[1] + wrap_width)
            ImGui.Text(string.format("The lazy dog is a good dog. This paragraph is made to fit within %.0f pixels. Testing a 1 character word. The quick brown fox jumps over the lazy dog.", wrap_width))
            ImGui.Drawlist.AddRect(ImGui.GetItemRectMin(), ImGui.GetItemRectMax(), 0xffff00ff)
            ImGui.PopTextWrapPos()

            ImGui.Text("Test paragraph 2:")
            pos = ImGui.GetCursorScreenPos()
            ImGui.Drawlist.AddRectFilled({pos[1] + wrap_width, pos[2]}, {pos[1] + wrap_width + 10, pos[2] + ImGui.GetTextLineHeight()}, 0xff00ffff)
            ImGui.PushTextWrapPos(ImGui.GetCursorPos()[1] + wrap_width)
            ImGui.Text("aaaaaaaa bbbbbbbb, c cccccccc,dddddddd. d eeeeeeee   ffffffff. gggggggg!hhhhhhhh")
            ImGui.Drawlist.AddRect(ImGui.GetItemRectMin(), ImGui.GetItemRectMax(), 0xffff00ff)
            ImGui.PopTextWrapPos()

            ImGui.TreePop()
        end
        
        if (ImGui.TreeNode("UTF-8 Text")) then
            -- UTF-8 test with Japanese characters
            -- (Needs a suitable font, try Noto, or Arial Unicode, or M+ fonts. Read misc/fonts/README.txt for details.)
            ImGui.TextWrapped("CJK text will only appears if the font was loaded.");
            ImGui.Text("Hiragana: \xe3\x81\x8b\xe3\x81\x8d\xe3\x81\x8f\xe3\x81\x91\xe3\x81\x93 (kakikukeko)") -- Normally we would use u8"blah blah" with the proper characters directly in the string.
            ImGui.Text("Kanjis: \xe6\x97\xa5\xe6\x9c\xac\xe8\xaa\x9e (nihongo)")
            ImGui.InputText("UTF-8 input",  str, 128)
            ImGui.TreePop()
        end
    end --func
end