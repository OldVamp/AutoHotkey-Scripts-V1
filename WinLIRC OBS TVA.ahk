;2025/06/18 OldVamp Updated the script to use both ANSI 32 and Unicode 64 AutoHotkey V1.1

;2020/11/16 OldVamp Added hold shift to add shift to button
;    remotename_shift_buttonname
;    shift_buttonname
;change from 
;    Holding shift to see remote button names with no subs
;to
;    hold control to see button information

;2011/14/1 OldVamp added support for:
;remotename_buttonname subs
;    If both remote_button and button subs exist the button sub wont get called
;    you may need to replace spaces in remote and button names with underlines _ in your winlirc configs
;transmitting remote codes
;    transmit(lirc remote name,lirc button name,lirc repeats)
;    transmit rarely works with raw remote codes, use a proper config (if one exists) from http://lirc.sourceforge.net/remotes/
;Iguanaworks USB IR Transceiver, http://www.iguanaworks.net/ 
;    starts the Iguanaworks usb service if you are useing this hardware
;Holding shift to see remote button names with no subs

; -------------------------------------------------
; CONFIGURATION SECTION: Set your preferences here.
; -------------------------------------------------
; Some remote controls repeat the signal rapidly while you're holding down
; a button. This makes it difficult to get the remote to send only a single
; signal. The following setting solves this by ignoring repeated signals
; until the specified time has passed. 200 is often a good setting.  Set it
; to 0 to disable this feature.

DelayBetweenButtonRepeats = 300

; Specify the path to WinLIRC and its components, such as C:\WinLIRC\winlirc.exe
; Specify WinLIRC's address and port. The most common are 127.0.0.1 (localhost) and 8765.
; WinLIRC_Dir needs a \ on the end example: C:\Program Files\WinLIRC\

WinLIRC_Address         = 127.0.0.1
WinLIRC_Port            = 8765
WinLIRC_Dir             = D:\Desktop Backup\1Stuff\Programming\WinLIRC\
WinLIRC_Path            = D:\Desktop Backup\1Stuff\Programming\WinLIRC\winlirc.exe
WINLIRC_Transmit_Path   = D:\Desktop Backup\1Stuff\Programming\WinLIRC\transmit.exe

; http://www.iguanaworks.net/     use USB IR Transceiver 1 or 0
Use_Iguana              = 1
Iguana_path             = C:\Program Files (x86)\IguanaIR\igdaemon.exe

; #############################################################################################
; ---------------------------------START OF your variables SECTION-----------------------------
; #############################################################################################
; add any new variables here to keep them orginized

SetupButtons = 0

SetTitleMatchMode, 1
WindowTitle  := "OBS 31"
ControlTitle := "Qt663QWindowIcon5"

; #############################################################################################
; ---------------------------------  END OF your variables SECTION-----------------------------
; #############################################################################################


; Do not change the following three lines. Skip them and continue below.
Gosub WinLIRC_Init
return
; Do not change the Previous  three lines. Skip them and continue below.


; #############################################################################################
; ---------------------------------START OF CONFIGURATION SECTION------------------------------
; #############################################################################################

shift_tva_fullscreen:

return
tva_fullscreen:
    thisbutton = {F13}
    if (SetupButtons == 1)
        send, %thisbutton%
    else
        ControlSend, %ControlTitle%, %thisbutton%, %WindowTitle%
return



shift_tva_mts:

return
tva_mts:
    thisbutton = {F14}
    if (SetupButtons == 1)
        send, %thisbutton%
    else
        ControlSend, %ControlTitle%, %thisbutton%, %WindowTitle%
return



shift_tva_function:

return
tva_function:
    thisbutton = {F18}
    if (SetupButtons == 1)
        send, %thisbutton%
    else
        ControlSend, %ControlTitle%, %thisbutton%, %WindowTitle%
return



shift_tva_power:

return
tva_power:
    thisbutton = {F20}
    if (SetupButtons == 1)
        send, %thisbutton%
    else
        ControlSend, %ControlTitle%, %thisbutton%, %WindowTitle%
return



shift_tva_1:

return
tva_1:

return



shift_tva_2:

return
tva_2:
    thisbutton = {F15}
    if (SetupButtons == 1)
        send, %thisbutton%
    else
        ControlSend, %ControlTitle%, %thisbutton%, %WindowTitle%
return



shift_tva_3:

return
tva_3:
    thisbutton = {F19}
    if (SetupButtons == 1)
        send, %thisbutton%
    else
        ControlSend, %ControlTitle%, %thisbutton%, %WindowTitle%
return



shift_tva_4:

return
tva_4:
    
return



shift_tva_5:

return
tva_5:
    thisbutton = {F16}
    if (SetupButtons == 1)
        send, %thisbutton%
    else
        ControlSend, %ControlTitle%, %thisbutton%, %WindowTitle%
return



shift_tva_6:

return
tva_6:
    
return



shift_tva_7:

return
tva_7:
    
return



shift_tva_8:

return
tva_8:
    thisbutton = {F17}
    if (SetupButtons == 1)
        send, %thisbutton%
    else
        ControlSend, %ControlTitle%, %thisbutton%, %WindowTitle%
return



shift_tva_9:

return
tva_9:
    
return



shift_tva_0:

return
tva_0:
    
return



shift_tva_cup:

return
tva_cup:

return



shift_tva_cdown:

return
tva_cdown:

return



shift_tva_vup:

return
tva_vup:

return



shift_tva_vdown:

return
tva_vdown:

return



shift_tva_tshift:

return
tva_tshift:

return



shift_tva_return:

return
tva_return:

return



shift_tva_rewind:

return
tva_rewind:

return



shift_tva_playpause:

return
tva_playpause:

return



shift_tva_fastforward:

return
tva_fastforward:

return



shift_tva_mute:

return
tva_mute:
    thisbutton = {F21}
    if (SetupButtons == 1)
        send, %thisbutton%
    else
        ControlSend, %ControlTitle%, %thisbutton%, %WindowTitle%
return




; #############################################################################################
; ---------------------------------END OF CONFIGURATION SECTION--------------------------------
; #############################################################################################
; Do not make changes below this point unless you want to change the core
; functionality of the script.

WinLIRC_Init:
OnExit, ExitSub  ; For connection cleanup purposes.


; Launch Iguana service if it isn't already running:
if (Use_Iguana == 1) {
    Process, Exist, igdaemon.exe
    if not ErrorLevel  ; No PID was found.
    {
        IfNotExist, %Iguana_path%
        {
            MsgBox The file "%Iguana_path%" does not exist. Please edit this script to specify its location.
            ExitApp
        }
        Run %Iguana_path% --startsvc
        Sleep 2000  ; Give it a little time to initialize (probably never needed, just for peace of mind).
    }
}


; Launch WinLIRC if it isn't already running:
Process, Exist, winlirc.exe
if not ErrorLevel  ; No PID for WinLIRC was found.
{
    IfNotExist, %WinLIRC_Path%
    {
        MsgBox The file "%WinLIRC_Path%" does not exist. Please edit this script to specify its location.
        ExitApp
    }
    Run %WinLIRC_Path%,%WinLIRC_Dir%
    Sleep 200  ; Give WinLIRC a little time to initialize (probably never needed, just for peace of mind).
}


; Connect to WinLIRC (or any type of server for that matter):
socket := ConnectToAddress(WinLIRC_Address, WinLIRC_Port)
if socket = -1  ; Connection failed (it already displayed the reason).
{
    MsgBox Socket Failed
    ExitApp
}
    

; Find this script's main window:
Process, Exist  ; This sets ErrorLevel to this script's PID (it's done this way to support compiled scripts).
DetectHiddenWindows On
ScriptMainWindowId := WinExist("ahk_class AutoHotkey ahk_pid " . ErrorLevel)
DetectHiddenWindows Off

; When the OS notifies the script that there is incoming data waiting to be received,
; the following causes a function to be launched to read the data:
NotificationMsg = 0x5555  ; An arbitrary message number, but should be greater than 0x1000.
OnMessage(NotificationMsg, "ReceiveData")

; Set up the connection to notify this script via message whenever new data has arrived.
; This avoids the need to poll the connection and thus cuts down on resource usage.
FD_READ = 1     ; Received when data is available to be read.
FD_CLOSE = 32   ; Received when connection has been closed.
if DllCall("Ws2_32\WSAAsyncSelect", "UInt", socket, "UInt", ScriptMainWindowId, "UInt", NotificationMsg, "Int", FD_READ|FD_CLOSE)
{
    MsgBox % "WSAAsyncSelect() indicated Winsock error " . DllCall("Ws2_32\WSAGetLastError")
    ExitApp
}
return


ConnectToAddress(IPAddress, Port)
; This can connect to most types of TCP servers, not just WinLIRC.
; Returns -1 (INVALID_SOCKET) upon failure or the socket ID upon success.
{
    varsizeone := 400*(A_IsUnicode?2:1) ; fix ansi vs unicode
    ;varsizeone := 400
    VarSetCapacity(wsaData, varsizeone)
    ;VarSetCapacity(wsaData, 400)
    result := DllCall("Ws2_32\WSAStartup", "UShort", 0x0002, "UInt", &wsaData) ; Request Winsock 2.0 (0x0002)
    ; Since WSAStartup() will likely be the first Winsock function called by this script,
    ; check ErrorLevel to see if the OS has Winsock 2.0 available:
    if ErrorLevel
    {
        MsgBox WSAStartup() could not be called due to error %ErrorLevel%. Winsock 2.0 or higher is required.
        return -1
    }
    if result  ; Non-zero, which means it failed (most Winsock functions return 0 upon success).
    {
        MsgBox % "WSAStartup() indicated Winsock error " . DllCall("Ws2_32\WSAGetLastError")
        return -1
    }

    AF_INET = 2
    SOCK_STREAM = 1
    IPPROTO_TCP = 6
    socket := DllCall("Ws2_32\socket", "Int", AF_INET, "Int", SOCK_STREAM, "Int", IPPROTO_TCP)
    if socket = -1
    {
        MsgBox % "socket() indicated Winsock error " . DllCall("Ws2_32\WSAGetLastError")
        return -1
    }

    ; Prepare for connection:
    SizeOfSocketAddress = 16*(A_IsUnicode?2:1) ; fix ansi vs unicode
    stringtype := (A_IsUnicode?"astr":"str") ; fix ansi vs unicode
    VarSetCapacity(SocketAddress, SizeOfSocketAddress)
    InsertInteger(2, SocketAddress, 0, AF_INET)   ; sin_family
    InsertInteger(DllCall("Ws2_32\htons", "UShort", Port), SocketAddress, 2, 2)   ; sin_port
    InsertInteger(DllCall("Ws2_32\inet_addr",  stringtype, IPAddress), SocketAddress, 4, 4) ; sin_addr.s_addr
    ;InsertInteger(DllCall("Ws2_32\inet_addr",  "Str", IPAddress), SocketAddress, 4, 4) ; sin_addr.s_addr
    ;InsertInteger(DllCall("Ws2_32\inet_addr", "AStr", IPAddress), SocketAddress, 4, 4)   ; sin_addr.s_addr

    ; Attempt connection:
    if DllCall("Ws2_32\connect", "UInt", socket, "UInt", &SocketAddress, "Int", SizeOfSocketAddress)
    {
        MsgBox % "connect() indicated Winsock error " . DllCall("Ws2_32\WSAGetLastError") . ". Is WinLIRC running?"
        return -1
    }
    return socket  ; Indicate success by returning a valid socket ID rather than -1.
} ; ConnectToAddress function


ReceiveData(wParam, lParam)
; By means of OnMessage(), this function has been set up to be called automatically whenever new data
; arrives on the connection.  It reads the data from WinLIRC and takes appropriate action depending
; on the contents.
{
    Critical  ; Prevents another of the same message from being discarded due to thread-already-running.
    socket := wParam
    ReceivedDataSize = 4096 ; Large in case a lot of data gets buffered due to delay in processing previous data.
    
    VarSetCapacity(ReceivedData, ReceivedDataSize, 0)  ; 0 for last param terminates string for use with recv().
    ;ReceivedDataLength := DllCall("Ws2_32\recv", "UInt", socket, "Str",  ReceivedData, "Int", ReceivedDataSize, "Int", 0)
    ;ReceivedDataLength := DllCall("Ws2_32\recv", "UInt", socket, "AStr", ReceivedData, "Int", ReceivedDataSize, "Int", 0)
    ;ReceivedDataLength := DllCall("Ws2_32\recv", "UInt", socket, "Ptr", &ReceivedData, "Int", ReceivedDataSize, "Int", 0)

    if (A_IsUnicode)
    {
        ReceivedDataLength := DllCall("Ws2_32\recv", "UInt", socket, "Ptr", &ReceivedData, "Int", ReceivedDataSize, "Int", 0)
        temp := StrGet(&ReceivedData, "CP0")
        ReceivedData := temp
    } else {
        ReceivedDataLength := DllCall("Ws2_32\recv", "UInt", socket,  "Str", ReceivedData, "Int", ReceivedDataSize, "Int", 0)
    }
    ;ToolTip %ReceivedDataLength% %ReceivedData%
    ;len data repeats button remote
    ;42 0000000061d6c837 01 tva_mts tv@nwhere.cfg

    if ReceivedDataLength = 0  ; The connection was gracefully closed, probably due to exiting WinLIRC.
    {
        MsgBox Connection closed
        ExitApp  ; The OnExit routine will call WSACleanup() for us.
    }
        
    if ReceivedDataLength = -1
    {
        WinsockError := DllCall("Ws2_32\WSAGetLastError")
        if WinsockError = 10035  ; WSAEWOULDBLOCK, which means "no more data to be read".
            return 1
        if WinsockError <> 10054 ; WSAECONNRESET, which happens when WinLIRC closes via system shutdown/logoff.
        {
            ; Since it's an unexpected error, report it.  Also exit to avoid infinite loop.
            MsgBox % "recv() indicated Winsock error " . WinsockError
        }
        ExitApp  ; The OnExit routine will call WSACleanup() for us.
    }
    ; Otherwise, process the data received. Testing shows that it's possible to get more than one line
    ; at a time (even for explicitly-sent IR signals), which the following method handles properly.
    ; Data received from WinLIRC looks like the following example (see the WinLIRC docs for details):
    ; 0000000000eab154 00 NameOfButton NameOfRemote
    Loop, parse, ReceivedData, `n, `r
    {
        if A_LoopField in ,BEGIN,SIGHUP,END  ; Ignore blank lines and WinLIRC's start-up messages.
            continue
        ButtonName =  ; Init to blank in case there are less than 3 fields found below.
        RemoteName =  ; Init to blank in case there are less than 4 fields found below.
        Loop, parse, A_LoopField, %A_Space%  ; Extract the button name, which is the third field.
        {
            if A_Index = 3
                ButtonName := A_LoopField
            if A_Index = 4
                RemoteName := A_LoopField
        }
        global DelayBetweenButtonRepeats  ; Declare globals to make them available to this function.
        static PrevButtonName, PrevButtonTime, RepeatCount  ; These variables remember their values between calls.
        if (ButtonName != PrevButtonName || A_TickCount - PrevButtonTime > DelayBetweenButtonRepeats)
        {
            ; build the subrouteine(label) name from the remote name, controle state, and button name
            RemoteButtonName := RemoteName "_" ButtonName

            if GetKeyState("Shift") 
            {
                RemoteButtonName := RemoteName "_shift_" ButtonName
                ButtonName := "shift_" ButtonName
            }

            if GetKeyState("Control") 
            {
                ; display received data for debugging

                if (ButtonName == PrevButtonName)
                    RepeatCount += 1
                else
                    RepeatCount = 1

                SplashTextOn, 300, 20, Button pressed , %RemoteName% : %ButtonName% (%RepeatCount%)
                SetTimer, SplashOff, 3000  ; This allows more signals to be processed while displaying the window.
            }

            PrevButtonName := ButtonName
            PrevButtonTime := A_TickCount

            ; gosubs should come last they exit the function
            if IsLabel(RemoteButtonName)
            {
                ; There is a subroutine associated with this remote and button.
                Gosub %RemoteButtonName%
            }
            else if IsLabel(ButtonName)  
            {
                ; There is a subroutine associated with this button.
                Gosub %ButtonName%
            }
            else
            {
                ;There is no associated subroutine
            }
        } ; button change
    } ; ReceivedData loop
    return 1  ; Tell the program that no further processing of this message is needed.
} ; ReceiveData function


transmit(lircremote,lircbutton,lircrepeats)
{
    global WINLIRC_Transmit_Path
    Run % "" WINLIRC_Transmit_Path " " lircremote " " lircbutton " " lircrepeats
} ; transmit function


InsertInteger(pInteger, ByRef pDest, pOffset = 0, pSize = 4)
; The caller must ensure that pDest has sufficient capacity.  To preserve any existing contents in pDest,
; only pSize number of bytes starting at pOffset are altered in it.
{
    Loop %pSize%  ; Copy each byte in the integer into the structure as raw binary data.
        DllCall("RtlFillMemory", "UInt", &pDest + pOffset + A_Index-1, "UInt", 1, "UChar", pInteger >> 8*(A_Index-1) & 0xFF)
} ; InsertInteger


SplashOff:
SplashTextOff
SetTimer, SplashOff, Off
return


ExitSub:  ; This subroutine is called automatically when the script exits for any reason.
; MSDN: "Any sockets open when WSACleanup is called are reset and automatically
; deallocated as if closesocket was called."
DllCall("Ws2_32\WSACleanup")
ExitApp
