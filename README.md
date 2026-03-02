# MemVibe

A lightweight, high-performance macOS menu bar utility that displays real-time memory usage with intuitive emoji-based feedback.

![Platform](https://img.shields.io/badge/platform-macOS-orange)
![Swift](https://img.shields.io/badge/Swift-5.9+-orange)

## Features

- **Real-time Memory Monitoring** - Uses Mach Kernel APIs for accurate memory tracking
- **Visual Feedback** - 5-tier emoji system shows memory status at a glance:
  - 😀 Idle (0-25%)
  - 🙂 Light (25-50%)
  - 🧐 Moderate (50-75%)
  - 😰 High (75-90%)
  - 🥵 Critical (90%+)
- **Customizable Display** - Choose between emoji, percentage, or both
- **Adjustable Refresh Rate** - Select from 1s, 2s, 5s, 15s, 30s, or 1m intervals
- **Auto-Launch** - Start automatically at login
- **Persistent Settings** - Your preferences are saved automatically

## Screenshots

![MemVibe Menu Bar](./screenshots/menu-bar.png)
![MemVibe Settings](./screenshots/settings.png)

## Installation

1. Download the latest release from [GitHub Releases](https://github.com/harysuryanto/MemVibe/releases)
2. Open the `.app` file
3. MemVibe will appear in your menu bar

## Usage

- Click the menu bar icon to access settings
- Toggle display mode (Emoji / Percentage / Both)
- Adjust refresh rate as needed
- Enable "Launch at Login" for automatic startup
- Press `Q` or click "Quit MemVibe" to exit

## Requirements

- macOS 13.0 (Ventura) or later
- Apple Silicon or Intel Mac

## Building from Source

```bash
# Clone the repository
git clone https://github.com/harysuryanto/MemVibe.git

# Open in Xcode
open MemVibe.xcodeproj

# Build and run (Cmd + R)
```

## License

MIT License - see LICENSE file for details.

## Author

[Hary Suryanto](https://github.com/harysuryanto)
