#Include, XinputCSV.ahk
#SingleInstance Force
XInput_Init()
; ****************************************** config ******************************************

; If your system has more than one joystick, increase this value to use a joystick other than the first: 0-3
JoystickNumber = 0

; deadzone, positive number ; max 32766
JoyLThreshold = 1500
JoyRThreshold = 1500

; speed setting
LeftSlow := 32766 / 32 ; 500
RightSlow := 32766 / 4 ; 2000

; axis fix
InvertX := false
InvertY := true

; Mouse buttons, see Below for list of Constants for gamepad buttons
ButtonLeftA   := "XINPUT_GAMEPAD_LEFT_SHOULDER"  ;L1
ButtonLeftB   := "XINPUT_GAMEPAD_RIGHT_THUMB"    ;right thumb/paddle
ButtonMiddleA := "XINPUT_GAMEPAD_SELECT"         ;Select
ButtonMiddleB := ""
ButtonRightA  := "XINPUT_GAMEPAD_RIGHT_SHOULDER" ;R1
ButtonRightB  := ""

; Dpad scroll interval
ScrollInterval = 100

; Constants for gamepad buttons
; XINPUT_GAMEPAD_DPAD_UP   
; XINPUT_GAMEPAD_DPAD_DOWN 
; XINPUT_GAMEPAD_DPAD_LEFT 
; XINPUT_GAMEPAD_DPAD_RIGHT
; XINPUT_GAMEPAD_START          ; start
; XINPUT_GAMEPAD_SELECT         ; select
; XINPUT_GAMEPAD_LEFT_THUMB    
; XINPUT_GAMEPAD_RIGHT_THUMB   
; XINPUT_GAMEPAD_LEFT_SHOULDER 
; XINPUT_GAMEPAD_RIGHT_SHOULDER
; XINPUT_GAMEPAD_A              ; b on 8bitdo
; XINPUT_GAMEPAD_B              ; a on 8bitdo
; XINPUT_GAMEPAD_X              ; y on 8bitdo
; XINPUT_GAMEPAD_Y              ; x on 8bitdo

; ****************************************** variables ******************************************

LeftIsDown := false
MiddleIsDown := false
RightIsDown := false

EnableMouse := true

; ****************************************** main loop ******************************************
Hotkey , ^[, DoNothing ; keeps the loop running, control + square brace
;set sub routeine timers
SetTimer, JoystickMove, 10 ; Monitor the movement of the joystick.
SetTimer, MouseClicker, 10 ; moniter buttons for mouse clicks
SetTimer, DpadScroll, %ScrollInterval% ; moniter buttons for page scrolling
return  ; End of auto-execute section.
; ****************************************** end main loop ******************************************

DoNothing:
; keeps the loop running
return

LeftClickDown()
{
    ; left mousedown
    global LeftIsDown := true
    SetMouseDelay, -1  ; Makes movement smoother.
    MouseClick, left, , , 1, 0, D  ; Hold down the left mouse button.
    Return ""
}
LeftClickUp()
{
    ; left mouseup
    global LeftIsDown := false
    SetMouseDelay, -1  ; Makes movement smoother.
    MouseClick, left, , , 1, 0, U  ; Release the mouse button.
    Return ""
}

RightClickDown()
{
    ; right mousedown
    global RightIsDown := true
    SetMouseDelay, -1  ; Makes movement smoother.
    MouseClick, right, , , 1, 0, D  ; Hold down the left mouse button.
    Return ""
}
RightClickUp()
{
    ; right mouseup
    global RightIsDown := false
    SetMouseDelay, -1  ; Makes movement smoother.
    MouseClick, right, , , 1, 0, U  ; Release the mouse button.
    Return ""
}

MiddleClickDown()
{
    ; middle mousedown
    global MiddleIsDown := true
    SetMouseDelay, -1  ; Makes movement smoother.
    MouseClick, middle, , , 1, 0, D  ; Hold down the left mouse button.
    Return ""
}
MiddleClickUp()
{
    ; middle mouseup
    global MiddleIsDown := false
    SetMouseDelay, -1  ; Makes movement smoother.
    MouseClick, middle, , , 1, 0, U  ; Release the mouse button.
    Return ""
}

MouseClicker: ; ******************************************
    if ( XInput_GetState(JoystickNumber, State)=0 ) ; 0 if not defined
    {
        StringSplit, arrayDATA, State, `, 
        buttonbinary := arrayDATA%XDATA_DPAD%

        if ( XInputButtonIsDown( "XINPUT_GAMEPAD_RIGHT_THUMB", buttonbinary ) && XInputButtonIsDown( "XINPUT_GAMEPAD_START", buttonbinary ) )
        {
            EnableMouse := ! EnableMouse
            if (EnableMouse == true)
            {
                SoundBeep 1500
                MsgBox, 0x1130, JoyMouse, Joy Mouse Enabled, 1
            }
            else
            {
                if LeftIsDown 
                    LeftClickUp()
                if MiddleIsDown 
                    MiddleClickUp()
                if RightIsDown 
                    RightClickUp()

                SoundBeep 1000
                MsgBox, 0x1130, JoyMouse, Joy Mouse Disabled, 1
            }
        } ; all the keys

        if ( EnableMouse == false ) 
        {
            return
        }


        if (LeftIsDown == false)
        {
            if ( XInputButtonIsDown( ButtonLeftA, buttonbinary ) == true || XInputButtonIsDown( ButtonLeftB, buttonbinary ) == true)
            {
                LeftClickDown()
            }
        }
        Else
        {
            if ( XInputButtonIsDown( ButtonLeftA, buttonbinary ) == false && XInputButtonIsDown( ButtonLeftB, buttonbinary ) == false )
            {
                LeftClickUp()
            }
        }

        if (MiddleIsDown == false)
        {
            if ( XInputButtonIsDown( ButtonMiddleA, buttonbinary ) == true || XInputButtonIsDown( ButtonMiddleB, buttonbinary ) == true)
            {
                MiddleClickDown()
            }
        }
        Else
        {
            if ( XInputButtonIsDown( ButtonMiddleA, buttonbinary ) == false && XInputButtonIsDown( ButtonMiddleB, buttonbinary ) == false )
            {
                MiddleClickUp()
            }
        }

        if (RightIsDown == false)
        {
            if ( XInputButtonIsDown( ButtonRightA, buttonbinary ) == true || XInputButtonIsDown( ButtonRightB, buttonbinary ) == true)
            {
                RightClickDown()
            }
        }
        Else
        {
            if ( XInputButtonIsDown( ButtonRightA, buttonbinary ) == false && XInputButtonIsDown( ButtonRightB, buttonbinary ) == false )
            {
                RightClickUp()
            }
        }

    } ; state
return ; end MouseClicker ******************************************


JoystickMove: ; ******************************************

    if (EnableMouse == false) 
    {
        return
    }

    if XInput_GetState(JoystickNumber, State)=0
    {
        StringSplit, arrayDATA, State, `, 
        
        LT := arrayDATA%XDATA_LT%
        RT := arrayDATA%XDATA_RT%

        LX := arrayDATA%XDATA_LX%
        LY := arrayDATA%XDATA_LY%
        RX := arrayDATA%XDATA_RX%
        RY := arrayDATA%XDATA_RY%

        if (InvertX) {
            LX *= -1
            RX *= -1
        }
        if (InvertY) {
            LY *= -1
            RY *= -1
        }

        DeltaX := 0
        DeltaY := 0
        MouseNeedsToBeMoved := false

        if (Abs(LX) > JoyLThreshold) {
            DeltaX += (LX / LeftSlow)
            MouseNeedsToBeMoved := true
        }
        if (Abs(LY) > JoyLThreshold) {
            DeltaY += (LY / LeftSlow)
            MouseNeedsToBeMoved := true
        }

        if (Abs(RX) > JoyRThreshold) {
            DeltaX += (RX / RightSlow)
            MouseNeedsToBeMoved := true
        }
        if (Abs(RY) > JoyRThreshold) {
            DeltaY += (RY / RightSlow)
            MouseNeedsToBeMoved := true
        }

        if (MouseNeedsToBeMoved)
        {
            SetMouseDelay, -1  ; Makes movement smoother.
            ;mousemove, x, y, slowness, relative
            MouseMove, DeltaX, DeltaY, 0, R
            ;ToolTip, Lthumb : %LX%`, %LY% `nRthumb : %RX%`, %RY% `nDelta %DeltaX%`,%DeltaY%
        } ; MouseNeedsToBeMoved

        showdebug := false
        if (showdebug)
        {
            buttonbinary := arrayDATA%XDATA_DPAD%
            dtext := XInputButtonState(buttonbinary)
            ToolTip, buttons : %dtext% `nLT : %LT% `nRT : %RT% `nLthumb : %LX%`,%LY% `nRthumb : %RX%`,%RY%
        } ; debug
        
    } ; state
return ; end JoystickMove ******************************************


DpadScroll: ; ******************************************

    if (EnableMouse == false) 
    {
        return
    }

    if XInput_GetState(JoystickNumber, State)=0
    {
        StringSplit, arrayDATA, State, `, 
        buttonbinary := arrayDATA%XDATA_DPAD%

        if XInputButtonIsDown( "XINPUT_GAMEPAD_DPAD_UP", buttonbinary )
            Send {WheelUp}
        else if XInputButtonIsDown( "XINPUT_GAMEPAD_DPAD_DOWN", buttonbinary )
            Send {WheelDown}

        if XInputButtonIsDown( "XINPUT_GAMEPAD_DPAD_LEFT", buttonbinary )
            Send {WheelLeft}
        else if XInputButtonIsDown( "XINPUT_GAMEPAD_DPAD_RIGHT", buttonbinary )
            Send {WheelRight}
    } ; state
return ; end DpadScroll ******************************************
