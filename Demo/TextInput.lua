local bit32 = require('bit')
local ImGui = require('ImGui')         

local Enum = ImGui.Enum

require('enbseries.scripts.Demo.Helper')

do
    local buf  = { {""}, {""}, {""}, {""}, {""}, {""}}    
    local pass = {"password123"}
    
    --[[    
        ImGuiTextEditCallbackData = {
        --  fields:
            EventFlag,      -- (read_only int)  -- One of ImGuiInputTextFlags_Callback 
            Flags;          -- (read_only int)  -- What user passed to InputText()     
            UserData;       -- (read_only tbl)  -- What user passed to InputText()     
            ReadOnly;       -- (read_only bool)                 
            
        --  CharFilter event:
            EventChar;      -- (Read_write str) -- Character input

        --  Completion,History,Always events: (Mostly unchecked)
        --  If you modify the buffer contents make sure you update 'BufTextLen' and set 'BufDirty' to true.
            EventKey;       -- (Read-only  int) -- Key pressed (Up/Down/TAB) 
            Buf;            -- (Read-write str) -- Current text buffer
            BufTextLen;     -- (Read-write int) -- Current text length in bytes
            BufSize;        -- (Read-only  int) -- Maximum text length in bytes
            BufDirty;       -- (Write     bool) -- Mark for update
            CursorPos;      -- (Read-write int) 
            SelectionStart; -- (Read-write int) -- equal to SelectionEnd when no selection
            SelectionEnd;   -- (Read-write int)
        }    
    ]]--
    
    local function FilterImGuiLetters(ImGuiTextEditCallbackData)
        local ret = 1
        if (("i" == ImGuiTextEditCallbackData.EventChar) or
            ("m" == ImGuiTextEditCallbackData.EventChar) or
            ("g" == ImGuiTextEditCallbackData.EventChar) or
            ("u" == ImGuiTextEditCallbackData.EventChar) or
            ("i" == ImGuiTextEditCallbackData.EventChar)) then
            ret = 0
        end
        return ret
    end
    
    function Widgets_FilteredTextInput()
        ImGui.InputText("default",           buf[1], 64)
        ImGui.InputText("decimal",           buf[2], 64, Enum['ImGuiInputTextFlags_CharsDecimal'])
        ImGui.InputText("hexadecimal",       buf[3], 64, bit32.bor(Enum['ImGuiInputTextFlags_CharsHexadecimal'], Enum['ImGuiInputTextFlags_CharsUppercase']))
        ImGui.InputText("uppercase",         buf[4], 64, Enum['ImGuiInputTextFlags_CharsUppercase'])
        ImGui.InputText("no blank",          buf[5], 64, Enum['ImGuiInputTextFlags_CharsNoBlank'])
        ImGui.InputText("\"imgui\" letters", buf[6], 64, Enum['ImGuiInputTextFlags_CallbackCharFilter'], FilterImGuiLetters)

        ImGui.Text("Password input")
        ImGui.InputText("password", pass, 64, bit32.bor(Enum['ImGuiInputTextFlags_Password'], Enum['ImGuiInputTextFlags_CharsNoBlank']))
        ImGui.SameLine(); ShowHelpMarker("Display all characters as '*'.\nDisable clipboard cut and copy.\nDisable logging.\n")
        ImGui.InputText("password (clear)", pass, 64, Enum['ImGuiInputTextFlags_CharsNoBlank'])
    end
    
    local read_only = {false}
    local text      = { "/*\n"..
            " The Pentium F00F bug, shorthand for F0 0F C7 C8,\n"..
            " the hexadecimal encoding of one offending instruction,\n"..
            " more formally, the invalid operand with locked CMPXCHG8B\n"..
            " instruction bug, is a design flaw in the majority of\n"..
            " Intel Pentium, Pentium MMX, and Pentium OverDrive\n"..
            " processors (all in the P5 microarchitecture).\n"..
            "*/\n\n".."label:\n"..
            "\tlock cmpxchg8b eax\n"}
    
    function Widgets_MultilineTextInput()
        ImGui.PushStyleVar(Enum['ImGuiStyleVar_FramePadding'], { 0.0, 0.0})
        ImGui.Checkbox("Read-only", read_only)
        ImGui.PopStyleVar()
        
        local flag = Enum['ImGuiInputTextFlags_AllowTabInput']
        if read_only[1] then
            flag = bit32.bor(flag, Enum['ImGuiInputTextFlags_ReadOnly']);
        end
        ImGui.InputTextMultiline("##source", text, 1024*16, { -1.0, ImGui.GetTextLineHeight() * 16}, flag)
    end
end