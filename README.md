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

<img width="232" height="69" alt="Screenshot 2026-03-02 at 06 36 15" src="https://github.com/user-attachments/assets/931c75cd-76b7-421a-b749-740bf14222eb" /><br /><br />
<img width="230" height="70" alt="Screenshot 2026-03-02 at 06 38 38" src="https://github.com/user-attachments/assets/c29cee81-983c-4a5d-b6ee-1ff728494c20" /><br /><br />
<img width="349" height="231" alt="Screenshot 2026-03-02 at 06 51 54" src="https://github.com/user-attachments/assets/52fcf655-9b35-421d-a1ad-b4baf1564772" />

## Installation

1. Download the latest release from [GitHub Releases](https://github.com/harysuryanto/MemVibe/releases)
2. Drag `MemVibe.app` to your `/Applications` folder
3. Run the following command in Terminal to bypass macOS security:
   ```bash
   xattr -cr /Applications/MemVibe.app
   ```
4. Open MemVibe from your Applications folder
5. It will appear in your menu bar

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
