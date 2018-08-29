local bit32 = require('bit')
local ImGui = require('ImGui')         

local Enum = ImGui.Enum

require('enbseries.scripts.Demo.Helper')

do
    local animate       = { true }
    local func_type     = { 1 }
    local display_count = { 70 }
    
    local progress      = 0.0
    local progress_dir  = 1.0
    
    
    local values        = {  } --[90]
    local values_offset = 0
    local refresh_time  = 0.0
    local phase         = 0.0
    
    
    for i=1, 90 do
        values[i] = 0
    end

    local function Sin(data, idx) return math.sin(idx * 0.1) end
    local function Saw(data, idx) 
        if (bit32.band( idx, 1) > 0) then 
            return 1.0 
        else 
            return -1.0 
        end
    end
    
    function Widgets_Plots()
        ImGui.Checkbox("Animate", animate)

        local arr = { 0.6, 0.1, 1.0, 0.5, 0.92, 0.1, 0.2 }
        ImGui.PlotLines("Frame Times", arr, #arr)

        -- Create a dummy array of contiguous float values to plot
        -- Tip: If your float aren't contiguous but part of a structure, you can pass a pointer to your first float and the sizeof() of your structure in the Stride parameter.
        
        if ( not animate[1] or (refresh_time == 0.0)) then
            refresh_time = ImGui.GetTime()
        end
            
        while (refresh_time < ImGui.GetTime()) do -- Create dummy data at fixed 60 hz rate for the demo
            values[values_offset + 1] = math.cos(phase)
            values_offset = (values_offset + 1) % #values
            phase         = phase + 0.10 * values_offset
            refresh_time  = refresh_time + 1.0 / 60.0
        end
        
        ImGui.PlotLines(    "Lines",    values, #values, values_offset, "avg 0.0", -1.0, 1.0, { 0, 80})
        ImGui.PlotHistogram("Histogram", arr,   #arr,    0, "", 0.0, 1.0, { 0, 80 })

        -- Use functions to generate output
        -- FIXME: This is rather awkward because current plot API only pass in indices. We probably want an API passing floats and user provide sample rate/count.
        
        ImGui.Separator()
        ImGui.PushItemWidth(100); ImGui.Combo("func", func_type, "Sin\0Saw\0"); ImGui.PopItemWidth()
        ImGui.SameLine()
        
        ImGui.SliderInt("Sample count", display_count, 1, 400)
        
        local func = Sin
        if (func_type[1] == 1) then func = Saw end
        
        ImGui.PlotLines(    "Lines",     func, {}, display_count[1], 0, "", -1.0, 1.0, { 0.0, 80.0})
        ImGui.PlotHistogram("Histogram", func, {}, display_count[1], 0, "", -1.0, 1.0, { 0.0, 80.0})
        ImGui.Separator()


        -- Animate a simple progress bar
        
        if (animate[1]) then
            progress = progress + progress_dir * 0.4 * ImGui.GetIO().DeltaTime
            if (progress >=  1.1) then progress =  1.1; progress_dir = -1.0 * progress_dir; end
            if (progress <= -0.1) then progress = -0.1; progress_dir = -1.0 * progress_dir; end
        end

        -- Typically we would use { -1.0,0.0 } to use all available width, or { width, 0.0 } for a specified width. { 0.0, 0.0 } uses ItemWidth.
        ImGui.ProgressBar(progress, { 0.0, 0.0 })
        ImGui.SameLine(0.0, ImGui.GetStyleVar(Enum['ImGuiStyleVar_ItemInnerSpacing'])) -- lua will ditch second ret if it only has one slot
        ImGui.Text("Progress Bar")

        local progress_saturated = math.min(math.max(progress, 0.0), 1.0)
        ImGui.ProgressBar(progress, { 0, 0}, string.format("%d/%d", progress_saturated * 1753, 1753))
    end
end