local ENB   = require "ENB"
local ImGui = require('ImGui')

local extTex        = loadTexture2D("enbseries/scripts/img/testImg0.png")
local extPs         = loadPixelShader("enbseries/scripts/ps/testPs.ps")
local extRenderData = ImGui.CreateImRenderData() --ImRenderData
extRenderData.ps    = extPs
extRenderData.tex1  = extTex
extRenderData.count = 1

local isOpened = {true}


local function FixedRatio(data) 
    local size_in  = data.CurrentSize
    local size_out = {
        math.max(data.DesiredSize[1], data.DesiredSize[2] * 2.0),
        math.max(data.DesiredSize[1] * 0.5, data.DesiredSize[2])
    }
    -- call ImGui. window functions here can also set other window attribute
    
    return size_out --return the target size
end

function onENBCallback_EndFrame()
    
    ImGui.SetNextWindowSizeConstraints({0, 200}, {600, 600}, FixedRatio) 
    if( ImGui.Begin("Game Address", isOpened, ImGui.Enum['ImGuiWindowFlags_NoTitleBar'], extRenderData) ) then
        ImGui.Text(string.format("x, y = {%d, %d}", extTex.x, extTex.y))
    end
        ImGui.End()
end