import AVFoundation

class AudioManager: NSObject {
    private var audioPlayer: AVAudioPlayer?
    private var completionHandler: (() -> Void)?
    
    func playSound(from url: URL, completion: @escaping () -> Void) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            completionHandler = completion
            audioPlayer?.play()
        } catch {
            print("Error loading audio file: \(error.localizedDescription)")
            completion()
        }
    }
}

extension AudioManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        completionHandler?()
    }
}