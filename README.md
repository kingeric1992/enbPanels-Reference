# About enbPanels
　　enbPanels is a enbseries plugin that comes with a Lua script VM (LuaJIT) that allows user to program their own custom UI that access ENB parameters and more.

# enbPanels-Reference
list of enbPanels supported function

# Callbacks
```lua
function onDestroy()
```
　　Invoked when the script is reloaded or on game exit.
```lua
function onENBCallback_BeginFrame()
```
　　Invoked when the frame just drawn.
```lua
function onENBCallback_EndFrame()
```
　　Invoked when runtime is about to draw the frame.
```lua
function onENBCallback_PreReset()
```
　　Invoked when the frame object is about to be destroy. (alt-tab from fullscreen or exit)
```lua
function onENBCallback_PostReset()
```
　　Invoked when the frame object is recovered. (alt-tab from fullscreen or app launched)
```lua
function onENBCallback_PreSave()
```
　　Invoked when enb save button is pressed, but before enb write to config.
```lua
function onENBCallback_PostLoad()
```
　　Invoked when enb load button is pressed, and after enb read the config.
  
# 'ENB' module
## GetSDKVersion
``` lua
    number GetSDKVersion()
```
　　Return version number of exported enbseries sdk.

## GetVersion
``` lua
    number GerVersion()
```
　　Return version number of active enbseries dll.

## GetGameIdentifier
``` lua
    string GetGameIdentifier() 
```
　　Return unique GameID of the runtime.
..* SkyrimSE: "0x10000002"
..* Fallout4: "0x10000006"

## IsEditorActive
```lua
    bool IsEditorActive()
```
　　Return true if enb GUI is opened.
  
## IsEffectsWndActive
```lua
    bool IsEffectsWndActive()
```
　　Return true if enb shader effects window is opened.

## GetScreenSize
```lua
    number ScreenX, number ScreenY = GetScreenSize()
```
　　Return the screen dimension.
<dl>
  <dt>ScreenX</dt>
  <dd>Horizontal pixel count.</dd>

  <dt>ScreenY</dt>
  <dd>Vertical pixel count.</dd>
</dl>

## Set###
```lua
    bool SetTex(        string filename, string section, string keyname, tex    val)
    bool SetBool(       string filename, string section, string keyname, bool   val)
    bool SetInt(        string filename, string section, string keyname, int    val)
    bool SetFloat(      string filename, string section, string keyname, float  val)
    bool SetColorRGB(   string filename, string section, string keyname, table  val)
    bool SetColorRGBA(  string filename, string section, string keyname, table  val)
    bool SetSetVector3( string filename, string section, string keyname, table  val)
```
　　Return true if succeseed.
<dl>
  <dt>filename</dt>
  <dd>Is something people use sometimes.</dd>

  <dt>section</dt>
  <dd>If　<i>filename</i>　is set to <b>"enbseries.ini"</b>, section can be one of the section name listed insides <b>"enbseries.ini"</b><br>
  If　<i>filename</i>　is set to <b>""</b>, section can be one of the shader name.<br> 
  In either case, the string have to be all caps. ie: <b>"ENBEFFECT.FX"</b>, <b>"EFFECT"</b></dd>
  
  <dt>keyname</dt>
  <dd>the <b>"UIName"</b> set inside shader variable annotation</dd>
  
  <dt>val</dt>
  <dd>Values to be set. For <i>SetColorRGB</i>, <i>SetColorRGBA</i>, and <i>SetSetVector3</i>, <br>
    value input has to be a table array of respective size. ie: {0.1, 1.2, -0.7} </dd>
</dl>

## GetParameter
```lua
    bool GetParameter( string filename, string section, string keyname, table  val )
```
　　Return true if succeeded.
<dl>
  <dt>filename</dt>
  <dd>Refer to <i>Set###</i> for details.</dd>

  <dt>section</dt>
  <dd>Refer to <i>Set###</i> for details.</dd>
  
  <dt>keyname</dt>
  <dd>Refer to <i>Set###</i> for details.</dd>
  
  <dt>val</dt>
  <dd>Values retrieved. For multi component types, the additional component will be assign to respective slot in the table array.</dd>
</dl>

# 'Plugin' module
## MACROS
<p>
　<b><code>_PATH</code></b>　　　full path to the plugin<br>
　<b><code>_NAME</code></b>　　　name of the plugin<br>
　<b><code>_DIR</code></b>　　　　plugin directory<br>
　<b><code>_VERSION</code></b>　　plugin version<br>
</p>

## createTexture2D
```lua
    tex2D createTexture2D(string path)
    tex2D createTexture2D(string name)
    tex2D createTexture2D(int x, int y, format fmt)
```
　　Load a texture from path, by global name, or create a read/write texture by size and format. 
<dl>
  <dt>path</dt>
  <dd>Path to the texture, relative to runtime directory.</dd>
  <dt>name</dt>
  <dd>Name of a predefined global tex resource. ie. TEX_FRAMEBUFFER</dd>
  <dt>x</dt>
  <dd>width of newly created texture</dd>
  <dt>y</dt>
  <dd>height of newly created texture</dd>
  <dt>fmt</dt>
  <dd>format of newly created texture. See <b><code>DXGI_FORMAT</code><b> for supported format</dd>
</dl>

## createPixelShader
```lua
    shader createPixelShader(string name)
    shader createPixelShader(string path, string entryPoint)
```
　　Load a pixel shader from path and entry point, or by global name.
<dl>
  <dt>path</dt>
  <dd>Path to the shader, relative to runtime directory.<br> See <b><code>Pixel Shader</code></b> for more detail.</dd>
  <dt>entryPoint</dt>
  <dd>Program entry point for the shader obj.</dd>
  <dt>name</dt>
  <dd>Name of a predefined global shader resource. ie. PS_LOD</dd>
</dl>
  Constant Buffer is shared between shader programes that created from the same file.

## createRenderState
```lua
    rState createRenderState(opt shader ps)
    rState createRenderState(table tex, opt shader ps)
```
　　Create a render state object from graphic resources.
<dl>
  <dt>ps</dt>
  <dd>pixel shader assigned to the render state</dd>
  <dt>tex</dt>
  <dd>table of tex2D objects assigned to the render state. support up to 16 tex2Ds</dd>
</dl>

## getConfig
```lua
    config getConfig()
    config getConfig(string path)
```
    Load or create new config file at path.
<dl>
  <dt>path</dt>
  <dd>Absolute path to the config file, or path relative to game directory.</dd>
</dl>    
    When called without arguments, returns master config "enbseries/enbPanels.ini".
    
# tex2D
　　texture object for either ENB or ImGui RenderState.
## Methods###
```lua
    Active(); -- forced lua VM not to delete the obj in current scope.
    Update(); -- update the texture content if it support write.
```  
example usage:
```
local ENB   = require "ENB"
local ImGui = require "ImGui"
local Plugin = require "Plugin"

-- create a rw 1x64 R8_UNORM texture
local intTex = Plugin.createTexture2D( 1, 64, DXGI_FORMAT["DXGI_FORMAT_R8_UNORM"])

-- assign intTex to ENB
ENB.SetTex("ENBEFFECTPOSTPASS.FX", "dynamicTexture", intTex)
   
function onENBCallback_EndFrame()
    intTex:Active() -- keeps the object alive.
    
    ImGui.Begin("demoWnd")
    if( ImGui.SliderFloat("gradient", wLevel, 0, 1)) then 
        for i=1, 64 do intMem[i] = math.min(1.0, ((i - 1)/63.0) / wLevel[1]) end
        intTex:Update(intMem); -- cpu updates intTex 
    end
    ImGui.End()
end
```
## Supported Formats ###
```lua
4-components:
  DXGI_FORMAT_R32G32B32A32_FLOAT
  DXGI_FORMAT_R32G32B32A32_UINT
  DXGI_FORMAT_R32G32B32A32_SINT
  DXGI_FORMAT_R16G16B16A16_FLOAT
  DXGI_FORMAT_R16G16B16A16_UNORM
  DXGI_FORMAT_R16G16B16A16_UINT
  DXGI_FORMAT_R16G16B16A16_SNORM
  DXGI_FORMAT_R16G16B16A16_SINT
  DXGI_FORMAT_R10G10B10A2_UNORM
  DXGI_FORMAT_R10G10B10A2_UINT
  DXGI_FORMAT_R8G8B8A8_UNORM
  DXGI_FORMAT_R8G8B8A8_UNORM_SRGB
  DXGI_FORMAT_R8G8B8A8_UINT
  DXGI_FORMAT_R8G8B8A8_SNORM
  DXGI_FORMAT_R8G8B8A8_SINT
3-components:
  DXGI_FORMAT_R32G32B32_FLOAT
  DXGI_FORMAT_R32G32B32_UINT
  DXGI_FORMAT_R32G32B32_SINT
  DXGI_FORMAT_R11G11B10_FLOAT
2-components:
  DXGI_FORMAT_R32G32_FLOAT
  DXGI_FORMAT_R32G32_UINT
  DXGI_FORMAT_R32G32_SINT
  DXGI_FORMAT_R16G16_FLOAT
  DXGI_FORMAT_R16G16_UNORM
  DXGI_FORMAT_R16G16_UINT
  DXGI_FORMAT_R16G16_SNORM
  DXGI_FORMAT_R16G16_SINT
  DXGI_FORMAT_R8G8_UNORM
  DXGI_FORMAT_R8G8_UINT
  DXGI_FORMAT_R8G8_SNORM
  DXGI_FORMAT_R8G8_SINT
1-component:
  DXGI_FORMAT_R32_FLOAT
  DXGI_FORMAT_R32_UINT
  DXGI_FORMAT_R32_SINT
  DXGI_FORMAT_R16_FLOAT
  DXGI_FORMAT_R16_UNORM
  DXGI_FORMAT_R16_UINT
  DXGI_FORMAT_R16_SNORM
  DXGI_FORMAT_R16_SINT
  DXGI_FORMAT_R8_UNORM
  DXGI_FORMAT_R8_UINT
  DXGI_FORMAT_R8_SNORM
  DXGI_FORMAT_R8_SINT
```

# shader
　　shader object for ImGui RenderState.
## Methods###
```lua
    Active(); -- forced lua VM not to delete the obj in current scope.
    Update(); -- update the cBuffer bound to the shader object.
```  

## basic layout of shader file:
```hlsl
// predef objects
sampler   pointSampler : register(s0);
sampler   linearSampler : register(s1);

cbuffer global : register(b0) {
    float2 ScreenSize; // Width, Height
}

//this can be updated by shaderObj:Update();
cbuffer user : register(b1) {
    float userVal0;
    float3 userVal1;
}

//tex2D objects assigned to renderState object
Texture2D myTex : register(t0);
//... up to t15

// LoadConstBuffer function will only look for register "b1".
// user can set the values of it from script through "Update()" method under const buffer object. 
cbuffer user : register(b1) {
    float param0;
    //...
}

// pixel shader, with entry point "ps_main" and input layout.
floa4 ps_main(float4 pos : SV_POSITION, float4 col : COLOR0, float2 uv : TEXCOORD0) : SV_Target {
    return 0.5;
}
```

# renderState
  renderState object for ImGui widgets.
## Methods ###
```lua
  Active(); -- forced lua VM not to delete the obj in current scope.
```
## Members ###
```lua
  tex -- table of tex2D objects
  ps -- shader object
```

# config
  config object for saving or loading presets.
## Methods###
```lua
    Read(); -- read from config file.
    Write(); -- write to config file.
    GetFloat(string sec, string key); -- retreive float by section and key
    GetInt(string sec, string key); -- retreive integer by section and key
    GetString(string sec, string key); -- retreive string by section and key
    GetBool(string sec, string key); -- retreive boolean by section and key
    
    local str_val = ConfigObj.Section.Key; -- retreive string value by section and key
    ConfigObj.Section.Key = str_val; -- assign string value to specified section and key
    ConfigObj.Section = {}; -- assign table of key-value pair to section.
```

# 'Runtime' module
## MACROS
<p>
　<b><code>_PATH</code></b>　　　full path to the runtime<br>
　<b><code>_NAME</code></b> 　　name of the runtime<br>
　<b><code>_DIR</code></b>　　　runtime directory<br>
　<b><code>_VERSION</code></b>　runtime version<br>
</p>

## Set###
```lua
    SetOffsetFloat( string rel_addr, number val_float)
    SetOffsetFloat( string rel_addr, table  tbl_float)
    SetFloat(       string abs_addr, number val_float)
    SetFloat(       string abs_addr, table  tbl_float)
    
    SetOffsetBool(  string rel_addr, bool   val_bool)
    SetOffsetBool(  string rel_addr, table  tbl_bool)
    SetBool(        string abs_addr, bool   val_bool)
    SetBool(        string abs_addr, table  tbl_bool)
    
    SetOffsetInt(   string rel_addr, int    val_int)
    SetOffsetInt(   string rel_addr, table  tbl_int)
    SetInt(         string abs_addr, int    val_int)
    SetInt(         string abs_addr, table  tbl_int)
    
    SetOffsetAOB(   string rel_addr, string val_aob)
    SetOffsetAOB(   string rel_addr, table  tbl_aob)
    SetAOB(         string abs_addr, string val_aob)
    SetAOB(         string abs_addr, table  tbl_aob)
    
    SetOffsetPtr(   string rel_addr, string val_ptr)
    SetOffsetPtr(   string rel_addr, table  tbl_ptr)
    SetPtr(         string abs_addr, string val_ptr)
    SetPtr(         string abs_addr, table  tbl_ptr)
```
　　Set value to runtime offset address.
<dl>
  <dt>rel_addr</dt>
  <dd>String representation of the offset address that will be written by the function. ie: <b>"0x02F6284C"</b> </dd>
  <dt>abs_addr</dt>
  <dd>String representation of the absolute address that will be written by the function. ie: <b>"0x02F6284C"</b> </dd>
  <dt>val_float</dt>
  <dd>Number to write to the address.</dd>
  <dt>val_bool</dt>
  <dd>Boolean to write to the address.</dd>
  <dt>val_int</dt>
  <dd>Integer to write to the address.</dd>
  <dt>val_aob</dt>
  <dd>String representation of a byte to write to the address. ie: <b>"0xC0"</b></dd>
  <dt>val_ptr</dt>
  <dd>String representation of a pointer(8 bytes) to write to the address. ie: <b>"0x0015477AC"</b></dd>
  <dt>tbl_###</dt>
  <dd>Table array input of respective type.</dd>
</dl>

## Get###
```lua
    number GetOffsetFloat( string rel_addr)
    table  GetOffsetFloat( string rel_addr, int len)
    number GetFloat(       string abs_addr)
    table  GetFloat(       string abs_addr, int len)
    
    bool   GetOffsetBool(  string rel_addr)
    table  GetOffsetBool(  string rel_addr, int len)
    bool   GetBool(        string abs_addr)
    table  GetBool(        string abs_addr, int len)
    
    int    GetOffsetInt(   string rel_addr)
    table  GetOffsetInt(   string rel_addr, int len)
    int    GetInt(         string abs_addr)
    table  GetInt(         string abs_addr, int len)
    
    string GetOffsetAOB(   string rel_addr)
    table  GetOffsetAOB(   string rel_addr, int len)
    string GetAOB(         string abs_addr)
    table  GetAOB(         string abs_addr, int len)
    
    string GetOffsetPtr(   string rel_addr)
    table  GetOffsetPtr(   string rel_addr, int len)
    string GetPtr(         string abs_addr)
    table  GetPtr(         string abs_addr, int len)
```
　　Retreive value from runtime offset address.
<dl>
  <dt>rel_addr</dt>
  <dd>String representation of the offset address that the function will retrieve its value from. ie: <b>"0x02F6284C"</b> </dd>
  <dt>abs_addr</dt>
  <dd>String representation of the absolute address that the function will retrieve its value from. ie: <b>"0x02F6284C"</b> </dd>
  <dt>len</dt>
  <dd>Number of elements to retrieve.</dd>
</dl>

# 'ImGui' module


