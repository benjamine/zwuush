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
   # specify a gif and optional audio file, or a video file (local path or remote url)
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
