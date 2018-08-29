
--[[
    demo.lua
    
    note: 
        review ImGui.GetIO()
    
]]--
local bit32 = require('bit')
local ImGui = require('ImGui')

require('enbseries.scripts.Demo.Helper')
require('enbseries.scripts.Demo.Basic')
require('enbseries.scripts.Demo.Trees')
require('enbseries.scripts.Demo.CollapsingHeaders')
require('enbseries.scripts.Demo.Text')
require('enbseries.scripts.Demo.Image')
require('enbseries.scripts.Demo.Combo')
require('enbseries.scripts.Demo.Selectables')
require('enbseries.scripts.Demo.TextInput')
require('enbseries.scripts.Demo.Plots')
require('enbseries.scripts.Demo.ColorPicker')
require('enbseries.scripts.Demo.RangeDataType')
require('enbseries.scripts.Demo.MultiComponent')
require('enbseries.scripts.Demo.VerticalSliders')
require('enbseries.scripts.Demo.DragAndDrop')
require('enbseries.scripts.Demo.ItemState')

--short cuts
local Enum = ImGui.Enum

-- Examples Apps (accessible from the "Examples" menu)
local show_app_main_menu_bar      = {false}
local show_app_console            = {false}
local show_app_log                = {false}
local show_app_layout             = {false}
local show_app_property_editor    = {false}
local show_app_long_text          = {false}
local show_app_auto_resize        = {false}
local show_app_constrained_resize = {false}
local show_app_simple_overlay     = {false}
local show_app_window_titles      = {false}
local show_app_custom_rendering   = {false}

-- Dear ImGui Apps (accessible from the "Help" menu)
local show_app_metrics      = {false}
local show_app_style_editor = {false}
local show_app_about        = {false}

-- Demonstrate the various window flags. Typically you would just use the default!
-- array type
local no_titlebar   = {false}
local no_scrollbar  = {false}
local no_menu       = {false}
local no_move       = {false}
local no_resize     = {false}
local no_collapse   = {false}
local no_close      = {false}
local no_nav        = {false}

function ShowDemoWindow(p_open)

--[[
    if (show_app_main_menu_bar[1])      then ShowExampleAppMainMenuBar()                                  end
    if (show_app_console[1])            then ShowExampleAppConsole(          show_app_console)            end
    if (show_app_log[1])                then ShowExampleAppLog(              show_app_log)                end
    if (show_app_layout[1])             then ShowExampleAppLayout(           show_app_layout)             end
    if (show_app_property_editor[1])    then ShowExampleAppPropertyEditor(   show_app_property_editor)    end
    if (show_app_long_text[1])          then ShowExampleAppLongText(         show_app_long_text)          end
    if (show_app_auto_resize[1])        then ShowExampleAppAutoResize(       show_app_auto_resize)        end
    if (show_app_constrained_resize[1]) then ShowExampleAppConstrainedResize(show_app_constrained_resize) end
    if (show_app_simple_overlay[1])     then ShowExampleAppSimpleOverlay(    show_app_simple_overlay)     end
    if (show_app_window_titles[1])      then ShowExampleAppWindowTitles(     show_app_window_titles)      end
    if (show_app_custom_rendering[1])   then ShowExampleAppCustomRendering(  show_app_custom_rendering)   end
]]--    

    if (show_app_metrics[1])      then ImGui.ShowMetricsWindow(show_app_metrics) end
    if (show_app_style_editor[1]) then ImGui.Begin("Style Editor", show_app_style_editor); ImGui.ShowStyleEditor(); ImGui.End(); end
    
    if (show_app_about[1]) then 
        ImGui.Begin("About Dear ImGui", show_app_about, Enum['ImGuiWindowFlags_AlwaysAutoResize'])
-- not supporting ImGui fomat string, so we use lua native format string for conversion
        ImGui.Text(string.format("Dear ImGui, %s", ImGui.GetVersion()))
        ImGui.Separator()
        ImGui.Text("By Omar Cornut and all dear imgui contributors.")
        ImGui.Text("Dear ImGui is licensed under the MIT License, see LICENSE for more information.")
        ImGui.End()
    end
    
-- Demonstrate the various window flags. Typically you would just use the default!    
    local window_flags = 0
    if (no_titlebar[1])  then window_flags = bit32.bor(window_flags, Enum['ImGuiWindowFlags_NoTitleBar']  ) end
    if (no_scrollbar[1]) then window_flags = bit32.bor(window_flags, Enum['ImGuiWindowFlags_NoScrollbar'] ) end
    if (not no_menu[1])  then window_flags = bit32.bor(window_flags, Enum['ImGuiWindowFlags_MenuBar']     ) end
    if (no_move[1])      then window_flags = bit32.bor(window_flags, Enum['ImGuiWindowFlags_NoMove']      ) end
    if (no_resize[1])    then window_flags = bit32.bor(window_flags, Enum['ImGuiWindowFlags_NoResize']    ) end
    if (no_collapse[1])  then window_flags = bit32.bor(window_flags, Enum['ImGuiWindowFlags_NoCollapse']  ) end
    if (no_nav[1])       then window_flags = bit32.bor(window_flags, Enum['ImGuiWindowFlags_NoNav']       ) end
    if (no_close[1])     then p_open       = nil end -- Don't pass our bool* to Begin    (need to figure out this)

-- We specify a default position/size in case there's no data in the .ini file. 
-- Typically this isn't required! We only do it to make the Demo applications a little more welcoming.
    ImGui.SetNextWindowPos( {650, 20},  Enum['ImGuiCond_FirstUseEver']);
    ImGui.SetNextWindowSize({550, 680}, Enum['ImGuiCond_FirstUseEver']);

-- Main body of the Demo window starts here.
    if (not ImGui.Begin("ImGui Demo Lua", p_open, window_flags)) then -- Early out if the window is collapsed, as an optimization.
        ImGui.End()
    end
    ImGui.Text(string.format("dear imgui says hello. (%s)", ImGui.GetVersion()))
        
-- Most "big" widgets share a common width settings by default.
--  ImGui.PushItemWidth(ImGui.GetWindowWidth() * 0.65)    -- Use 2/3 of the space for widgets and 1/3 for labels (default)
    ImGui.PushItemWidth(ImGui.GetFontSize() * -12);       -- Use fixed width for labels (by passing a negative value), the rest goes to widgets. We choose a width proportional to our font size.
    
    --local testB = ImGui.BeginMainMenuBar()
    if (ImGui.BeginMenuBar()) then
        if (ImGui.BeginMenu("Menu")) then
            ShowExampleMenuFile()
            ImGui.EndMenu()
        end
        if (ImGui.BeginMenu("Examples")) then        
            ImGui.EndMenu()
        end
        if (ImGui.BeginMenu("Help")) then
            ImGui.MenuItem("Metrics",         nil, show_app_metrics)
            ImGui.MenuItem("Style Editor",    nil, show_app_style_editor)
            ImGui.MenuItem("About Dear ImGui",nil, show_app_about)
            ImGui.EndMenu()
        end
        ImGui.EndMenuBar()
    end
    ImGui.Spacing()
    

    if (ImGui.CollapsingHeader("Help")) then
        ImGui.TextWrapped("This window is being created by the ShowDemoWindow() function. Please refer to the code in demo.lua for reference.\n\n")
        ImGui.Text("USER GUIDE:")
        ImGui.ShowUserGuide()
    end
-- end of Help
    
    if (ImGui.CollapsingHeader("Window options")) then
        ImGui.Checkbox("No titlebar",  no_titlebar);   ImGui.SameLine(150)
        ImGui.Checkbox("No scrollbar", no_scrollbar);  ImGui.SameLine(300)
        ImGui.Checkbox("No menu",      no_menu);
        ImGui.Checkbox("No move",      no_move);       ImGui.SameLine(150)
        ImGui.Checkbox("No resize",    no_resize);     ImGui.SameLine(300)
        ImGui.Checkbox("No collapse",  no_collapse);
        ImGui.Checkbox("No close",     no_close);      ImGui.SameLine(150)
        ImGui.Checkbox("No nav",       no_nav);
        
        if (ImGui.TreeNode("Style")) then
            --ImGui.ShowStyleEditor()
            ImGui.TreePop()
        end
    end
-- end of Window options 

    if (ImGui.CollapsingHeader("Widgets")) then
        if (ImGui.TreeNode("Basic")) then   
            Widgets_Basic() 
            ImGui.TreePop()
        end
    
        if (ImGui.TreeNode("Trees")) then
            Widgets_Trees()
            ImGui.TreePop()
        end
        
        if (ImGui.TreeNode("Collapsing Headers")) then
            Widgets_CollapsingHeaders()
            ImGui.TreePop()
        end

        if (ImGui.TreeNode("Bullets")) then
            ImGui.BulletText("Bullet point 1")
            ImGui.BulletText("Bullet point 2\nOn multiple lines")
            ImGui.Bullet(); ImGui.Text("Bullet point 3 (two calls)")
            ImGui.Bullet(); ImGui.SmallButton("Button")
            ImGui.TreePop()
        end --Bullets
        
        if (ImGui.TreeNode("Text")) then
            Widgets_Text()
            ImGui.TreePop()
        end
        
        if (ImGui.TreeNode("Images")) then
            Widgets_Image()
            ImGui.TreePop()
        end

        if (ImGui.TreeNode("Combo")) then
            Widgets_Combo()
            ImGui.TreePop()
        end
        
        if (ImGui.TreeNode("Selectables")) then
            Widgets_Selectables()
            ImGui.TreePop()
        end
        
        if (ImGui.TreeNode("Filtered Text Input")) then
            Widgets_FilteredTextInput()
            ImGui.TreePop()
        end
        
        if (ImGui.TreeNode("Multi-line Text Input")) then
            --Widgets_MultilineTextInput()
            ImGui.TreePop()
        end
        
        if (ImGui.TreeNode("Plots Widgets")) then
            Widgets_Plots()
            ImGui.TreePop()
        end
        
        if (ImGui.TreeNode("Color/Picker Widgets")) then
            Widgets_ColorPicker()
            ImGui.TreePop()
        end
        
        if (ImGui.TreeNode("Range Widgets")) then
            Widgets_Range()
            ImGui.TreePop()
        end
        
        if (ImGui.TreeNode("Data Types")) then
            Widgets_DataType()
            ImGui.TreePop()
        end
        
        if (ImGui.TreeNode("Multi-component Widgets")) then
            Widgets_MultiComponent()
            ImGui.TreePop()
        end
        
        if (ImGui.TreeNode("Vertical Sliders")) then
            Widgets_VerticalSliders()
            ImGui.TreePop()
        end
        
        if (ImGui.TreeNode("Drag and Drop")) then
            Widgets_DragAndDrop()
            ImGui.TreePop()
        end
        
        if (ImGui.TreeNode("Active, Focused, Hovered & Focused Tests")) then
            Widgets_ItemState()
            ImGui.TreePop()
        end
    end
-- end of Widgets

    if (ImGui.CollapsingHeader("Layout")) then
    
    end
-- end of Layout

    if (ImGui.CollapsingHeader("Popups & Modal windows")) then
    
    end
-- end of Popups & Modal windows
    
    if (ImGui.CollapsingHeader("Columns")) then
    
    end
-- end of Columns

    if (ImGui.CollapsingHeader("Filtering")) then
    
    end
-- end of Filtering

    if (ImGui.CollapsingHeader("Inputs, Navigation & Focus")) then
    
    end
-- end of Inputs, Navigation & Focus
    
    ImGui.End()
end

local openDemo = {true};

function onENBCallback_EndFrame()
    if openDemo[1] then
        ShowDemoWindow(openDemo[1])
    end
    
    if (ImGui.IsKeyPressed(121, false)) then --f10
        if openDemo[1] then openDemo[1] = false
        else                openDemo[1] = true
        end
    end
end

function onENBCallback_BeginFrame()
end

function onDestroy()
end
