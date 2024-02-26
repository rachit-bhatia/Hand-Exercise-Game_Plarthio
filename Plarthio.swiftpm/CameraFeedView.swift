import SwiftUI
import AVFoundation

struct CameraFeedView: View {
    private var capturedImage: CGImage?
    private let imageLabel = Text("Camera feed")
    
    public init (_ capturedImage: CGImage?) {
        self.capturedImage = capturedImage
    } 
    
    var body: some View {
        GeometryReader { geometry in 
            if let capturedImage {
                Image(capturedImage, scale: 1, orientation: .upMirrored, label: imageLabel)
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
            else {
                ZStack {
                    Color.gray
                    Text("Unable to access device camera")
                        .font(.system (size: 22))
                }
                 .ignoresSafeArea(.all)
            }
        }
       
    }
}
   
        
