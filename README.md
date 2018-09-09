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

## loadTexture2D
```lua
    tex2D loadTexture2D(string path)
```
　　Load a texture from path. 
<dl>
  <dt>path</dt>
  <dd>Path to the texture, relative to runtime directory.</dd>
</dl>

## loadPixelShader
```lua
    tex2D loadPixelShader(string path)
```
　　Load a pixel shader from path. 
<dl>
  <dt>path</dt>
  <dd>Path to the shader, relative to runtime directory.<br> See <b><code>Pixel Shader</code></b> for more detail.</dd>
</dl>

## loadConstBuffer
```lua
    tex2D loadConstBuffer(string path)
```
　　Create a constant buffer defined in pixel shader.
<dl>
  <dt>path</dt>
  <dd>Path to the shader file that defines the constant buffer layout, relative to runtime directory.<br> See <b><code>Pixel Shader</code></b> for more detail.</dd>
</dl>

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

# Pixel Shader 
　　Using pixel shaders in ImGui widgets allows user to draw complex items directly.

## basic layout:
```hlsl
// predef objects
sampler   pointSampler : register(s0);
sampler   linearSampler : register(s1);

cbuffer global : register(b0) {
    float2 ScreenSize; // Width, Height
}

// user objects
Texture2D myTex : register(t0);
//... up to t15

// LoadConstBuffer function will only look for register "b1".
// user can set the values of it from script through "Update()" method under const buffer object. 
cbuffer user : register(b1) {
    float param0;
    //...
}

// pixel shader, with fixed function name "ps_main" and input layout.
floa4 ps_main(float4 pos : SV_POSITION, float4 col : COLOR0, float2 uv : TEXCOORD0) : SV_Target {
    return 0.5;
}
```
