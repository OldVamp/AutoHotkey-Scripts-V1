; 2025/06/10 Script for Tileing Windows on a single monitor by OldVamp
; control shift 9 for help string by default
; You can customize it for your screen size by changing the ScreenGrids variable
; Lmited to about 100 windows in this set, you can add more

#NoEnv
#SingleInstance, Force
SendMode, Input

; Storm Chaser Watching Script by OldVamp
; version 2025 06 09 09:48 am CT
; For AutoHotKey 1.0.48.05

;========================================== Fiddley Bits

YouTubers = 
(
RyanHallYall , MaxVelocityWX , BrandonCopicWx , FreddyMcKinney , johnmckinney4128 , 
stormrunnermedia , ReedTimmerWx , DanielShawAU , StormChaserBradArnold , tornadopaigeyy , 
StormChaserTylerKurtz , ConnorCroff , bobpackstormchaser , StormChaserIRL , coreygerkenwx , 
JakobMcMillin , JenMcMahan , StormChaserJordanHall , StormChaserVince , WxScholl
)

ScreenGrids := "1x1,2x1,2x2,3x2,3x3,4x3,4x4,5x4,5x5,6x5,6x6,7x6,7x7,8x7,8x8,9x8,9x9,10x10"
; ScreenGrids 16x9      := "1x1,2x1,2x2,3x2,3x3,4x3,4x4,5x4,5x5,6x5,6x6,7x6,7x7,8x7,8x8,9x8,9x9,10x10"
; ScreenGrids UltraWide := "1x1,2x1,3x1,3x2,4x2,4x3,5x3,5x4,6x4,6x5,7x5,8x5,8x6,9x6,9x7,10x7,10x8,11x8,11x9"
; ScreenGrids TheWidest := "1x1,2x1,3x1,4x1,4x2,4x3,5x3,6x3,6x4,7x4,8x4,9x4,9x5,10x5,10x6,11x6,12x6,12x7,13x7,14x7,15x7"
; For custom grids start with 1x1 and increase the width or height for the next one, one at a time, don't add more than one that multiply to the same number

helpstring =
(
Control Shift 

1 - Open all live youtubers
2 - Tile Active window type
3 - Tile ALL Windows
4 - Toggle VLC Mute
5 - Toggle VLC Interface
6 - 
7 - 
8 - List all windows for debug
9 - Help
0 - Close all windows of active type
)

;========================================== Key Combos

; + shift
; ^ control
; ! alt
; # win
; < left <!
; > right >#

^+1:: ; ctrl + shift + 1
    OpenYoutubers(YouTubers)
    Return

^+2:: ; ctrl + shift + 2
    ; tile ACTIVE windows
    WinGetClass, activeclass, A ; get the active window class
    temp := GetClassWindows(activeclass)
    TileWindowsOVMathGrid(temp,ScreenGrids)
    Return

^+3:: ; ctrl + shift + 3
    ; tile ALL windows
    temp := GetAllWindows()
    TileWindowsOVMathGrid(temp,ScreenGrids)
    Return

^+4:: ; ctrl + shift + 4
    ; toggle vlc Mute
    WinGetClass, activeclass, A ; get the active window class
    temp := GetClassWindows(activeclass)
    VLCToggleMute(temp)
    Return

^+5:: ; ctrl + shift + 5
    ; toggle vlc interface
    WinGetClass, activeclass, A ; get the active window class
    temp := GetClassWindows(activeclass)
    VLCToggleInterface(temp)
    Return

^+6:: ; ctrl + shift + 6

    Return

^+7:: ; ctrl + shift + 7
    
    Return

^+8:: ; ctrl + shift + 8
    ListOpenWindows()
    Return

^+9:: ; ctrl + shift + 9
    MsgBox, %helpstring%
    Return

^+0:: ; ctrl + shift + 0
    ; close all windows of type
    WinGetClass, activeclass, A ; get the active window class
    temp := GetClassWindows(activeclass)
    CloseWindows(temp)
    Return


;========================================== Functions


OpenYoutubers(ChannelList)
{
    Loop, parse, ChannelList, `, ,%A_Space%`r`n"" ; split on comma and ignore space, line return, new line, double quotes
    {
        ; test
        ; MsgBox, %A_Index% : https://www.youtube.com/@%A_LoopField%/live

        ; VLC play controls
        ; Run, vlc.exe https://www.youtube.com/@%A_LoopField%/live ,,OpenedWindow

        ; VLC no controls
        Run, vlc.exe --qt-minimal-view https://www.youtube.com/@%A_LoopField%/live ,,OpenedWindow

        ; VLC no controls, no volume, set sound device
        ; Run, vlc.exe --qt-minimal-view --aout=waveout --waveout-volume=0.00 https://www.youtube.com/@%A_LoopField%/live ,,OpenedWindow

        ; firefox
        ; Run, firefox.exe -new-window https://www.youtube.com/@%A_LoopField%/live ,,OpenedWindow

        ; wait a little bit so the computer doesn't die
        Sleep 500
    }
} ; OpenYoutubeers

ListOpenWindows()
{
    WinGet WinArray, List,,,
    exclude := ",Program Manager,Settings,Windows Input Experience"
    templist := ">Class`n>>Title`n`n"
    Loop %WinArray%
    {
        id := WinArray%A_Index%
        WinGetTitle WindowTitle, ahk_id %id%
        if WindowTitle not in %exclude% 
        {
            WinGetClass, WinClass, %WindowTitle%
            templist .= ">" WinClass . "`n>>" . WindowTitle . "`n`n"
        }
    }
    Gui, Add, Edit,-Wrap, %templist%
    Gui, Show,, Open Windows
} ; ListOpenWindows

GetAllWindows()
{
    WinGet WinArray, List,,,
    exclude := ",Program Manager,Settings,Windows Input Experience"
    Loop %WinArray%
    {
        id := WinArray%A_Index%
        WinGetTitle this_title, ahk_id %id%
        if this_title not in %exclude% 
            WinList .= WinArray%A_Index% . "`,"
    }
    StringTrimRight, WinList, WinList, 1 ; Removes the last ","
    Return %WinList%
} ; GetAllWindows

GetClassWindows(WindowClass)
{
    WinGet WinArray, List, ahk_class %WindowClass%
    Loop % WinArray
        WinList .= WinArray%A_Index% . "`,"
    StringTrimRight, WinList, WinList, 1 ; Removes the last ","
    Return %WinList%
} ; GetClassWindows

CloseWindows(WinList)
{
    Loop, Parse, WinList, `, ; escaped comma
    {
        WinActivate, ahk_id %A_LoopField%
        WinGetTitle wt, ahk_id %A_LoopField%
        WinClose, %wt%
    }
} ; CloseWindows

VLCToggleInterface(WinList)
{
    Loop, Parse, WinList, `, ; escaped comma
    {
        WinActivate, ahk_id %A_LoopField%
        Send ^h
    }
} ; VLCToggleInterface

VLCToggleMute(WinList)
{
    Loop, Parse, WinList, `, ; escaped comma
    {
        WinActivate, ahk_id %A_LoopField%
        Send m
    }
} ; VLCToggleMute

GetGridSize(Amount, Grids)
{
    gridx := 1
    gridy := 1
    temp := 0
    Loop, parse, Grids, `, ,%A_Space%
    {
        ;v1
        ;xy := StrSplit(A_LoopField, "x", A_Space)
        ;v0.9
        StringSplit, xy, A_LoopField, "x", %A_Space%`r`n""
        x := xy1
        y := xy2
        gridsize := x * y
        if (Amount <= gridsize) 
        {
            gridx := x , gridy := y , temp := gridsize
            ;MsgBox % Amount " windows need a " gridx " by " gridy " grid of " temp
            Return %A_LoopField%
        }
    }
    ; failsafe
    Return "1x1"
} ; GetGridSize

TileWindowsOVMathGrid(WindowHandleList, GridsToUse)
{
     Loop, Parse, WindowHandleList, `, ; escaped comma
        ++WindowCount
    ; number of windows coutned

    GridSize := GetGridSize(WindowCount,GridsToUse)
    StringSplit, xy, GridSize, "x", %A_Space%`r`n""
    Grid_Size_X := xy1
    Grid_Size_Y := xy2
    Grid_Spot_X := 0
    Grid_Spot_Y := 0

    WinGetPos,,,TaskBar_Width, TaskBarHeight, ahk_class Shell_TrayWnd ; get the taskbar size
    ScreenSize_X := A_ScreenWidth
    ScreenSize_Y := A_ScreenHeight - TaskBarHeight
    WindowSize_X := Ceil(ScreenSize_X / Grid_Size_X)
    WindowSize_Y := Ceil(ScreenSize_Y / Grid_Size_Y)
    Window_Pos_X := 0
    Window_Pos_Y := 0

    Loop, Parse, WindowHandleList, `, ; escaped comma
    {
        WindowHandle := A_LoopField

        if (Grid_Spot_X >= Grid_Size_X) 
        { 
            Grid_Spot_X := 0
            Grid_Spot_Y++
        }

        Window_Pos_X := WindowSize_X * Grid_Spot_X
        Window_Pos_Y := WindowSize_Y * Grid_Spot_Y
        ;MsgBox, %Grid_Spot_X% %Grid_Spot_Y% %Window_Pos_X% %Window_Pos_Y%
        Grid_Spot_X++

        ; adjust for window size/pos weirdness
        wsx := WindowSize_X + 16
        wsy := WindowSize_Y + 9
        wpx := Window_Pos_X - 8
        wpy := Window_Pos_Y - 0
        ; move windows
        ; WinMove, ahk_id %WindowHandle%,, %Window_Pos_X%, %Window_Pos_Y%, %WindowSize_X%, %WindowSize_Y%
        WinMove, ahk_id %WindowHandle%,, %wpx%, %wpy%, %wsx%, %wsy%
        ; bring window to the front focus
        WinActivate, ahk_id %WindowHandle%
    } ; End parse-loop
    return WindowCount ; N windows were tiled
} ; TileWindowsOVMathGrid
