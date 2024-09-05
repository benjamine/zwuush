import AVFoundation

class AudioManager: NSObject, ObservableObject  {
    private var audioPlayer: AVAudioPlayer?
    private var completionHandler: (() -> Void)?

    func play(from pathOrURL: String, completion: @escaping () -> Void) {
        if let url = URL(string: pathOrURL), (url.scheme == "http" || url.scheme == "https") {
            // Handle remote URL
            downloadAndPlayAudio(from: url, completion: completion)
        } else {
            // Handle local file path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: pathOrURL) {
                let fileURL = URL(fileURLWithPath: pathOrURL)
                playFromFileUrl(from: fileURL, completion: completion)
            } else {
                print("sound file not found at path: \(pathOrURL)")
            }
        }
    }

    func playFromFileUrl(from url: URL, completion: @escaping () -> Void) {
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

    private func downloadAndPlayAudio(from url: URL, completion: @escaping () -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching audio from URL: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion()
                }
                return
            }
            guard let data = data else {
                print("No data received from URL.")
                DispatchQueue.main.async {
                    completion()
                }
                return
            }

            // Write the data to a temporary file
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("tempAudio.\(url.pathExtension)")
            do {
                try data.write(to: tempURL)
                self.playFromFileUrl(from: tempURL, completion: completion)
            } catch {
                print("Error writing audio data to temporary file: \(error.localizedDescription)")
                completion()
            }
        }
        task.resume()
    }
}

extension AudioManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        completionHandler?()
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio decode error: \(error?.localizedDescription ?? "Unknown error")")
        completionHandler?()
    }
}
