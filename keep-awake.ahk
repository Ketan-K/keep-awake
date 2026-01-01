; Keep-Awake - AutoHotkey Version
; Keep your PC awake with automated mouse movements
; Author: Ketan-K

#NoEnv
#SingleInstance Force
SetBatchLines, -1
#Persistent

; Set custom tray icon
Menu, Tray, Icon, %A_ScriptName%, 1

; Default configuration
interval := 60  ; seconds
shakeSize := 10  ; pixels
quiet := false
count := 0
startTime := A_TickCount
GuiVisible := false

; Parse command-line arguments
hasArgs := false
i := 1
While (i <= A_Args.Length())
{
    param := A_Args[i]
    if (param = "--help") {
        ShowHelp()
        ExitApp
    }
    else if (param = "--quiet") {
        quiet := true
        hasArgs := true
    }
    else if (param = "--interval") {
        i++
        if (i <= A_Args.Length()) {
            interval := A_Args[i]
            if (interval < 1)
                interval := 60
            hasArgs := true
        }
    }
    else if (param = "--shake-size") {
        i++
        if (i <= A_Args.Length()) {
            shakeSize := A_Args[i]
            if (shakeSize < 1)
                shakeSize := 10
            hasArgs := true
        }
    }
    i++
}

; If no arguments provided, show GUI window
if (!hasArgs) {
    Gosub, ShowMainWindow
    SetTimer, UpdateGUIDisplay, 1000
} else {
    ; CLI mode - attach to console for output
    DllCall("AttachConsole", "int", -1)
    
    ; Show ASCII art banner and header (unless quiet)
    if (!quiet) {
        FileAppend, `n================================`n, *
        FileAppend, KEEP-AWAKE is running`n, *
        FileAppend, % "Interval: " . interval . "s | Shake Size: " . shakeSize . "px`n", *
        FileAppend, ================================`n`n, *
        FileAppend, +-------+-------------+-----------------+------------+-----------------+`n, *
        FileAppend, | Count | Time        | Current         | Offset     | New             |`n, *
        FileAppend, +-------+-------------+-----------------+------------+-----------------+`n, *
    }
}

; Set up system tray menu
Menu, Tray, Tip, % "Keep-Awake is running`nInterval: " . interval . "s | Shake Size: " . shakeSize . "px"
Menu, Tray, NoStandard
Menu, Tray, Add, Open, ShowMainWindow
Menu, Tray, Default, Open
Menu, Tray, Add
Menu, Tray, Add, Exit, ExitApp
Menu, Tray, Click, 1

; Start the mouse movement timer
SetTimer, ShakeMouse, % interval * 1000
return

; Show/Create GUI Window
ShowMainWindow:
    global GuiVisible, interval, shakeSize, count, startTime
    
    ; If window already exists, just show and activate it
    IfWinExist, Keep-Awake
    {
        Gui, Show
        WinActivate, Keep-Awake
        return
    }
    
    ; Create new GUI window
    Gui, Destroy
    Gui, +AlwaysOnTop -MinimizeBox +ToolWindow
    Gui, Font, s10 bold, Segoe UI
    Gui, Color, 0xFFFFFF
    
    ; Header
    Gui, Font, s14 bold c2C3E50, Segoe UI
    Gui, Add, Text, x10 y10 w380 h35 Center, Keep-Awake
    
    ; Status Panel
    Gui, Font, s9 norm cWhite, Segoe UI
    Gui, Add, Progress, x10 y55 w380 h75 Background4CAF50 c66BB6A, 100
    Gui, Font, s11 bold cWhite, Segoe UI
    Gui, Add, Text, x10 y65 w380 h25 Center BackgroundTrans vRunTimeText, Keeping your PC awake for: 0s
    Gui, Font, s9 norm cWhite, Segoe UI
    Gui, Add, Text, x10 y95 w380 h20 Center BackgroundTrans vStatsText, Mouse movements: 0
    
    ; Settings Panel
    Gui, Font, s9 bold c2C3E50, Segoe UI
    Gui, Add, GroupBox, x10 y140 w380 h90 c757575, Settings
    
    Gui, Font, s9 norm c2C3E50, Segoe UI
    Gui, Add, Text, x25 y165 w120 h20, Interval (seconds):
    Gui, Add, Edit, x150 y162 w80 h22 vIntervalInput Number, %interval%
    Gui, Add, UpDown, vIntervalUpDown Range1-3600, %interval%
    
    Gui, Add, Text, x25 y195 w120 h20, Shake Size (pixels):
    Gui, Add, Edit, x150 y192 w80 h22 vShakeSizeInput Number, %shakeSize%
    Gui, Add, UpDown, vShakeSizeUpDown Range1-100, %shakeSize%
    
    Gui, Font, s9 bold cWhite, Segoe UI
    Gui, Add, Button, x250 y162 w130 h50 gApplySettings vApplyButton Background4CAF50, Apply Settings
    
    ; More Info Button
    Gui, Font, s9 bold c2196F3, Segoe UI
    Gui, Add, Button, x10 y240 w380 h30 gOpenGitHub BackgroundFFFFFF, More Info / Contribute on GitHub
    
    ; Action Buttons
    Gui, Font, s10 bold cWhite, Segoe UI
    Gui, Add, Button, x10 y280 w185 h40 gRunInBackground Background2196F3, Run in Background
    Gui, Add, Button, x205 y280 w185 h40 gExitApp BackgroundF44336, Exit
    
    Gui, Show, w400 h330, Keep-Awake
    GuiVisible := true
    return

OpenGitHub:
    Run, https://github.com/Ketan-K/keep-awake
    return

ApplySettings:
    Gui, Submit, NoHide
    
    ; Update global variables
    interval := IntervalUpDown
    shakeSize := ShakeSizeUpDown
    
    ; Restart timer with new interval
    SetTimer, ShakeMouse, Off
    SetTimer, ShakeMouse, % interval * 1000
    
    ; Update tray tooltip
    Menu, Tray, Tip, % "Keep-Awake: Running | Interval: " . interval . "s"
    
    ; Show feedback on button
    GuiControl,, ApplyButton, Applied!
    SetTimer, ResetApplyButton, -2000
    return

ResetApplyButton:
    GuiControl,, ApplyButton, Apply Settings
    return

ResetStatsText:
    global count
    GuiControl,, StatsText, Mouse movements: %count%
    return

RunInBackground:
    Gui, Hide
    GuiVisible := false
    return

GuiClose:
    Gui, Hide
    GuiVisible := false
    return

ExitApp:
    ExitApp

UpdateGUIDisplay:
    global count, startTime, GuiVisible
    
    ; Only update if GUI is visible
    if (!GuiVisible)
        return
    
    ; Calculate elapsed time
    totalSeconds := Floor((A_TickCount - startTime) / 1000)
    
    ; Format time as Xm Ys or just Xs
    if (totalSeconds >= 60) {
        minutes := Floor(totalSeconds / 60)
        seconds := Mod(totalSeconds, 60)
        timeStr := minutes . "m " . seconds . "s"
    } else {
        timeStr := totalSeconds . "s"
    }
    
    ; Update GUI controls
    GuiControl,, RunTimeText, Keeping your PC awake for: %timeStr%
    GuiControl,, StatsText, Mouse movements: %count%
    
    ; Update tray tooltip
    Menu, Tray, Tip, % "Keep-Awake: " . timeStr . " | Movements: " . count
    return

ShakeMouse:
    global count, shakeSize, quiet, hasArgs
    count++
    
    ; Get current mouse position
    MouseGetPos, currentX, currentY
    
    ; Shake mouse: move right then back to original position
    MouseMove, % currentX + shakeSize, % currentY, 0
    Sleep, 50
    MouseMove, %currentX%, %currentY%, 0
    
    ; Print row (only in CLI mode when not quiet)
    if (hasArgs && !quiet) {
        FormatTime, currentTime, , HH:mm:ss tt
        
        ; Format strings with padding
        countStr := PadLeft(count, 5)
        timeStr := PadRight(currentTime, 11)
        currentStr := PadRight("[" . currentX . ", " . currentY . "]", 15)
        offsetStr := PadRight("[" . offsetX . ", " . offsetY . "]", 10)
        newStr := PadRight("[" . newX . ", " . newY . "]", 15)
        
        FileAppend, % "| " . countStr . " | " . timeStr . " | " . currentStr . " | " . offsetStr . " | " . newStr . " |`n", *
    }
    return

ShowHelp() {
    DllCall("AttachConsole", "int", -1)
    FileAppend, `n================================`n, *
    FileAppend, KEEP-AWAKE`n, *
    FileAppend, ================================`n, *
    FileAppend, Keep your PC awake while you're away!`n`n, *
    FileAppend, Usage: keep-awake.exe [options]`n`n, *
    FileAppend, Options:`n, *
    FileAppend,   --interval <seconds>    Set interval between shakes (default: 60)`n, *
    FileAppend,   --shake-size <pixels>   Set shake distance (default: 10)`n, *
    FileAppend,   --quiet                 Suppress console output`n, *
    FileAppend,   --help                  Show this help message`n`n, *
    FileAppend, Examples:`n, *
    FileAppend,   keep-awake.exe                              (GUI mode)`n, *
    FileAppend,   keep-awake.exe --interval 30 --shake-size 5 (CLI mode)`n, *
    FileAppend,   keep-awake.exe --quiet                      (CLI silent)`n, *
}

PadLeft(str, length) {
    str := "" . str
    while (StrLen(str) < length)
        str := " " . str
    return str
}

PadRight(str, length) {
    str := "" . str
    while (StrLen(str) < length)
        str .= " "
    return str
}
