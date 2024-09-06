# zwuush

## Requirements

- macOS 12+

## Installation

``` bash
brew tap benjamine/homebrew-tap
brew install zwuush
```

## Usage

```bash
   # use a video file (local path or remote url), transparency is supported
   zwuush https://benjamine.github.io/zwuush/wow.mov
   # or (animated) image (eg. gif), and (optional) audio
   zwuush https://upload.wikimedia.org/wikipedia/commons/d/da/Discovery_-_Computers_are_in_Control.mp3 https://upload.wikimedia.org/wikipedia/commons/d/d6/Cat_Laptop_-_Idil_Keysan_-_Wikimedia_Giphy_stickers_2019.gif
```

## Development

### Requirements

- Swift 5.6 or later
- Xcode 13 or later

```bash
   git clone https://github.com/benjamine/zwuush.git
   cd zwuush
   swift build --configuration release
   .build/release/zwuush --help
```
