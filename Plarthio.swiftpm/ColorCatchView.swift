import SwiftUI


struct ColorCatchView: View {
    private let collectorWidth: CGFloat = 100, collectorHeight: CGFloat = 100
    private var colorCatchHandler: ColorCatchHandler?
    private let rotationDuration: Double = 3
    
    //tray rotation
    @State private var isRotatingClockwise = true
    @State private var trayRotationAngle: CGFloat = 0
    
    //coin rotation
    @State private var coinRotation: CGFloat = 0
    @State private var coinYOffset: CGFloat = 0
    private let colorArray = [Color.blue, Color.purple, Color.orange, Color.red]
    @State private var currentCoinColor: Color
    private let coinFallDuration: Double = 3
    
    init () {
        self.currentCoinColor = colorArray.randomElement()!
        self.colorCatchHandler = ColorCatchHandler()
    }

    var body: some View{
        ZStack {
            Color.gray
            VStack {
                
                Spacer()
                    .frame(height: 100)
                
                Rectangle()
                    .fill(Color.brown)
                    .stroke(Color.black, lineWidth: 2)
                    .frame(width: 150, height: 30)
                    .offset(y:30)
                    .zIndex(2)
                    .rotation3DEffect(.degrees(30), axis: (x: 1, y:0, z:0))
                    
                
                //coin
                Circle()
                    .fill(self.currentCoinColor) 
                    .stroke(Color.black, lineWidth: 3)
                    .frame(width: collectorWidth-20, height: collectorHeight-20)
                    .rotation3DEffect(.degrees(coinRotation), axis: (x: 0, y:1, z:0))
                    .offset(y: coinYOffset)
                    .zIndex(1)
                    .onAppear{
                        withAnimation(.linear(duration:1.5).repeatForever(autoreverses: false)) {
                            self.coinRotation = 360
                        }
                        
                        withAnimation(.linear(duration: coinFallDuration).repeatForever(autoreverses: false)) {
                            self.coinYOffset = 350
                        }
                        
                        Timer.scheduledTimer(withTimeInterval: coinFallDuration + 0.03, repeats: true) { _ in
                            withAnimation(.easeIn(duration: 0.2)) {
                                self.currentCoinColor = self.colorArray.randomElement()!
                            }
                        }
                    }
                
                Spacer()
                Spacer()
                
                //color tray
                ZStack {
                    Circle()
                        .fill(Color.black)
                        .frame(width:350, height:350)
                    
                    VStack {
                        Circle()
                            .fill(self.colorArray[0])
                            .frame(width: collectorWidth, height: collectorHeight)
                        
                        HStack {
                            Circle()
                                .fill(self.colorArray[1])
                                .frame(width: collectorWidth, height: collectorHeight)
                            
                            Spacer()
                                .frame(width:120)
                            
                            Circle()
                                .fill(self.colorArray[2])
                                .frame(width: collectorWidth, height: collectorHeight)
                        }
                        
                        Circle()
                            .fill(self.colorArray[3])
                            .frame(width: collectorWidth, height: collectorHeight)
                    }
                }
                .rotationEffect(.degrees(self.trayRotationAngle))
                .onAppear {
                    self.colorCatchHandler?.recordRotationAngle(self.isRotatingClockwise)
//                    withAnimation(.linear(duration: rotationDuration).repeatForever(autoreverses: false)) {
//                        self.trayRotationAngle = 360
//                    }
                }
                
                Spacer()
                
                Button(action: {
                    self.colorCatchHandler?.stopRecordingRotationAngle()
                    withAnimation(.linear(duration: 0)) {
                        self.trayRotationAngle = self.colorCatchHandler!.getCurrentAngle()
                    }
                    
                    let fullAngle: CGFloat
                    if self.isRotatingClockwise {
                        fullAngle = self.trayRotationAngle - 360
                    } else {
                        fullAngle = self.trayRotationAngle + 360
                    }
                    
                    withAnimation(.linear(duration: rotationDuration).repeatForever(autoreverses: false)) {
                        self.trayRotationAngle = fullAngle
                    }
                    self.isRotatingClockwise.toggle()
                    self.colorCatchHandler?.recordRotationAngle(self.isRotatingClockwise)
                }) {
                    Text("Start")
                        .bold()
                        .frame(width: 50)
                        .foregroundColor(.white)
                        .padding(.all, 10)
                        .background(Color.pink)
                        .cornerRadius(10)
                }
                Spacer()
            }
        }
    }
}


struct ColorCatchView_Previews: PreviewProvider {
    static var previews: some View {
        ColorCatchView()
    }
} 
