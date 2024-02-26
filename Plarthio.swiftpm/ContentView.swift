import SwiftUI

    
struct ContentView: View {
    @StateObject private var camViewModel = CameraFeedHandler() 
    
    var body: some View {
        NavigationStack {
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color(red: 0.7, green: 0.4, blue: 0.1), Color(red: 0.5, green: 0.1, blue: 0.1)]), startPoint: .top, endPoint: .bottom)
                
                VStack {
                    Spacer()
                        .frame(height: 120)
                    Text("Plarthio")
                        .font(.system(size: 80, weight: .bold, design: .serif))
                        .foregroundStyle(Color(red: 0.9, green: 0.8, blue: 0.6))
                    
                    Spacer()
                        .frame(height: 120)
                    
                    HStack{ 
                        VStack {
                            NavigationLink(destination: GameCameraView(camViewModel.captureFrame, initIsColorCatchGame: true)) {
                                Image("colorCatchPic")
                                    .resizable()
                                    .frame(width: 250, height: 250)
                                    .cornerRadius(20)
                            }
                            Text("Color Catch")
                                .font(.system(size: 30, weight: .bold))
                        }
                        
                        Spacer()
                            .frame(width:100)
                        
                        VStack {
                            NavigationLink(destination: GameCameraView(camViewModel.captureFrame, initIsColorCatchGame: false)) {
                                Image("dodgeObsPic")
                                    .resizable()
                                    .frame(width: 250, height: 250)
                                    .cornerRadius(20)
                            }
                            Text("Dodge Obs")
                                .font(.system(size: 30, weight: .bold))
                        }
                    }
                    Spacer()
                    
                    Text("Play your way to relief with fun hand arthiritis exercises!")
                        .font(.system(size: 28, weight: .bold))
                        .padding(.horizontal, 20)
                    Spacer()
                        .frame(height: 25)
                    Text("The minigames above target different hand joint motion to lighten discomfort. Click on any title to know more about the hand exercises involved in the game")
                        .font(.system(size: 21, weight: .regular))
                        .padding(.horizontal, 20)
                    Spacer()
                    Text("Required orientation: Portrait Up")
                        .font(.system(size: 12))
                        .padding(.all, 10)
                }
            }
        }
        .tint(Color.black)
    }
}      

struct GameCameraView: View {
    
    private var isColorCatchGame: Bool
    private var capturedFrame: CGImage?
    
    init(_ initCamViewModel: CGImage?, initIsColorCatchGame: Bool) {
        isColorCatchGame = initIsColorCatchGame
        capturedFrame = initCamViewModel
    } 
    
    var body: some View {
        if let captureFrame = capturedFrame {
            ZStack {
                CameraFeedView(captureFrame)
                Color.gray.opacity(0.7)
                   
                if isColorCatchGame {
                    ColorCatchView()
                   
                } else {
                    DodgeObsView()
                    
                }
            }
               .ignoresSafeArea(.all)
        } else { CameraFeedView(capturedFrame) }
    }
}
