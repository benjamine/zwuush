import Foundation
import UniformTypeIdentifiers

let version = "0.0.2"

enum AnimationType {
    case video
    case image
    case none
}

struct ArgumentsResult {
    let animationType: AnimationType
    let mediaFile: String?
    let soundFile: String?
    let errorMessage: String?
}

func parseArguments(_ arguments: [String]) -> ArgumentsResult {
    var soundFile: String?
    var mediaFile: String?
    var animationType: AnimationType = .none
    var errorMessage: String?

    // Function to get MIME type from file extension
    func mimeType(forPath path: String) -> String? {
        let fileExtension = (path as NSString).pathExtension
        let utType = UTType(filenameExtension: fileExtension)
        return utType?.preferredMIMEType
    }

    // Iterate over arguments
    for arg in arguments {
        if (arg == "--version") {
            print("Zwuush v\(version)")
            exit(0)
        }

        guard let mimeType = mimeType(forPath: arg) else { continue }
        if mimeType.starts(with: "video/") {
            if (soundFile != nil) {
                errorMessage = "Error: Cannot specify both video and sound files."
                break
            } else if animationType == .image {
                errorMessage = "Error: Cannot specify both video and image files."
                break
            } else if animationType == .video {
                errorMessage = "Error: Cannot specify multiple videos."
                break
            } else {
                animationType = .video
                mediaFile = arg
            }
        } else if mimeType.starts(with: "image/") {
            if animationType == .none {
                animationType = .image
                mediaFile = arg
            } else if animationType == .image {
                errorMessage = "Error: Cannot specify multiple images."
                break
            } else {
                errorMessage = "Error: Cannot specify both video and image files."
                break
            }
        } else if mimeType.starts(with: "audio/") {
            if animationType == .video {
                errorMessage = "Error: Cannot specify both video and sound files."
                break
            } else {
                soundFile = arg
            }
        }
    }

    if (animationType == .none && soundFile == nil) {
        errorMessage = "Error: specify a path or url to an image, gif, audio, or a video."
    }

    return ArgumentsResult(animationType: animationType, mediaFile: mediaFile, soundFile: soundFile, errorMessage: errorMessage)
}