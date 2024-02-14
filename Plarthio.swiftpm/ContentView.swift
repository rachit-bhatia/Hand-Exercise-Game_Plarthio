import SwiftUI
    
    
struct ContentView: View {
    @StateObject private var camViewModel = CameraFeedHandler() 
    
    var body: some View {
        if let captureFrame = camViewModel.captureFrame {
            ZStack {
                CameraFeedView(captureFrame)
                    .ignoresSafeArea(.all)
                Color.gray.opacity(0.7)
            }
        } else { CameraFeedView(camViewModel.captureFrame) }
    }
}      


