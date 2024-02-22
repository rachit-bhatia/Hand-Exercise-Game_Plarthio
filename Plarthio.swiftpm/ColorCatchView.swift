import SwiftUI


struct ColorCatchView: View {
    private let collectorWidth: CGFloat = 100, collectorHeight: CGFloat = 100
    private var colorCatchHandler: ColorCatchHandler
    private let rotationDuration: Double = 3
    
    //color tray rotation
    @State private var isRotatingClockwise = true
    @State private var trayRotationAngle: CGFloat = 0
    
    //coin rotation
    @State private var coinRotation: CGFloat = 0
    @State private var coinYOffset: CGFloat = 0
    @State private var currentCoinColor: Color
    @State private var coinOpacity: Double = 1
    private let coinFallDuration: Double = 3
    
    //color tray
    private let colorArray = [Color.blue, Color.purple, Color.orange, Color.red]
    private let colorAngleDict: [Color:Double]
    
    //scorekeeper
    @State private var gameScore = 0
    @State private var scoreIndicatorColor = Color.black
    private let scoreToWin = 5
    
    init () {
        self.currentCoinColor = colorArray.randomElement()!
        self.colorAngleDict = [colorArray[0]: 0.0,
                               colorArray[1]: 270.0,
                               colorArray[2]: 90.0,
                               colorArray[3]: 180.0]
        self.colorCatchHandler = ColorCatchHandler(initColorArray: colorArray, initColorAngleDict: colorAngleDict)
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
                    .shadow(radius: 5, y: 5)
                    .offset(y:30)
                    .zIndex(2)
                    .rotation3DEffect(.degrees(30), axis: (x: 1, y:0, z:0))
                    
                
                //coin
                Circle()
                    .fill(self.currentCoinColor) 
                    .stroke(Color.black, lineWidth: 3)
                    .frame(width: collectorWidth-20, height: collectorHeight-20)
                    .rotation3DEffect(.degrees(coinRotation), axis: (x: 0, y:1, z:0))
                    .opacity(self.coinOpacity)
                    .offset(y: coinYOffset)
                    .zIndex(1)
                    .onAppear{
                        withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                            self.coinRotation = 360
                        }
                        
                        withAnimation(.linear(duration: coinFallDuration).repeatForever(autoreverses: false)) {
                            self.coinYOffset = 320
                        }
                        
                        Timer.scheduledTimer(withTimeInterval: coinFallDuration, repeats: true) { scoreScheduler in
                            
                            let isCorrectColorCaught = self.colorCatchHandler.checkIfScored(self.currentCoinColor)
                            
                            //change score based on color catch
                            if isCorrectColorCaught {
                                self.gameScore += 1
                                withAnimation(.linear(duration: 0.2)) {
                                    self.scoreIndicatorColor = Color(red: 0, green: 0.5, blue: 0)
                                }
                            } else {
                                self.gameScore -= 1
                                withAnimation(.linear(duration: 0.2)) {
                                    self.scoreIndicatorColor = Color(red: 1, green: 0, blue: 0)
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                withAnimation(.easeIn(duration: 0.2)) {
                                    self.scoreIndicatorColor = Color.black
                                }
                            }
                            
                            //end game if winning score achieved
                            if self.gameScore == self.scoreToWin {
                                withAnimation(.linear(duration: 0)) {
                                    self.coinOpacity = 0
                                    self.coinRotation = 0
                                    self.coinYOffset = 0
                                    scoreScheduler.invalidate()
                                }
                            } 
                            
                            withAnimation(.easeIn(duration: 0.3)) {
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
                   self.colorCatchHandler.recordRotationAngle(self.isRotatingClockwise)
                   withAnimation(.linear(duration: rotationDuration).repeatForever(autoreverses: false)) {
                      self.trayRotationAngle = 360
                   }
                }
                
                Spacer()
                    .frame(height: 50)
                
                Text("Score: \(self.gameScore)")
                    .font(.system(size: 25))
                    .frame(width: 250)
                    .padding(.vertical, 10)
                    .background(self.scoreIndicatorColor.opacity(0.7))
                    .cornerRadius(20)
                    .animation(.linear(duration: 0), value: self.gameScore)

                
                Spacer()
                
                Button(action: {
                    self.colorCatchHandler.stopRecordingRotationAngle()
                    withAnimation(.linear(duration: 0)) {
                        self.trayRotationAngle = self.colorCatchHandler.getCurrentAngle()
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
                    self.colorCatchHandler.recordRotationAngle(self.isRotatingClockwise)
                }) {
                    Text("Start")
                        .bold()
                        .font(.system(size: 25))
                        .frame(width: 200)
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
