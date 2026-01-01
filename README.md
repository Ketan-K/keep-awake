# ⏰ Keep-Awake

> Your PC's personal coffee! Never sleep again! ☕💻

[![Version](https://img.shields.io/github/v/release/Ketan-K/keep-awake?style=flat-square)](https://github.com/Ketan-K/keep-awake/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-Windows-blue?style=flat-square)](https://github.com/Ketan-K/keep-awake)
[![Node](https://img.shields.io/badge/node-%3E%3D14-brightgreen?style=flat-square)](https://nodejs.org)
[![Downloads](https://img.shields.io/github/downloads/Ketan-K/keep-awake/total?style=flat-square)](https://github.com/Ketan-K/keep-awake/releases)

Keep-Awake is a lightweight, configurable tool that prevents your Windows PC from going to sleep by subtly moving your mouse at regular intervals. Perfect for keeping your status "Active" during presentations, long downloads, or when you just need your computer to stay awake!

## ✨ Features

- 🖱️ **Smart Mouse Movement** - Random micro-movements that won't disrupt your work
- ⚙️ **Fully Configurable** - Adjust interval and movement size via command-line
- 🤫 **Quiet Mode** - Run silently in the background without console output
- 📊 **Real-time Monitoring** - Beautiful table showing movement history with timestamps
- 🎯 **Lightweight** - Minimal resource usage, runs in the background
- 📦 **Portable** - Standalone .exe available (no Node.js required!)
- ☕ **Coffee-Powered** - ASCII art that'll wake you up too!

## 🚀 Quick Start

### Option 1: Use Pre-built Executable (No Installation Required!)

1. Download `keep-awake.exe` from [Releases](https://github.com/Ketan-K/keep-awake/releases)
2. Double-click to run with default settings
3. Or use command-line for custom configuration:
   ```bash
   keep-awake.exe --interval 30 --move-size 5
   ```

### Option 2: Run with Node.js

```bash
# Clone the repository
git clone https://github.com/Ketan-K/keep-awake.git
cd keep-awake

# Install dependencies
npm install

# Run with default settings (60 second intervals, 10px movement)
npm start

# Or try different modes
npm run start:slow   # 120s intervals, 5px movement
npm run start:fast   # 30s intervals, 15px movement
npm run start:quiet  # Silent mode
```

## 🎮 Usage

### Command-Line Options

```bash
keep-awake [options]

Options:
  --interval <seconds>    Set interval between movements (default: 60)
  --move-size <pixels>    Set maximum movement size (default: 10)
  --quiet                 Suppress console output
  --help                  Show help message with ASCII art ☕

Examples:
  keep-awake --interval 30 --move-size 5    # Move every 30s with 5px range
  keep-awake --quiet                         # Run silently
  keep-awake --help                          # Show that beautiful ASCII art!
```

### Configuration Options

| Option | Description | Default | Range |
|--------|-------------|---------|-------|
| `--interval` | Time between movements (seconds) | 60 | 1-3600 |
| `--move-size` | Maximum pixel offset from current position | 10 | 1-100 |
| `--quiet` | Suppress all console output | false | - |
| `--help` | Display help with ASCII art | - | - |

### Example Output (Default Mode)

```
⏰ Keep-Awake is running ☕
   Interval: 60s | Move Size: 10px

┌───────┬─────────────┬─────────────────┬────────────┬─────────────────┐
│ Count │ Time        │ Current         │ Offset     │ New             │
├───────┼─────────────┼─────────────────┼────────────┼─────────────────┤
│     1 │ 10:30:15 AM │ [1920, 540]     │ [3, -7]    │ [1923, 533]     │
│     2 │ 10:31:15 AM │ [1923, 533]     │ [-2, 5]    │ [1921, 538]     │
```

## 🔨 Building from Source

```bash
# Install dependencies
npm install

# Build standalone executable
npm run build

# Build and compress with UPX
npm run build:release

# Output will be in dist/keep-awake.exe (~21MB compressed)
```

## 🎯 Use Cases

- 📊 **Presentations** - Keep your screen active during long demos
- 💬 **Teams/Slack** - Stay "Active" while reading documentation
- 📥 **Downloads** - Prevent sleep during large file transfers
- 🎥 **Streaming** - Keep your PC awake during broadcasts
- 📚 **Reading** - No interruptions while you're deep in that article
- ☕ **Coffee Breaks** - Because sometimes you need both kinds of awakeness!

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
