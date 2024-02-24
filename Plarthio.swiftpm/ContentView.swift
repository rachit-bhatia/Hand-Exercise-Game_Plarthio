import SwiftUI

    
struct ContentView: View {
    @StateObject private var camViewModel = CameraFeedHandler() 
    
    var body: some View {
        if let captureFrame = camViewModel.captureFrame {
            ZStack {
                CameraFeedView(captureFrame)
                Color.gray.opacity(0.8)
                    .ignoresSafeArea(.all)
                DodgeObsView()
            }
        } else { CameraFeedView(camViewModel.captureFrame) }
    }
}      
