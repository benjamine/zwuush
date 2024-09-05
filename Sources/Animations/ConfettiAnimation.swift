import SwiftUI
import AppKit

struct ConfettiAnimation: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.clear.cgColor
        
        let emitter = CAEmitterLayer()
        emitter.emitterShape = .point
        emitter.emitterPosition = CGPoint(x: NSScreen.main!.frame.width / 2, y: NSScreen.main!.frame.height / 2)
        emitter.emitterSize = CGSize(width: 100, height: 100) // Increase size to ensure particles are visible
        emitter.renderMode = .additive
        emitter.zPosition = 1 // Ensure emitter is on top
        
        let particle = CAEmitterCell()
        particle.birthRate = 100
        particle.lifetime = 5.0
        particle.velocity = 150
        particle.velocityRange = 100
        particle.emissionRange = .pi * 2
        particle.spin = 2.0
        particle.spinRange = 1.0
        particle.color = NSColor.red.cgColor
        particle.contents = createZwuushImage()
        particle.scale = 0.2
        particle.scaleRange = 0.2
        
        emitter.emitterCells = [particle]
        view.layer?.addSublayer(emitter)
        
        // Add click gesture recognizer
        let clickRecognizer = NSClickGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleClick(_:)))
        view.addGestureRecognizer(clickRecognizer)

        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
    
    private func createZwuushImage() -> CGImage? {
        let size = CGSize(width: 20, height: 20)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitsPerComponent = 8
        let bytesPerRow = Int(size.width) * 4 // 4 bytes per pixel (RGBA)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        guard let context = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        ) else { return nil }
        
        context.setFillColor(NSColor.red.cgColor) // Red color
        context.fill(CGRect(origin: .zero, size: size))
        
        return context.makeImage()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject {
        @objc func handleClick(_ sender: NSClickGestureRecognizer) {
            print("exiting after click")
            NSApplication.shared.terminate(nil)
        }
    }
}