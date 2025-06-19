/*  XInput by Lexikos
   Tweaked to work without JSON for AHK 1.0, and for 8bitdo controler by OldVamp May 1 2022
*/

/*
Function: XInput_Init

Initializes XInput.ahk with the given XInput DLL.

Parameters:
dll     -   The path or name of the XInput DLL to load.
C:\Windows\System32\xinput1_3.dll
XInput_Init(dll="xinput1_3")
*/
XInput_Init(dll="xinput1_3")
{
    global
    if _XInput_hm
        return
    
    ;======== CONSTANTS DEFINED IN XINPUT.H ========
    
    ; NOTE: These are based on my outdated copy of the DirectX SDK.
    ;       Newer versions of XInput may require additional constants.
    
    ; Device types available in XINPUT_CAPABILITIES
    XINPUT_DEVTYPE_GAMEPAD          = 0x01
    
    ; Device subtypes available in XINPUT_CAPABILITIES
    XINPUT_DEVSUBTYPE_GAMEPAD       = 0x01
    
    ; Flags for XINPUT_CAPABILITIES
    XINPUT_CAPS_VOICE_SUPPORTED     = 0x0004
    
    ; Constants for gamepad buttons ; wbuttons
    XINPUT_GAMEPAD_DPAD_UP          = 0x0001 ; 1
    XINPUT_GAMEPAD_DPAD_DOWN        = 0x0002 ; 2
    XINPUT_GAMEPAD_DPAD_LEFT        = 0x0004 ; 4
    XINPUT_GAMEPAD_DPAD_RIGHT       = 0x0008 ; 8
    XINPUT_GAMEPAD_START            = 0x0010 ; 16
    XINPUT_GAMEPAD_SELECT           = 0x0020 ; 32    ; select
    XINPUT_GAMEPAD_LEFT_THUMB       = 0x0040 ; 64
    XINPUT_GAMEPAD_RIGHT_THUMB      = 0x0080 ; 128
    XINPUT_GAMEPAD_LEFT_SHOULDER    = 0x0100 ; 256
    XINPUT_GAMEPAD_RIGHT_SHOULDER   = 0x0200 ; 512
    XINPUT_GAMEPAD_A                = 0x1000 ; 4096  ; b on 8bitdo
    XINPUT_GAMEPAD_B                = 0x2000 ; 8192  ; a on 8bitdo
    XINPUT_GAMEPAD_X                = 0x4000 ; 16384 ; y on 8bitdo
    XINPUT_GAMEPAD_Y                = 0x8000 ; 32768 ; x on 8bitdo

    ; xinput returned array data
    XDATA_ARRAYLENGTH  = 0
    XDATA_PACKETNUMBER = 1
    XDATA_DPAD         = 2
    XDATA_LT           = 3
    XDATA_RT           = 4
    XDATA_LX           = 5
    XDATA_LY           = 6
    XDATA_RX           = 7
    XDATA_RY           = 8
    
    ; Gamepad thresholds
    XINPUT_GAMEPAD_LEFT_THUMB_DEADZONE  = 7849
    XINPUT_GAMEPAD_RIGHT_THUMB_DEADZONE = 8689
    XINPUT_GAMEPAD_TRIGGER_THRESHOLD    = 30
    
    ; Flags to pass to XInputGetCapabilities
    XINPUT_FLAG_GAMEPAD             = 0x00000001
    
    ;=============== END CONSTANTS =================
    
    _XInput_hm := DllCall("LoadLibrary", "str", dll)
    
    if !_XInput_hm
    {
        MsgBox, Failed to initialize XInput: %dll%.dll not found.
        return
    }

    stringtype := (A_IsUnicode?"astr":"str") ; fix ansi vs unicode
    _XInput_GetState        := DllCall("GetProcAddress", "uint", _XInput_hm, stringtype, "XInputGetState")
    _XInput_SetState        := DllCall("GetProcAddress", "uint", _XInput_hm, stringtype, "XInputSetState")
    _XInput_GetCapabilities := DllCall("GetProcAddress", "uint", _XInput_hm, stringtype, "XInputGetCapabilities")

    ;_XInput_GetState        := DllCall("GetProcAddress", "uint", _XInput_hm, "str", "XInputGetState")         ; ansi 32
    ;_XInput_SetState        := DllCall("GetProcAddress", "uint", _XInput_hm, "str", "XInputSetState")         ; ansi 32
    ;_XInput_GetCapabilities := DllCall("GetProcAddress", "uint", _XInput_hm, "str", "XInputGetCapabilities")  ; ansi 32

    ;_XInput_GetState        := DllCall("GetProcAddress", "uint", _XInput_hm, "astr", "XInputGetState")        ; unicode 64
    ;_XInput_SetState        := DllCall("GetProcAddress", "uint", _XInput_hm, "astr", "XInputSetState")        ; unicode 64
    ;_XInput_GetCapabilities := DllCall("GetProcAddress", "uint", _XInput_hm, "astr", "XInputGetCapabilities") ; unicode 64
    
    if !(_XInput_GetState && _XInput_SetState && _XInput_GetCapabilities)
    {
        XInput_Term()
        MsgBox, Failed to initialize XInput: function not found in dll.
        return
    }
} ;XInput_Init

/*
Function: XInput_GetState

Retrieves the current state of the specified controller.

Parameters:
UserIndex   -   [in] Index of the user's controller. Can be a value from 0 to 3.
State       -   [out] Receives the current state of the controller.

Returns:
If the function succeeds, the return value is ERROR_SUCCESS (zero).
If the controller is not connected, the return value is ERROR_DEVICE_NOT_CONNECTED (1167).
If the function fails, the return value is an error code defined in Winerror.h.
http://msdn.microsoft.com/en-us/library/ms681381.aspx

Remarks:
XInput.dll returns controller state as a binary structure:
http://msdn.microsoft.com/en-us/library/microsoft.directx_sdk.reference.xinput_state
http://msdn.microsoft.com/en-us/library/microsoft.directx_sdk.reference.xinput_gamepad
*/

XInput_GetState(UserIndex, ByRef State)
{
    global _XInput_GetState
    varsizeone := 16*(A_IsUnicode?2:1) ; fix ansi vs unicode
    VarSetCapacity(xiState,varsizeone)
    
    if ErrorLevel := DllCall(_XInput_GetState ,"uint",UserIndex ,"uint",&xiState)
        State =
    else
         /*
            PacketNumber
            Buttons ; binary
            Trigger Left  ; triggers 0-255
            Trigger Right
            ThumbL X ; thumbstick axis value. The value is between -32768 and 32767.
            ThumbL Y
            ThumbR X
            ThumbR Y
        */
        State := "
        ( C LTrim Join
            " NumGet(xiState, 0) ",
            " NumGet(xiState, 4,"UShort") ",
            " NumGet(xiState, 6, "UChar") ",
            " NumGet(xiState, 7, "UChar") ",
            " NumGet(xiState, 8, "Short") ",
            " NumGet(xiState,10, "Short") ",
            " NumGet(xiState,12, "Short") ",
            " NumGet(xiState,14, "Short") "
        )"
    
    return ErrorLevel
} ; XInput_GetState


/*
   button stuff by LinuxDolt
   XInputButtonIsDown
   XInputButtonState
*/

XInputButtonIsDown( ButtonName, ByRef bidButtonState )
{
   isDown := false  ; If something screws up, we want to return false.
   
   If ( bidButtonState & %ButtonName% )
      isDown := true  ; Return true if bidButtonState matches ButtonName
   Else isDown := false  ; Return false otherwise
   
   Return %isDown%
}

XInputButtonState( ByRef bsButtonState )
{
   Status := ""
   
   If XInputButtonIsDown( "XINPUT_GAMEPAD_A", bsButtonState )
      Status .= "B,"
   If XInputButtonIsDown( "XINPUT_GAMEPAD_B", bsButtonState )
      Status .= "A,"
   If XInputButtonIsDown( "XINPUT_GAMEPAD_X", bsButtonState )
      Status .= "Y,"
   If XInputButtonIsDown( "XINPUT_GAMEPAD_Y", bsButtonState )
      Status .= "X,"
   If XInputButtonIsDown( "XINPUT_GAMEPAD_LEFT_SHOULDER", bsButtonState )
      Status .= "LB,"
   If XInputButtonIsDown( "XINPUT_GAMEPAD_RIGHT_SHOULDER", bsButtonState )
      Status .= "RB,"
   If XInputButtonIsDown( "XINPUT_GAMEPAD_LEFT_THUMB", bsButtonState )
      Status .= "LTh,"
   If XInputButtonIsDown( "XINPUT_GAMEPAD_RIGHT_THUMB", bsButtonState )
      Status .= "RTh,"
   If XInputButtonIsDown( "XINPUT_GAMEPAD_SELECT", bsButtonState )
      Status .= "Select,"
   If XInputButtonIsDown( "XINPUT_GAMEPAD_START", bsButtonState )
      Status .= "Start,"
   If XInputButtonIsDown( "XINPUT_GAMEPAD_DPAD_UP", bsButtonState )
      Status .= "Up,"
   If XInputButtonIsDown( "XINPUT_GAMEPAD_DPAD_DOWN", bsButtonState )
      Status .= "Down,"
   If XInputButtonIsDown( "XINPUT_GAMEPAD_DPAD_LEFT", bsButtonState )
      Status .= "Left,"
   If XInputButtonIsDown( "XINPUT_GAMEPAD_DPAD_RIGHT", bsButtonState )
      Status .= "Right,"
   
   Return SubStr( Status, 1, -1 ) ; Omit the trailing comma
}
    
    /*
    Function: XInput_SetState
    
    Sends data to a connected controller. This function is used to activate the vibration
    function of a controller.
    
    Parameters:
    UserIndex       -   [in] Index of the user's controller. Can be a value from 0 to 3.
    LeftMotorSpeed  -   [in] Speed of the left motor, between 0 and 65535.
    RightMotorSpeed -   [in] Speed of the right motor, between 0 and 65535.
    
    Returns:
    If the function succeeds, the return value is 0 (ERROR_SUCCESS).
    If the controller is not connected, the return value is 1167 (ERROR_DEVICE_NOT_CONNECTED).
    If the function fails, the return value is an error code defined in Winerror.h.
    http://msdn.microsoft.com/en-us/library/ms681381.aspx
    
    Remarks:
    The left motor is the low-frequency rumble motor. The right motor is the
    high-frequency rumble motor. The two motors are not the same, and they create
    different vibration effects.
    */
    XInput_SetState(UserIndex, LeftMotorSpeed, RightMotorSpeed)
    {
        global _XInput_SetState
        return DllCall(_XInput_SetState, "uint", UserIndex, "uint*", LeftMotorSpeed|RightMotorSpeed<<16)
    }
    
    /*
    Function: XInput_GetCapabilities
    
    Retrieves the capabilities and features of a connected controller.
    
    Parameters:
    UserIndex   -   [in] Index of the user's controller. Can be a value in the range 0�3.
    Flags       -   [in] Input flags that identify the controller type.
    0   - All controllers.
    1   - XINPUT_FLAG_GAMEPAD: Xbox 360 Controllers only.
    Caps        -   [out] Receives the controller capabilities.
    
    Returns:
    If the function succeeds, the return value is 0 (ERROR_SUCCESS).
    If the controller is not connected, the return value is 1167 (ERROR_DEVICE_NOT_CONNECTED).
    If the function fails, the return value is an error code defined in Winerror.h.
    http://msdn.microsoft.com/en-us/library/ms681381.aspx
    
    Remarks:
    XInput.dll returns capabilities via a binary structure:
    http://msdn.microsoft.com/en-us/library/microsoft.directx_sdk.reference.xinput_capabilities
    XInput.ahk converts this structure to a JSON string.
    */
    XInput_GetCapabilities(UserIndex, Flags, ByRef Caps)
    {
        global _XInput_GetCapabilities
        varsizetwo := 20*(A_IsUnicode?2:1) ; fix ansi vs unicode
        VarSetCapacity(xiCaps, varsizetwo)
        
        if ErrorLevel := DllCall(_XInput_GetCapabilities, "uint", UserIndex, "uint", Flags, "uint", &xiCaps)
        Caps =
        else
        /*
         type
         subtype
         flags
         buttons
         LT ; triggers 0-255
         RT
         LX ; thumbstick axis value. The value is between -32768 and 32767.
         LY
         RX
         RY
         VibrationLeft ; Speed of the motor. Valid values are in the range 0 to 65,535. Zero signifies no motor use; 65,535 signifies 100 percent motor use
         VibrationRight
        */
            Caps := "{
            ( LTrim Join
            " NumGet(xiCaps,  0, "UChar")  ", 
            " NumGet(xiCaps,  1, "UChar")  ", 
            " NumGet(xiCaps,  2, "UShort") ", 
            " NumGet(xiCaps,  4, "UShort") ", 
            " NumGet(xiCaps,  6, "UChar")  ", 
            " NumGet(xiCaps,  7, "UChar")  ", 
            " NumGet(xiCaps,  8, "Short")  ", 
            " NumGet(xiCaps, 10, "Short")  ", 
            " NumGet(xiCaps, 12, "Short")  ", 
            " NumGet(xiCaps, 14, "Short")  ",
            " NumGet(xiCaps, 16, "UShort") ", 
            " NumGet(xiCaps, 18, "UShort") "
            )"
            
            return ErrorLevel
        }
        
        /*
        Function: XInput_Term
        Unloads the previously loaded XInput DLL.
        */
        XInput_Term()
        {
            global
            if _XInput_hm
                DllCall("FreeLibrary", "uint", _XInput_hm), _XInput_hm :=_XInput_GetState :=_XInput_SetState :=_XInput_GetCapabilities :=0
        }
        
        ; TODO: XInputEnable, 'GetBatteryInformation and 'GetKeystroke.