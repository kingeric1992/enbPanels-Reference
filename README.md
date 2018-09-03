# enbPanels-Reference
list of enbPanels supported function

# The basic layout


# The 'ENB' module


| methods | return type                   | description |
| ------------- | ------------------------------| ----------- |
| GetSDKVersion() | number | version number of exported enbseries sdk |
| GetVersion()    | number | version number of enbseries dll |
| GetGameIdentifier() | string | unique GameID; SkyrimSE["0x10000002"]; Fallout4["0x10000006"]|
| IsEditorActive()| bool | return true if enb GUI is opened |
| IsEffectsWndActive()| bool | return true if enb shader effects window is opened |

### Set###
return true if succeseed.
```
    bool SetTex(       string filename, string section, string keyname, tex    val)
    bool SetBool(      string filename, string section, string keyname, bool   val)
    bool SetInt(       string filename, string section, string keyname, int    val)
    bool SetFloat(     string filename, string section, string keyname, float  val)
    bool SetColorRGB(  string filename, string section, string keyname, table  val)
    bool SetColorRGBA( string filename, string section, string keyname, table  val)
    bool SetSetVector3(string filename, string section, string keyname, table  val)
```

<dl>
  <dt>filename</dt>
  <dd>Is something people use sometimes.</dd>

  <dt>section</dt>
  <dd>If　<i><b>filename</b></i>　is set to <b>"enbseries.ini"</b>, section can be one of the section name listed insides <b>"enbseries.ini"</b><br>
  If　<i><b>filename</b></i>　is set to <b>""</b>, section can be one of the shader name.<br> 
  In either case, the string have to be all caps. ie: <b>"ENBEFFECT.FX"</b>, <b>"EFFECT"</b></dd>
  
  <dt>keyname</dt>
  <dd>the "UIName" set inside shader variable annotation</dd>
</dl>

