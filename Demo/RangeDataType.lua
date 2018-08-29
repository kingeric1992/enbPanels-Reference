local bit32 = require('bit')
local ImGui = require('ImGui')         

local Enum = ImGui.Enum

require('enbseries.scripts.Demo.Helper')

do
    local _begin = {10}
    local _end   = {90}
    
    local i_begin = {100}
    local i_end   = {1000}

    function Widgets_Range()
        ImGui.DragFloatRange2("range", _begin, _end, 0.25, 0.0, 100.0, "Min: %.1f %%", "Max: %.1f %%");
        ImGui.DragIntRange2("range int (no bounds)", i_begin, i_end, 5, 0, 0, "Min: %d units", "Max: %d units");
    end

    local s32_v = { -1 }
    local u32_v = { UI32(-1) }
    local f32_v = { 0.123 }
    local f64_v = { 90000.01234567890123456789 }
    
    local drag_clamp  = {false}
    local inputs_step = {true}
    
    function Widgets_DataType()
        -- The DragScalar/InputScalar/SliderScalar functions allow various data types: signed/unsigned int/long long and float/double
        -- To avoid polluting the public API with all possible combinations, we use the ImGuiDataType enum to pass the type,
        -- and passing all arguments by address.
        -- This is the reason the test code below creates local variables to hold "zero" "one" etc. for each types.
        -- In practice, if you frequently use a given type that is not covered by the normal API entry points, you can wrap it
        -- yourself inside a 1 line function which can take typed argument as value instead of void*, and then pass their address
        -- to the generic function. For example:
        --   bool MySliderU64(const char *label, u64* value, u64 min = 0, u64 max = 0, const char* format = "%lld")
        --   {
        --      return SliderScalar(label, ImGuiDataType_U64, value, &min, &max, format);
        --   }

        -- Limits (as helper variables that we can take the address of)
        -- Note that the SliderScalar function has a maximum usable range of half the natural type maximum, hence the /2 below.
        
        local INT_MIN  = -2147483648
        local INT_MAX  =  2147483647
        local UINT_MAX =  4294967295
        
        local  s32_zero, s32_one, s32_fifty, s32_min, s32_max, s32_hi_a, s32_hi_b = 0, 1, 50, INT_MIN/2, INT_MAX/2,  INT_MAX/2 - 100,  INT_MAX/2;
        local  u32_zero, u32_one, u32_fifty, u32_min, u32_max, u32_hi_a, u32_hi_b = 0, 1, 50, 0,         UINT_MAX/2, UINT_MAX/2 - 100, UINT_MAX/2;
        local  f32_zero, f32_one, f32_lo_a, f32_hi_a = 0, 1, -10000000000.0,      10000000000.0;
        local  f64_zero, f64_one, f64_lo_a, f64_hi_a = 0, 1, -1000000000000000.0, 1000000000000000.0;

        local drag_speed = 0.2;

        ImGui.Text("Drags:");
        ImGui.Checkbox("Clamp integers to 0..50", drag_clamp)
        ImGui.SameLine(); ShowHelpMarker("As with every widgets in dear imgui, we never modify values unless there is a user interaction.\nYou can override the clamping limits by using CTRL+Click to input a value.");
        ImGui.DragScalar("drag s32",       Enum['ImGuiDataType_S32'],    s32_v, drag_speed, BoolToNum(drag_clamp[1]) * s32_zero, BoolToNum(drag_clamp[1]) * s32_fifty);
        ImGui.DragScalar("drag u32",       Enum['ImGuiDataType_U32'],    u32_v, drag_speed, BoolToNum(drag_clamp[1]) * u32_zero, BoolToNum(drag_clamp[1]) * u32_fifty, "%u ms");
        ImGui.DragScalar("drag float",     Enum['ImGuiDataType_Float'],  f32_v, 0.005,  f32_zero, f32_one, "%f", 1.0);
        ImGui.DragScalar("drag float ^2",  Enum['ImGuiDataType_Float'],  f32_v, 0.005,  f32_zero, f32_one, "%f", 2.0);
        ImGui.SameLine(); ShowHelpMarker("You can use the 'power' parameter to increase tweaking precision on one side of the range.");
        ImGui.DragScalar("drag double",    Enum['ImGuiDataType_Double'], f64_v, 0.0005, f64_zero, nil,     "%.10f grams",   1.0);
        ImGui.DragScalar("drag double ^2", Enum['ImGuiDataType_Double'], f64_v, 0.0005, f64_zero, f64_one, "0 < %.10f < 1", 2.0);

        ImGui.Text("Sliders");
        ImGui.SliderScalar("slider s32 low",     Enum['ImGuiDataType_S32'],    s32_v, s32_zero, s32_fifty,"%d");
        ImGui.SliderScalar("slider s32 high",    Enum['ImGuiDataType_S32'],    s32_v, s32_hi_a, s32_hi_b, "%d");
        ImGui.SliderScalar("slider s32 full",    Enum['ImGuiDataType_S32'],    s32_v, s32_min,  s32_max,  "%d");
        ImGui.SliderScalar("slider u32 low",     Enum['ImGuiDataType_U32'],    u32_v, u32_zero, u32_fifty,"%u");
        ImGui.SliderScalar("slider u32 high",    Enum['ImGuiDataType_U32'],    u32_v, u32_hi_a, u32_hi_b, "%u");
        ImGui.SliderScalar("slider u32 full",    Enum['ImGuiDataType_U32'],    u32_v, u32_min,  u32_max,  "%u");
        ImGui.SliderScalar("slider float low",   Enum['ImGuiDataType_Float'],  f32_v, f32_zero, f32_one);
        ImGui.SliderScalar("slider float low^2", Enum['ImGuiDataType_Float'],  f32_v, f32_zero, f32_one,  "%.10f",      2.0);
        ImGui.SliderScalar("slider float high",  Enum['ImGuiDataType_Float'],  f32_v, f32_lo_a, f32_hi_a, "%e");
        ImGui.SliderScalar("slider double low",  Enum['ImGuiDataType_Double'], f64_v, f64_zero, f64_one,  "%.10f grams",1.0);
        ImGui.SliderScalar("slider double low^2",Enum['ImGuiDataType_Double'], f64_v, f64_zero, f64_one,  "%.10f",      2.0);
        ImGui.SliderScalar("slider double high", Enum['ImGuiDataType_Double'], f64_v, f64_lo_a, f64_hi_a, "%e grams",   1.0);

        ImGui.Text("Inputs");
        ImGui.Checkbox("Show step buttons", inputs_step);
        
        local input_step_s32, input_step_u32, input_step_f32, input_step_f64 = s32_one, u32_one, f32_one, f64_one
        if (not inputs_step[1]) then
            input_step_s32, input_step_u32, input_step_f32, input_step_f64 = nil, nil, nil, nil
        end
        
        ImGui.InputScalar("input s32",     Enum['ImGuiDataType_S32'],    s32_v, input_step_s32, nil, "%d");
        ImGui.InputScalar("input s32 hex", Enum['ImGuiDataType_S32'],    s32_v, input_step_s32, nil, "%08X", Enum['ImGuiInputTextFlags_CharsHexadecimal']);
        ImGui.InputScalar("input u32",     Enum['ImGuiDataType_U32'],    u32_v, input_step_u32, nil, "%u");
        ImGui.InputScalar("input u32 hex", Enum['ImGuiDataType_U32'],    u32_v, input_step_u32, nil, "%08X", Enum['ImGuiInputTextFlags_CharsHexadecimal']);
        ImGui.InputScalar("input float",   Enum['ImGuiDataType_Float'],  f32_v, input_step_f32);
        ImGui.InputScalar("input double",  Enum['ImGuiDataType_Double'], f64_v, input_step_f64);
    end
end