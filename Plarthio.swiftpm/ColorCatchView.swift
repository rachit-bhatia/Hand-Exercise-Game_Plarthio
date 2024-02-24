import SwiftUI


struct ColorCatchView: View {
    private let collectorWidth: CGFloat = 100, collectorHeight: CGFloat = 100
    private let rotationDuration: Double = 3
    private let fallDistance: CGFloat = 320
    
    static var detectedHandPose: String = ""
    
    //color tray rotation
    @State private var isRotatingClockwise = true
    @State private var updatedRotationAngle: CGFloat = 0
    @State private var currentRotationAngle: CGFloat = 0
    @State private var trayAngleScheduler: Timer?
    
    //coin rotation
    @State private var coinRotation: CGFloat = 0
    @State private var coinYOffset: CGFloat = 0
    @State private var currentCoinColor: Color
    @State private var coinOpacity: Double = 1
    private let coinFallDuration: Double = 3
    
    //color tray stored attributes
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
    }


    var body: some View{
        ZStack {
//            Color.gray
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
                    .fill(currentCoinColor) 
                    .stroke(Color.black, lineWidth: 3)
                    .frame(width: collectorWidth-20, height: collectorHeight-20)
                    .rotation3DEffect(.degrees(coinRotation), axis: (x: 0, y:1, z:0))
                    .opacity(coinOpacity)
                    .offset(y: coinYOffset)
                    .zIndex(1)
                    .onAppear{
                        withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                            self.coinRotation = 360
                        }
                        
                        withAnimation(.linear(duration: coinFallDuration).repeatForever(autoreverses: false)) {
                            self.coinYOffset = fallDistance
                        }
                        
                        Timer.scheduledTimer(withTimeInterval: coinFallDuration, repeats: true) { scoreScheduler in
                            let isCorrectColorCaught = self.checkIfScored(self.currentCoinColor)
                            
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
                    .frame(height: fallDistance - 100)
                
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
                .rotationEffect(.degrees(self.updatedRotationAngle))
                .onAppear {
                    self.recordRotationAngle(self.isRotatingClockwise)
                   withAnimation(.linear(duration: rotationDuration).repeatForever(autoreverses: false)) {
                      self.updatedRotationAngle = 360
                   }
                }
                .onChange(of: ColorCatchView.detectedHandPose, initial: false) {
                    
                    //run action only if hand pose and current rotation direction do not correspond 
                    if (ColorCatchView.detectedHandPose == "open_palm" && !isRotatingClockwise) || 
                       (ColorCatchView.detectedHandPose == "closed_fist" && isRotatingClockwise) {
                        
                        self.stopRecordingRotationAngle()
                        withAnimation(.linear(duration: 0)) {
                            self.updatedRotationAngle = self.currentRotationAngle
                        }
                        
                        let fullAngle: CGFloat
                        if self.isRotatingClockwise {
                            fullAngle = self.updatedRotationAngle - 360
                        } else {
                            fullAngle = self.updatedRotationAngle + 360
                        }
                        
                        withAnimation(.linear(duration: rotationDuration).repeatForever(autoreverses: false)) {
                            self.updatedRotationAngle = fullAngle
                        }
                        self.isRotatingClockwise.toggle()
                        self.recordRotationAngle(self.isRotatingClockwise)
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
                
//                Button(action: {
//                    self.stopRecordingRotationAngle()
//                    withAnimation(.linear(duration: 0)) {
//                        self.updatedRotationAngle = self.currentRotationAngle
//                    }
//                     
//                    let fullAngle: CGFloat
//                    if self.isRotatingClockwise {
//                        fullAngle = self.updatedRotationAngle - 360
//                    } else {
//                        fullAngle = self.updatedRotationAngle + 360
//                    }
//                    
//                    withAnimation(.linear(duration: rotationDuration).repeatForever(autoreverses: false)) {
//                        self.updatedRotationAngle = fullAngle
//                    }
//                    self.isRotatingClockwise.toggle()
//                    self.recordRotationAngle(self.isRotatingClockwise)
//                }) {
//                    Text("Start")
//                        .bold()
//                        .font(.system(size: 25))
//                        .frame(width: 200)
//                        .foregroundColor(.white)
//                        .padding(.all, 10)
//                        .background(Color.pink)
//                        .cornerRadius(10)
//                }
                Spacer()
            }
        }
    }
    
    //keeps a record of the angle in rotation through a timer
    func recordRotationAngle(_ isClockwise: Bool) {
        //increment angle every 0.01 seconds
        trayAngleScheduler = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            if isClockwise {
                currentRotationAngle += 1.2  //360 deg in 3s -> 1.2 deg in 0.01s
            } else {
                currentRotationAngle -= 1.2
            }
        }
        trayAngleScheduler?.fire()
    } 
    
    
    func stopRecordingRotationAngle() {
        self.trayAngleScheduler?.invalidate()
        self.trayAngleScheduler = nil
    }
    
    
    //check if correct color is caught in the tray
    func checkIfScored(_ currentCoinColor: Color) -> Bool {
        var factor = Int(self.currentRotationAngle/360)
        if self.currentRotationAngle < 0 && factor == 0 {
            factor = -1  //convert angles between -360 and 0 to positive
        }
        
        //convert angle to be in the range 0-360
        let currentNormalisedAngle: CGFloat = self.currentRotationAngle - Double(factor*360)
        
        var currentCoinColorPosition = self.colorAngleDict[currentCoinColor]! + currentNormalisedAngle
        if currentCoinColorPosition > 360 {
            currentCoinColorPosition -= 360
        }
        
        //check if coin is caught in the -40 to 40 degree range
        if (currentCoinColorPosition >= 0 && currentCoinColorPosition <= 40) || (currentCoinColorPosition >= 320 && currentCoinColorPosition <= 360) {
            return true
        } else {
            return false
        }
    }
}


struct ColorCatchView_Previews: PreviewProvider {
    static var previews: some View {
        ColorCatchView()
    }
} 
