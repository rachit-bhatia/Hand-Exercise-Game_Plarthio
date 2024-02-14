import SwiftUI
import AVFoundation

struct CameraFeedView: View {
    private var capturedImage: CGImage?
    private let imageLabel = Text("Camera feed")
    
    public init (_ capturedImage: CGImage?) {
        self.capturedImage = capturedImage
//        print ("Captured image is \(capturedImage)")
    } 
    
    var body: some View {
        if let capturedImage {
                Image(capturedImage, scale: 1.0, orientation: .upMirrored, label: imageLabel)
        }
        else {
            ZStack {
                Color.gray
                Text("Unable to access device camera. Please review camera permissions")
                    .font(.system (size: 22))
            }
        }
    }
    
    
}
   
        
