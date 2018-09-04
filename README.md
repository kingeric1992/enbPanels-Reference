# enbPanels-Reference
list of enbPanels supported function

# The basic layout


# The 'ENB' module
### GetSDKVersion
``` 
    number GetSDKVersion()
```
　　Return version number of exported enbseries sdk.

### GetVersion
``` 
    number GerVersion()
```
　　Return version number of active enbseries dll.

### GetGameIdentifier
``` 
    string GetGameIdentifier() 
```
　　Return unique GameID of the runtime.
..* SkyrimSE: "0x10000002"
..* Fallout4: "0x10000006"

### IsEditorActive
```
    bool IsEditorActive()
```
　　Return true if enb GUI is opened.
  
### IsEffectsWndActive
```
    bool IsEffectsWndActive()
```
　　Return true if enb shader effects window is opened.

### GetScreenSize
```
    number ScreenX, number ScreenY = GetScreenSize()
```
　　Return the screen dimension.
<dl>
  <dt>ScreenX</dt>
  <dd>Horizontal pixel count.</dd>

  <dt>ScreenY</dt>
  <dd>Vertical pixel count.</dd>
</dl>

### Set###
```
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

### GetParameter
```
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
