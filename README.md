# ☕ Keep-Awake

> Your PC's personal coffee! Never sleep again! ☕💻

[![Version](https://img.shields.io/github/v/release/Ketan-K/keep-awake?style=flat-square)](https://github.com/Ketan-K/keep-awake/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-Windows-blue?style=flat-square)](https://github.com/Ketan-K/keep-awake)
[![Downloads](https://img.shields.io/github/downloads/Ketan-K/keep-awake/total?style=flat-square)](https://github.com/Ketan-K/keep-awake/releases)

Keep-Awake is a lightweight, configurable tool that prevents your Windows PC from going to sleep by performing quick mouse shakes at regular intervals. The mouse moves slightly and returns to its original position - completely unobtrusive! Perfect for keeping your status "Active" during presentations, long downloads, or when you just need your computer to stay awake!

## ✨ Features

- 🖱️ **Smart Mouse Shake** - Quick shake motion that returns to original position
- 🎨 **User-Friendly GUI** - Beautiful status window showing uptime, settings, and statistics
- ⚙️ **Fully Configurable** - Adjust interval and shake size via GUI or command-line
- 📊 **Real-time Monitoring** - Live stats with formatted time display (Xm Ys)
- 🎯 **Dual Mode** - GUI mode by default, CLI mode with arguments
- 🤫 **Quiet Mode** - Run silently in the background without console output
- ☕ **Custom Coffee Icon** - Distinctive tray icon for easy access
- 📦 **Truly Portable** - Single standalone .exe (no dependencies, no extra files!)
- 🚀 **Lightweight** - ~1.2MB, minimal resource usage

## 🚀 Quick Start

### Option 1: Use Pre-built Executable (Recommended!)

1. Download `keep-awake.exe` from [Releases](https://github.com/Ketan-K/keep-awake/releases)
2. **Double-click to launch** - Opens a GUI status window!
   - Shows running time (e.g., "2m 30s")
   - Displays mouse shake statistics
   - Click "Run in Background" to minimize to tray
   - Click "Exit" to close the application

3. Or run from command line for CLI mode:
   ```bash
   keep-awake.exe --interval 30 --shake-size 5
   ```

> **✨ Truly Portable:** Single .exe file (~1.2MB) with embedded coffee icon - works anywhere on Windows!

### Option 2: Run from Source

```bash
# Clone the repository
git clone https://github.com/Ketan-K/keep-awake.git
cd keep-awake

# Run the AutoHotkey script directly (requires AutoHotkey v1.1)
"C:\Program Files\AutoHotkey\AutoHotkey.exe" keep-awake.ahk

# Or edit keep-awake.ahk with any text editor and customize
```

## 🎮 Usage

### GUI Mode (Default)

Simply double-click `keep-awake.exe` to launch the status window:

**GUI Interface:**
- Clean white material design with green status bar
- Real-time uptime display (formatted as "2m 15s")
- Mouse shake counter
- Editable settings with spin boxes:
  - Interval (1-3600 seconds)
  - Shake Size (1-100 pixels)
- "Apply Settings" button (shows "Applied!" when clicked)
- "More Info / Contribute on GitHub" button
- "Run in Background" and "Exit" buttons

**Tray Icon Features:**
- Coffee cup icon in system tray
- Right-click → "Open" to show status window
- Right-click → "Exit" to close application
- Hover for tooltip with uptime and shake count

### CLI Mode (Advanced)

Run with arguments to use command-line mode with table output:

```bash
keep-awake.exe [options]

Options:
  --interval <seconds>    Set interval between shakes (default: 60)
  --shake-size <pixels>   Set shake distance (default: 10)
  --quiet                 Suppress console output
  --help                  Show help message

Examples:
  keep-awake.exe                              # GUI mode (default)
  keep-awake.exe --interval 30 --shake-size 5 # CLI mode with custom settings
  keep-awake.exe --quiet                      # CLI silent mode
  keep-awake.exe --help                       # Show help
```

### Configuration Options

| Option | Description | Default | Range |
|--------|-------------|---------|-------|
| `--interval` | Time between shakes (seconds) | 60 | 1-3600 |
| `--shake-size` | Shake distance in pixels | 10 | 1-100 |
| `--quiet` | Suppress all console output (CLI mode only) | false | - |
| `--help` | Display help message | - | - |

### CLI Mode Output Example

When run with arguments, displays running status:

```
================================
KEEP-AWAKE is running
Interval: 60s | Shake Size: 10px
================================

Mouse shakes performed every 60 seconds...
Press Ctrl+C to exit
```

**Note:** The shake motion moves the mouse slightly right and immediately back to its original position. No position tracking is shown in CLI mode since the mouse returns to where it started.

## 🔨 Building from Source

### Prerequisites
- [AutoHotkey v1.1](https://www.autohotkey.com/) installed
- Node.js (for build script only)

### Build Steps

```bash
# Clone the repository
git clone https://github.com/Ketan-K/keep-awake.git
cd keep-awake

# Build the executable
npm run build

# Output: dist/keep-awake.exe (~1.2MB standalone file)
```

### Manual Build

```bash
# Compile with AutoHotkey
"C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in keep-awake.ahk /out keep-awake.exe /icon keep-awake.ico
```

**Note:** The `keep-awake.ico` coffee cup icon is included in the repository and embedded into the executable during compilation.

## 🎯 Use Cases

- 📊 **Presentations** - Keep your screen active during long demos
- 💬 **Teams/Slack** - Stay "Active" while reading documentation
- 📥 **Downloads** - Prevent sleep during large file transfers
- 🎥 **Streaming** - Keep your PC awake during broadcasts
- 📚 **Reading** - No interruptions while you're deep in that article
- 🧪 **Testing** - Long-running automated tests or builds
- ☕ **Coffee Breaks** - Because sometimes you need both kinds of awakeness!

## 🎨 GUI Features

- **Real-time Status Display** - See uptime formatted as "Xm Ys" for easy reading
- **Live Statistics** - Track mouse shake count in real-time  
- **Editable Settings** - Adjust interval (1-3600s) and shake size (1-100px) on the fly
- **Apply Feedback** - Button shows "Applied!" confirmation for 2 seconds
- **GitHub Integration** - "More Info / Contribute on GitHub" button opens repository
- **Tray Integration** - Coffee cup icon in system tray for quick access
- **Single Instance** - Prevents multiple windows from opening
- **Always On Top** - Status window stays visible (can be minimized to tray)
- **Clean Material Design** - Modern white interface with green status bar and blue accents

## ⚠️ Disclaimer

This tool is intended for **legitimate personal use** only. Please use responsibly and in accordance with your workplace policies. The author is not responsible for any misuse of this software. 

Remember: The best way to stay active is to actually *be* active! This tool is for those moments when you genuinely need your PC awake but can't interact with it. 😊

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/Ketan-K/keep-awake/issues).

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m '✨ Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 💖 Show Your Support

Give a ⭐️ if this project kept your PC awake!

---

<p align="center">Made with ☕ by <a href="https://github.com/Ketan-K">Ketan-K</a></p>
<p align="center">Keep calm and stay awake! 😴➡️😃</p>
