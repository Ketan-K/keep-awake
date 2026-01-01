; ⏰ Keep-Awake - AutoHotkey Version
; Keep your PC awake with automated mouse movements
; Author: Ketan-K

#NoEnv
#SingleInstance Force
SetBatchLines, -1

; Default configuration
global interval := 60  ; seconds
global moveSize := 10  ; pixels
global quiet := false
global count := 0

; Parse command-line arguments
Loop, %0%
{
    param := %A_Index%
    if (param = "--help") {
        ShowHelp()
        ExitApp
    }
    else if (param = "--quiet") {
        quiet := true
    }
    else if (param = "--interval") {
        nextIndex := A_Index + 1
        if (nextIndex <= %0%) {
            interval := %nextIndex%
            if (interval < 1)
                interval := 60
        }
    }
    else if (param = "--move-size") {
        nextIndex := A_Index + 1
        if (nextIndex <= %0%) {
            moveSize := %nextIndex%
            if (moveSize < 1)
                moveSize := 10
        }
    }
}

; Show ASCII art banner and header (unless quiet)
if (!quiet) {
    FileAppend,
    (
`n╦╔═╔═╗╔═╗╔═╗  ╔═╗╦ ╦╔═╗╦╔═╔═╗  ☕
╠╩╗║╣ ║╣ ╠═╝  ╠═╣║║║╠═╣╠╩╗║╣   
╩ ╩╚═╝╚═╝╩    ╩ ╩╚╩╝╩ ╩╩ ╩╚═╝  

⏰ Keep-Awake is running ☕
   Interval: %interval%s | Move Size: %moveSize%px

┌───────┬─────────────┬─────────────────┬────────────┬─────────────────┐
│ Count │ Time        │ Current         │ Offset     │ New             │
├───────┼─────────────┼─────────────────┼────────────┼─────────────────┤
    ), *
}

; Start the mouse movement timer
SetTimer, MoveMouseRandomly, % interval * 1000
return

MoveMouseRandomly:
{
    global count, moveSize, quiet
    count++
    
    ; Get current mouse position
    MouseGetPos, currentX, currentY
    
    ; Generate random offsets
    Random, offsetX, % -moveSize, %moveSize%
    Random, offsetY, % -moveSize, %moveSize%
    
    ; Calculate new position
    newX := currentX + offsetX
    newY := currentY + offsetY
    
    ; Move the mouse
    MouseMove, %newX%, %newY%, 0
    
    ; Print row (unless quiet)
    if (!quiet) {
        FormatTime, currentTime, , HH:mm:ss tt
        
        ; Format strings with padding
        countStr := PadLeft(count, 5)
        timeStr := PadRight(currentTime, 11)
        currentStr := PadRight("[" . currentX . ", " . currentY . "]", 15)
        offsetStr := PadRight("[" . offsetX . ", " . offsetY . "]", 10)
        newStr := PadRight("[" . newX . ", " . newY . "]", 15)
        
        FileAppend, │ %countStr% │ %timeStr% │ %currentStr% │ %offsetStr% │ %newStr% │`n, *
    }
    return
}

ShowHelp() {
    help =
    (
`n╦╔═╔═╗╔═╗╔═╗  ╔═╗╦ ╦╔═╗╦╔═╔═╗  ☕
╠╩╗║╣ ║╣ ╠═╝  ╠═╣║║║╠═╣╠╩╗║╣   
╩ ╩╚═╝╚═╝╩    ╩ ╩╚╩╝╩ ╩╩ ╩╚═╝  

Keep your PC awake while you're away!

Usage: keep-awake.exe [options]

Options:
  --interval <seconds>    Set interval between movements (default: 60)
  --move-size <pixels>    Set maximum movement size (default: 10)
  --quiet                 Suppress console output
  --help                  Show this help message

Examples:
  keep-awake.exe --interval 30 --move-size 5
  keep-awake.exe --quiet
  keep-awake.exe --help
    )
    FileAppend, %help%`n, *
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

; Keep script running
#Persistent
