; Example: Control the vibration motors using the analog triggers of each controller.
#Include, XinputCSV.ahk

XInput_Init()
if XInput_GetCapabilities(0,0,data)=0
{
    ;MsgBox, %data%
}
Loop {
        if XInput_GetState(0, State)=0 
        {

            StringSplit, arrayDATA, State, `,

            buttonbinary := arrayDATA%XDATA_DPAD%
            dtext := XInputButtonState(buttonbinary)

            LT := arrayDATA%XDATA_LT%
            RT := arrayDATA%XDATA_RT%
            XInput_SetState(0, LT*256, RT*256)

            LX := arrayDATA%XDATA_LX%
            LY := arrayDATA%XDATA_LY%
            RX := arrayDATA%XDATA_RX%
            RY := arrayDATA%XDATA_RY%


            ToolTip, buttons : %dtext% `nLT : %LT% `nRT : %RT% `nLthumb : %LX%`,%LY% `nRthumb : %RX%`,%RY%
        }
    Sleep, 100
}