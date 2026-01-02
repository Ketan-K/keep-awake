; Keep-Awake - AutoHotkey Version
; Keep your PC awake with automated mouse movements
; Author: Ketan-K

#NoEnv
#SingleInstance Force
SetBatchLines, -1
#Persistent

; Set custom tray icon (only if compiled or if .ico file exists)
if FileExist("keep-awake.ico")
    Menu, Tray, Icon, keep-awake.ico
else if (A_IsCompiled)
    Menu, Tray, Icon, %A_ScriptName%, 1

; Default configuration
interval := 60  ; seconds
shakeSize := 10  ; pixels
quiet := false
count := 0
startTime := A_TickCount
GuiVisible := false

; New feature variables
durationMode := "Infinite"  ; "Infinite" or "Timed"
durationValue := 15  ; minutes (for Timed mode)
keepAwakeMode := "F15"  ; "Mouse Shake", "Mouse Move", "Key Press", "F15"
smartMode := true  ; Enable smart mode by default
notifyWhenStopped := false  ; Notify when duration expires
endTimestamp := 0  ; When to stop (in milliseconds)
smartModeThreshold := 10000  ; 10 seconds in milliseconds
smartModeSkipping := false  ; Track if currently skipping due to user activity

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
    global durationMode, durationValue, keepAwakeMode, smartMode, notifyWhenStopped
    
    ; Create new GUI window with material design
    Gui, Destroy
    Gui, +AlwaysOnTop -MinimizeBox
    Gui, Margin, 0, 0
    Gui, Color, White
    
    ; Header with green accent
    Gui, Font, s14 bold c2E7D32, Segoe UI
    Gui, Add, Text, x10 y10 w380 h35 Center, Keep-Awake
    
    ; Status Panel with green progress bar
    Gui, Font, s9 norm c333333, Segoe UI
    Gui, Add, Progress, x10 y55 w380 h75 Background4CAF50 c66BB6A, 100
    Gui, Font, s11 bold cWhite, Segoe UI
    Gui, Add, Text, x10 y65 w380 h25 Center BackgroundTrans vRunTimeText, Keeping your PC awake for: 0s
    Gui, Font, s9 norm cWhite, Segoe UI
    Gui, Add, Text, x10 y95 w380 h20 Center BackgroundTrans vStatsText, Mode: F15 | Frequency: 60s
    
    ; Settings Section - Consolidated
    Gui, Font, s9 bold c2E7D32, Segoe UI
    Gui, Add, GroupBox, x10 y140 w380 h230, Settings
    
    Gui, Font, s9 norm c555555, Segoe UI
    ; Row 1: Mode and Shake/Move Size
    Gui, Add, Text, x25 y165 w50 h20, Mode:
    Gui, Add, DropDownList, x80 y162 w100 vModeDropDown gModeDropDownChange, Mouse Shake|Mouse Move|Key Press|F15||
    
    Gui, Add, Text, x195 y165 w120 h20 vShakeSizeLabel Hidden, Shake/Move Pixels:
    Gui, Add, Edit, x300 y162 w50 h22 vShakeSizeInput Number Hidden, %shakeSize%
    Gui, Add, UpDown, vShakeSizeUpDown Range1-100 Hidden, %shakeSize%
    
    ; Row 2: Frequency
    Gui, Add, Text, x25 y192 w50 h20, Frequency:
    Gui, Add, Edit, x80 y189 w60 h22 vIntervalInput Number, %interval%
    Gui, Add, UpDown, vIntervalUpDown Range1-3600, %interval%
    Gui, Add, Text, x145 y192 w40 h20, sec
    
    ; Row 3: Duration
    Gui, Add, Text, x25 y219 w50 h20, Duration:
    Gui, Add, Radio, x80 y219 w70 h20 vDurationInfinite Checked gDurationModeChange, Infinite
    Gui, Add, Radio, x155 y219 w70 h20 vDurationTimed gDurationModeChange, Timed
    
    ; Row 4: Duration dropdown
    Gui, Add, DropDownList, x80 y242 w160 vDurationDropDown gDurationDropDownChange Disabled, 15 minutes|30 minutes|1 hour|2 hours|Custom
    Gui, Add, Text, x245 y245 w30 h20 vCustomLabel Hidden, Min:
    Gui, Add, Edit, x275 y242 w40 h20 vCustomDurationInput Number Hidden, 15
    Gui, Add, UpDown, vCustomDurationUpDown Range1-1440 Hidden, 15
    
    ; Row 5 & 6: Checkboxes
    Gui, Add, Checkbox, x25 y272 w350 h20 vSmartModeCheck Checked, Smart Mode (pause when user is active)
    Gui, Add, Checkbox, x25 y297 w350 h20 vNotifyCheck, Notify when stopped
    
    ; Action Buttons with green accent
    Gui, Font, s10 bold cWhite, Segoe UI
    Gui, Add, Button, x10 y330 w380 h40 gApplySettings vApplyButton Background4CAF50, Apply Settings
    
    Gui, Font, s9 norm c2E7D32, Segoe UI
    Gui, Add, Button, x10 y380 w185 h35 gRunInBackground, Run in Background
    Gui, Add, Button, x205 y380 w185 h35 gExitApp, Exit
    
    Gui, Show, w400 h425 Center, Keep-Awake
    GuiVisible := true
    return

OpenGitHub:
    Run, https://github.com/Ketan-K/keep-awake
    return

ApplySettings:
    global interval, shakeSize, durationMode, durationValue, keepAwakeMode
    global smartMode, notifyWhenStopped, endTimestamp, startTime
    
    Gui, Submit, NoHide
    
    ; Update global variables from controls
    interval := IntervalUpDown
    shakeSize := ShakeSizeUpDown
    
    ; Get duration mode
    if (DurationInfinite = 1) {
        durationMode := "Infinite"
        endTimestamp := 0
    } else {
        durationMode := "Timed"
        
        ; Get duration value from dropdown
        if (DurationDropDown = "15 minutes") {
            durationValue := 15
        } else if (DurationDropDown = "30 minutes") {
            durationValue := 30
        } else if (DurationDropDown = "1 hour") {
            durationValue := 60
        } else if (DurationDropDown = "2 hours") {
            durationValue := 120
        } else if (DurationDropDown = "Custom") {
            durationValue := CustomDurationUpDown
        } else {
            durationValue := 15  ; Default
        }
        
        ; Calculate end timestamp
        endTimestamp := A_TickCount + (durationValue * 60 * 1000)
    }
    
    ; Get keep-awake mode
    keepAwakeMode := ModeDropDown
    
    ; Get checkbox states
    smartMode := SmartModeCheck
    notifyWhenStopped := NotifyCheck
    
    ; Restart timer with new interval
    SetTimer, ShakeMouse, Off
    SetTimer, ShakeMouse, % interval * 1000
    
    ; Update tray tooltip
    Menu, Tray, Tip, % "Keep-Awake: Running | Mode: " . keepAwakeMode . " | Interval: " . interval . "s"
    
    ; Show feedback on button
    GuiControl,, ApplyButton, Applied!
    SetTimer, ResetApplyButton, -2000
    return

ResetApplyButton:
    GuiControl,, ApplyButton, Apply Settings
    return

DurationModeChange:
    Gui, Submit, NoHide
    
    ; Enable/Disable duration dropdown based on selected radio button
    if (DurationInfinite = 1) {
        GuiControl, Disable, DurationDropDown
        GuiControl, Hide, CustomLabel
        GuiControl, Hide, CustomDurationInput
        GuiControl, Hide, CustomDurationUpDown
    } else {
        GuiControl, Enable, DurationDropDown
        ; Check if Custom is selected to show custom input
        if (DurationDropDown = "Custom") {
            GuiControl, Show, CustomLabel
            GuiControl, Show, CustomDurationInput
            GuiControl, Show, CustomDurationUpDown
        }
    }
    return

DurationDropDownChange:
    Gui, Submit, NoHide
    
    ; Show/Hide custom input based on dropdown selection
    if (DurationDropDown = "Custom") {
        GuiControl, Show, CustomLabel
        GuiControl, Show, CustomDurationInput
        GuiControl, Show, CustomDurationUpDown
    } else {
        GuiControl, Hide, CustomLabel
        GuiControl, Hide, CustomDurationInput
        GuiControl, Hide, CustomDurationUpDown
    }
    return

ModeDropDownChange:
    Gui, Submit, NoHide
    
    ; Show/Hide shake size based on mode selection
    if (ModeDropDown = "Mouse Shake" || ModeDropDown = "Mouse Move") {
        GuiControl, Show, ShakeSizeLabel
        GuiControl, Show, ShakeSizeInput
        GuiControl, Show, ShakeSizeUpDown
    } else {
        GuiControl, Hide, ShakeSizeLabel
        GuiControl, Hide, ShakeSizeInput
        GuiControl, Hide, ShakeSizeUpDown
    }
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
    global count, startTime, GuiVisible, durationMode, endTimestamp, keepAwakeMode, interval
    global smartMode, smartModeSkipping
    
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
    
    ; Build status text with mode and frequency
    statusText := "Mode: " . keepAwakeMode . " | Frequency: " . interval . "s"
    
    ; Add smart mode skip indicator
    if (smartMode && smartModeSkipping) {
        statusText := statusText . " | [Smart Mode: Skipping]"
    }
    
    ; Add remaining time if in Timed mode
    if (durationMode = "Timed") {
        remainingMs := endTimestamp - A_TickCount
        if (remainingMs > 0) {
            remainingSec := Floor(remainingMs / 1000)
            if (remainingSec >= 60) {
                remMin := Floor(remainingSec / 60)
                remSec := Mod(remainingSec, 60)
                remainingStr := remMin . "m " . remSec . "s remaining"
            } else {
                remainingStr := remainingSec . "s remaining"
            }
            statusText := statusText . " | " . remainingStr
        }
    }
    
    ; Update GUI controls
    GuiControl,, RunTimeText, % "Keeping your PC awake for: " . timeStr
    GuiControl,, StatsText, % statusText
    
    ; Update tray tooltip
    Menu, Tray, Tip, % "Keep-Awake: " . timeStr . " | Movements: " . count
    return

ShakeMouse:
    global count, shakeSize, quiet, hasArgs, keepAwakeMode, smartMode, smartModeThreshold
    global durationMode, endTimestamp, notifyWhenStopped, smartModeSkipping
    
    ; Check if duration has expired (Timed mode)
    if (durationMode = "Timed" && A_TickCount >= endTimestamp) {
        Gosub, StopKeepAwake
        return
    }
    
    ; Smart Mode: Check if user is actually active
    if (smartMode && A_TimeIdlePhysical < smartModeThreshold) {
        ; User is active, skip this cycle
        smartModeSkipping := true
        return
    }
    
    ; Clear skip indicator
    smartModeSkipping := false
    
    count++
    
    ; Get current mouse position
    MouseGetPos, currentX, currentY
    
    ; Execute different keep-awake methods based on mode
    if (keepAwakeMode = "Mouse Shake") {
        ; Shake mouse: move right then back to original position
        MouseMove, % currentX + shakeSize, % currentY, 0
        Sleep, 50
        MouseMove, %currentX%, %currentY%, 0
    }
    else if (keepAwakeMode = "Mouse Move") {
        ; Move mouse to a different position and back
        MouseMove, % currentX + shakeSize, % currentY + shakeSize, 0
        Sleep, 50
        MouseMove, %currentX%, %currentY%, 0
    }
    else if (keepAwakeMode = "Key Press") {
        ; Send Shift key (harmless)
        Send, {Shift}
    }
    else if (keepAwakeMode = "F15") {
        ; Send F15 key (safe, non-intrusive)
        Send, {F15}
    }
    
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

StopKeepAwake:
    global notifyWhenStopped, hasArgs
    
    ; Stop the timer
    SetTimer, ShakeMouse, Off
    
    ; Show notification if enabled
    if (notifyWhenStopped) {
        TrayTip, Keep-Awake, Keep-Awake session has ended., 5, 1
    }
    
    ; Update GUI if visible
    if (!hasArgs) {
        GuiControl,, RunTimeText, Session completed!
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
