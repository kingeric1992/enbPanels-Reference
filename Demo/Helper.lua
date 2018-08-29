
local bit32 = require('bit')
local ImGui = require('ImGui')  
local ffi   = require("ffi")


local Enum = ImGui.Enum 

function ShowHelpMarker(text_content)
    ImGui.TextDisabled("(?)")
    if (ImGui.IsItemHovered()) then
        ImGui.BeginTooltip()
        ImGui.PushTextWrapPos(ImGui.GetFontSize() * 35.0)
        ImGui.TextUnformatted(text_content)
        ImGui.PopTextWrapPos()
        ImGui.EndTooltip()
    end
end

function BoolToNum(bool)
    return bool and 1 or 0
end

-- enforce type range
function I32(sint)
    return math.max(math.min(sint, 2147483647), -2147483648)
end

function UI32(sint)
    sint = I32(sint)
    if     sint < 0 then sint = 4294967295 + 1 - sint end
    return sint
end

do

    local enabled = {true}
    local f       = {0.5}
    local n       = {0}
    local b       = {true}

    function ShowExampleMenuFile()
        ImGui.MenuItem("(dummy menu)", nil, false, false)
        if (ImGui.MenuItem("New")) then end
        if (ImGui.MenuItem("Open", "Ctrl+O")) then end
        if (ImGui.BeginMenu("Open Recent"))
        then
            ImGui.MenuItem("fish_hat.c")
            ImGui.MenuItem("fish_hat.inl")
            ImGui.MenuItem("fish_hat.h")
            if (ImGui.BeginMenu("More..")) 
            then
                ImGui.MenuItem("Hello")
                ImGui.MenuItem("Sailor")
                if (ImGui.BeginMenu("Recurse.."))
                then
                    ShowExampleMenuFile()
                    ImGui.EndMenu()
                end
                ImGui.EndMenu()
            end
            ImGui.EndMenu()
        end
        if (ImGui.MenuItem("Save", "Ctrl+S")) then end
        if (ImGui.MenuItem("Save As..")) then end
        ImGui.Separator()
        if (ImGui.BeginMenu("Options"))
        then
            ImGui.MenuItem("Enabled", "", enabled)
            ImGui.BeginChild("child", {0, 60}, true)
            for i = 0, 9 do
                ImGui.Text(string.format("Scrolling Text %d", i))
            end
            ImGui.EndChild()
            ImGui.SliderFloat("Value", f, 0.0, 1.0)
            ImGui.InputFloat( "Input", f, 0.1)
            ImGui.Combo(      "Combo", n, "Yes\0No\0Maybe\0\0")
            ImGui.Checkbox(   "Check", b)
            ImGui.EndMenu()
        end
        if (ImGui.BeginMenu("Colors"))
        then
            local sz = ImGui.GetTextLineHeight()
            for i = 0, Enum['ImGuiCol_COUNT'] - 1
            do
                local name   = ImGui.GetStyleColorName(i)
                local Px, Py = ImGui.GetCursorScreenPos()
                ImGui.Drawlist.AddRectFilled({Px, Py}, {Px+sz, Py+sz}, ImGui.GetColorU32(i))
                ImGui.Dummy({sz, sz})
                ImGui.SameLine()
                ImGui.MenuItem(name)
            end
            ImGui.EndMenu()
        end
        if (ImGui.BeginMenu("Disabled", false)) -- Disabled
        then
        end
        if (ImGui.MenuItem("Checked", nil, true)) then end
        if (ImGui.MenuItem("Quit", "Alt+F4")) then end    
    end
end