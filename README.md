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
   # --sound <path or url to audio file>, supports local path or url, wav/mp3/aac
   # --image <path or url to image>, supports local path or url, supports animated GIF/APNG
   zwuush --sound https://upload.wikimedia.org/wikipedia/commons/d/da/Discovery_-_Computers_are_in_Control.mp3 --image https://upload.wikimedia.org/wikipedia/commons/d/d6/Cat_Laptop_-_Idil_Keysan_-_Wikimedia_Giphy_stickers_2019.gif
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
